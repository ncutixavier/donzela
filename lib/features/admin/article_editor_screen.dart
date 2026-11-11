import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../data/database/database.dart';
import '../../data/repositories/content_repository.dart';
import '../learn/category_labels.dart';
import '../learn/learn_controller.dart';
import 'admin_controller.dart';
import 'article_publish.dart';

/// Add or edit a Learn article. Only the super-admin can open this (the Learn
/// tab shows the entry points only to the super-admin, and Firestore enforces
/// it on the server). Pops with `true` when something changed.
///
/// The body is Markdown: a toolbar adds the markers around the selection, and
/// the Preview tab shows how the article will look.
class ArticleEditorScreen extends StatefulWidget {
  const ArticleEditorScreen({
    super.key,
    this.existing,
    this.source,
    required this.lang,
    required this.categories,
  });

  /// Null for a new article.
  final ArticleRow? existing;

  /// Set when translating: the article in another language. Its text is
  /// copied in, and the translation keeps the same id.
  final ArticleRow? source;
  final String lang;

  /// Category keys offered in the picker (defaults plus existing ones).
  final List<String> categories;

  @override
  State<ArticleEditorScreen> createState() => _ArticleEditorScreenState();
}

class _ArticleEditorScreenState extends State<ArticleEditorScreen> {
  late final _title = TextEditingController(
      text: widget.existing?.title ?? widget.source?.title ?? '');
  late final _body = TextEditingController(
      text: widget.existing?.body ?? widget.source?.body ?? '');
  // A translation needs its own reviewer, so the source's reviewer is not copied.
  late final _reviewer = TextEditingController(
      text: (widget.existing?.reviewedBy ?? '') == defaultReviewer
          ? ''
          : widget.existing?.reviewedBy ?? '');
  late String _lang = widget.existing?.lang ?? widget.lang;
  // The category picker's own controller, set when its field is built.
  TextEditingController? _categoryText;
  bool _preview = false;
  bool _saving = false;

  /// The article in each language it exists in, for the Translations section.
  Map<String, ArticleRow> _rows = const {};

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    final id = widget.existing?.id;
    if (id == null) return;
    final rows = await context.read<LearnController>().articlesOf(id);
    if (mounted) setState(() => _rows = rows);
  }

  /// Opens the editor for one language of this article. A language that
  /// does not exist yet starts as a copy of the article being edited.
  Future<void> _openLanguage(String lang) async {
    final article = widget.existing;
    if (article == null) return;
    // The existing translation (if any) is loaded before the editor opens.
    final existing = await context.read<LearnController>().fetch(article.id, lang);
    if (!mounted) return;
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ArticleEditorScreen(
          existing: existing,
          source: article,
          lang: lang,
          categories: widget.categories,
        ),
      ),
    );
    if (changed == true && mounted) await _loadLanguages();
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    _reviewer.dispose();
    super.dispose();
  }

  /// Turns what the admin typed into a category key. A built-in label (in any
  /// language) maps back to its key; anything else becomes a new category.
  String _keyFor(AppLocalizations l, String typed) {
    final t = typed.trim().toLowerCase();
    for (final key in widget.categories) {
      if (categoryLabel(l, key).toLowerCase() == t) return key;
    }
    return AdminController.categoryKey(typed);
  }

  String _fieldName(AppLocalizations l, String field) => switch (field) {
        'title' => l.fieldTitle,
        'body' => l.fieldBody,
        'category' => l.fieldCategory,
        _ => l.fieldReviewer,
      };

  /// Human-readable list of what is missing, per language.
  String _problemText(AppLocalizations l, Map<String, List<String>> problems) {
    return problems.entries.map((e) {
      final what = e.value.contains('missing')
          ? l.statusMissing
          : e.value.map((f) => _fieldName(l, f)).join(', ');
      return '${_langName(l, e.key)}: $what';
    }).join('; ');
  }

  /// Saves this language as a draft, then publishes all languages together.
  /// Nothing goes live unless every language is ready.
  Future<void> _publish() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final admin = context.read<AdminController>();
    final id = widget.existing?.id;
    if (id == null) return;
    setState(() => _saving = true);
    try {
      await admin.saveDraft(
            id: id,
            lang: _lang,
            category: _keyFor(l, _categoryText?.text ?? ''),
            title: _title.text,
            body: _body.text,
            reviewer: _reviewer.text,
          );
      final synced = await admin.publishArticle(id);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(synced ? l.publishedAll : l.adminSavedLocal)),
      );
      Navigator.of(context).pop(true);
    } on PublishIncomplete catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('${l.publishNotReady}: ${_problemText(l, e.problems)}')),
        );
        setState(() => _saving = false);
      }
    } catch (_) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text(l.authSignInFailed)));
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _save() async {
    final l = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);
    if (_title.text.trim().isEmpty || _body.text.trim().isEmpty) {
      messenger.showSnackBar(SnackBar(content: Text(l.adminRequired)));
      return;
    }
    setState(() => _saving = true);
    try {
      final synced = await context.read<AdminController>().saveDraft(
            id: widget.existing?.id ?? widget.source?.id,
            lang: _lang,
            category: _keyFor(l, _categoryText?.text ?? ''),
            title: _title.text,
            body: _body.text,
            reviewer: _reviewer.text,
          );
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text(synced ? l.adminSaved : l.adminSavedLocal)));
      nav.pop(true);
    } catch (_) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text(l.authSignInFailed)));
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _delete() async {
    final l = AppLocalizations.of(context);
    final existing = widget.existing!;
    final nav = Navigator.of(context);
    final admin = context.read<AdminController>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.logDeleteTitle),
        content: Text(l.adminDeleteBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancelBtn)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.deleteBtn),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await admin.deleteArticle(existing.id, existing.lang);
    if (mounted) nav.pop(true);
  }

  // ---- Markdown toolbar -------------------------------------------------

  /// Puts [before] and [after] around the selection (or between them when
  /// nothing is selected) and keeps the cursor in a sensible place.
  void _wrap(String before, String after) {
    final v = _body.value;
    final sel = v.selection.isValid ? v.selection : TextSelection.collapsed(offset: v.text.length);
    final selected = v.text.substring(sel.start, sel.end);
    final out = v.text.replaceRange(sel.start, sel.end, '$before$selected$after');
    final cursor = selected.isEmpty
        ? sel.start + before.length
        : sel.start + before.length + selected.length + after.length;
    _body.value = TextEditingValue(text: out, selection: TextSelection.collapsed(offset: cursor));
  }

  /// Adds [prefix] at the start of the line the cursor is on (headings, lists, quotes).
  void _linePrefix(String prefix) {
    final v = _body.value;
    final cursor = v.selection.isValid ? v.selection.start : v.text.length;
    final lineStart = cursor == 0 ? 0 : v.text.lastIndexOf('\n', cursor - 1) + 1;
    final out = v.text.replaceRange(lineStart, lineStart, prefix);
    _body.value = TextEditingValue(
      text: out,
      selection: TextSelection.collapsed(offset: cursor + prefix.length),
    );
  }

  Widget _toolButton(IconData icon, String tip, VoidCallback onPressed) => IconButton(
        tooltip: tip,
        icon: Icon(icon, color: AppColors.brown),
        onPressed: _saving ? null : onPressed,
      );

  Widget _toolbar(AppLocalizations l) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _toolButton(Icons.format_bold, l.boldTip, () => _wrap('**', '**')),
            _toolButton(Icons.format_italic, l.italicTip, () => _wrap('*', '*')),
            _toolButton(Icons.title, l.headingTip, () => _linePrefix('## ')),
            _toolButton(Icons.format_list_bulleted, l.listTip, () => _linePrefix('- ')),
            _toolButton(Icons.format_quote, l.quoteTip, () => _linePrefix('> ')),
            _toolButton(Icons.link, l.linkTip, () => _wrap('[', '](https://)')),
          ],
        ),
      );

  Widget _bodyEditor(AppLocalizations l, ThemeData theme) {
    if (_preview) {
      return Container(
        constraints: const BoxConstraints(minHeight: 200),
        padding: const EdgeInsets.all(AppSpace.md),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(AppRadius.control),
        ),
        child: _body.text.trim().isEmpty
            ? Text(l.previewEmpty, style: theme.textTheme.bodyMedium)
            : MarkdownBody(
                data: _body.text,
                styleSheet: MarkdownStyleSheet.fromTheme(theme)
                    .copyWith(p: theme.textTheme.bodyLarge),
              ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _toolbar(l),
        TextField(
          controller: _body,
          maxLines: 14,
          minLines: 8,
          decoration: InputDecoration(labelText: l.fieldBody, alignLabelWithHint: true),
        ),
      ],
    );
  }

  String _langName(AppLocalizations l, String lang) => switch (lang) {
        'rw' => l.langRw,
        'fr' => l.langFr,
        _ => l.langEn,
      };

  String _statusText(AppLocalizations l, String lang) {
    final row = _rows[lang];
    if (row == null) return l.translateNow;
    return row.reviewedBy != null ? l.statusPublished : l.statusDraft;
  }

  /// Each language of the app, with whether this article exists in it yet.
  /// Missing ones start a translation; existing ones open for editing.
  Widget _translationsSection(AppLocalizations l, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.translationsTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: AppSpace.sm),
            Wrap(
              spacing: AppSpace.sm,
              runSpacing: AppSpace.sm,
              children: [
                for (final lang in contentLanguages)
                  ActionChip(
                    avatar: Icon(
                      _rows[lang]?.reviewedBy != null
                          ? Icons.check_circle
                          : _rows.containsKey(lang)
                              ? Icons.edit_note
                              : Icons.translate,
                      size: 18,
                      color: _rows[lang]?.reviewedBy != null
                          ? AppColors.terracotta
                          : AppColors.brown,
                    ),
                    label: Text(
                      '${_langName(l, lang)} · ${_statusText(l, lang)}',
                    ),
                    onPressed: lang == _lang ? null : () => _openLanguage(lang),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final editing = widget.existing != null;
    final translating = widget.source != null && widget.existing == null;
    return Scaffold(
      appBar: AppBar(
        title: Text(translating
            ? l.translateArticle
            : editing
                ? l.adminEditArticle
                : l.adminAddArticle),
        actions: [
          if (editing)
            IconButton(
              tooltip: l.deleteBtn,
              icon: const Icon(Icons.delete_outline, color: AppColors.danger),
              onPressed: _saving ? null : _delete,
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpace.lg),
        children: [
          TextField(
            controller: _title,
            decoration: InputDecoration(labelText: l.fieldTitle),
          ),
          const SizedBox(height: AppSpace.md),
          DropdownButtonFormField<String>(
            initialValue: _lang,
            decoration: InputDecoration(labelText: l.fieldLanguage),
            items: [
              DropdownMenuItem(value: 'rw', child: Text(l.langRw)),
              DropdownMenuItem(value: 'en', child: Text(l.langEn)),
              DropdownMenuItem(value: 'fr', child: Text(l.langFr)),
            ],
            onChanged: editing ? null : (v) => setState(() => _lang = v ?? _lang),
          ),
          const SizedBox(height: AppSpace.md),
          Autocomplete<String>(
            // Shows the current category; the admin can pick one or type a new one.
            initialValue: TextEditingValue(
              text: categoryLabel(
                  l, (widget.existing ?? widget.source)?.category ?? 'mine'),
            ),
            optionsBuilder: (value) {
              final q = value.text.trim().toLowerCase();
              final labels = widget.categories.map((k) => categoryLabel(l, k));
              return q.isEmpty ? labels : labels.where((s) => s.toLowerCase().contains(q));
            },
            fieldViewBuilder: (context, controller, focus, onSubmit) {
              _categoryText = controller;
              return TextField(
                controller: controller,
                focusNode: focus,
                onSubmitted: (_) => onSubmit(),
                decoration: InputDecoration(
                  labelText: l.fieldCategory,
                  helperText: l.categoryHint,
                ),
              );
            },
          ),
          const SizedBox(height: AppSpace.md),
          if (editing) _translationsSection(l, theme),
          const SizedBox(height: AppSpace.md),
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: false, label: Text(l.editTab), icon: const Icon(Icons.edit_outlined)),
              ButtonSegment(value: true, label: Text(l.previewTab), icon: const Icon(Icons.visibility_outlined)),
            ],
            selected: {_preview},
            onSelectionChanged: (s) => setState(() => _preview = s.first),
          ),
          const SizedBox(height: AppSpace.sm),
          _bodyEditor(l, theme),
          const SizedBox(height: AppSpace.md),
          TextField(
            controller: _reviewer,
            decoration: InputDecoration(
              labelText: l.reviewerLabel,
              helperText: l.reviewerHint,
            ),
          ),
          const SizedBox(height: AppSpace.xl),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(l.saveDraftBtn),
          ),
          if (editing) ...[
            const SizedBox(height: AppSpace.sm),
            OutlinedButton(
              style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              onPressed: _saving ? null : _publish,
              child: Text(l.publishAllBtn),
            ),
          ],
        ],
      ),
    );
  }
}
