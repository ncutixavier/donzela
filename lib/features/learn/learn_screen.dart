import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/imigongo.dart';
import '../admin/admin_controller.dart';
import '../admin/article_publish.dart';
import '../admin/article_editor_screen.dart';
import '../account/cloud_controller.dart';
import '../account/content_refresh.dart';
import 'category_labels.dart';
import '../../data/database/database.dart';
import 'learn_controller.dart';

/// Learn list (screen 12). Cards open the article with a container
/// transform (OpenContainer).
class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  bool _started = false;
  final _search = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final lang = Localizations.localeOf(context).languageCode;
    final ctrl = context.read<LearnController>();
    // Loading notifies listeners, which must not happen during build.
    // The super-admin also sees unreviewed articles, so they can finish them.
    final isAdmin = context.read<AdminController>().isSuperAdmin;
    WidgetsBinding.instance.addPostFrameCallback((_) => ctrl.load(lang: lang, showDrafts: isAdmin));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _openEditor(ArticleRow? article) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ArticleEditorScreen(
          existing: article,
          lang: Localizations.localeOf(context).languageCode,
          categories: context.read<LearnController>().categories,
        ),
      ),
    );
    if (changed == true && mounted) _reload();
  }

  Future<void> _confirmDelete(ArticleRow a) async {
    final l = AppLocalizations.of(context);
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
    await admin.deleteArticle(a.id, a.lang);
    if (mounted) _reload();
  }

  bool _refreshing = false;

  /// Pulls the latest articles, then shows the list again.
  Future<void> _refresh() async {
    setState(() => _refreshing = true);
    final ok = await refreshPublicContent(context);
    if (!mounted) return;
    setState(() => _refreshing = false);
    if (ok) {
      final lang = Localizations.localeOf(context).languageCode;
      final isAdmin = context.read<AdminController>().isSuperAdmin;
      await context.read<LearnController>().load(lang: lang, showDrafts: isAdmin);
    }
  }

  void _reload() {
    final lang = Localizations.localeOf(context).languageCode;
    context.read<LearnController>().load(lang: lang, showDrafts: true);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final ctrl = context.watch<LearnController>();
    final lang = Localizations.localeOf(context).languageCode;

    // Rebuild when the account changes, so the admin tools appear after sign-in.
    context.watch<CloudController>();
    final isAdmin = context.read<AdminController>().isSuperAdmin;

    return Scaffold(
      floatingActionButton: isAdmin
          ? FloatingActionButton.extended(
              onPressed: () => _openEditor(null),
              icon: const Icon(Icons.add),
              label: Text(l.adminAddArticle),
            )
          : null,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.lg),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(l.learnTitle, style: Theme.of(context).textTheme.headlineMedium),
                ),
                RefreshContentButton(busy: _refreshing, onPressed: _refresh),
              ],
            ),
            const SizedBox(height: 4),
            Text(l.learnSubtitle, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpace.lg),
            TextField(
              controller: _search,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l.searchHint,
                prefixIcon: const Icon(Icons.search),
              ),
              onSubmitted: (q) => ctrl.setQuery(q),
            ),
            const SizedBox(height: AppSpace.md),
            Wrap(
              spacing: AppSpace.sm,
              runSpacing: AppSpace.sm,
              children: [
                for (final key in ['all', ...ctrl.usedCategories])
                  ChoiceChip(
                    label: Text(categoryLabel(l, key)),
                    selected: ctrl.category == key,
                    selectedColor: AppColors.brown,
                    labelStyle: TextStyle(
                      color: ctrl.category == key ? Colors.white : AppColors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                    onSelected: (_) => ctrl.setCategory(key),
                  ),
              ],
            ),
            const SizedBox(height: AppSpace.lg),
            if (ctrl.loading)
              const Center(child: Padding(
                padding: EdgeInsets.all(AppSpace.xl),
                child: CircularProgressIndicator(),
              ))
            else if (ctrl.articles.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpace.xl),
                child: Text(l.noArticles,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium),
              )
            else
              for (final a in ctrl.articles)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpace.md),
                  child: _ArticleCard(
                    id: a.id,
                    category: categoryLabel(l, a.category),
                    title: a.title,
                    lang: lang,
                    onEdit: isAdmin ? () => _openEditor(a) : null,
                    onDelete: isAdmin ? () => _confirmDelete(a) : null,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  const _ArticleCard({
    required this.id,
    required this.category,
    required this.title,
    required this.lang,
    this.onEdit,
    this.onDelete,
  });

  final String id;
  final String category;
  final String title;
  final String lang;

  /// Set only for the super-admin.
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OpenContainer<void>(
      transitionDuration: const Duration(milliseconds: 400),
      closedElevation: 0,
      openElevation: 0,
      closedColor: AppColors.surface,
      openColor: AppColors.cream,
      closedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
      closedBuilder: (context, open) => InkWell(
        borderRadius: BorderRadius.circular(AppRadius.card),
        onTap: open,
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.lg),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.blush,
                  borderRadius: BorderRadius.circular(AppRadius.control),
                ),
                child: const Icon(Icons.menu_book_outlined, color: AppColors.brown),
              ),
              const SizedBox(width: AppSpace.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(category, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              if (onEdit != null) ...[
                IconButton(
                  tooltip: AppLocalizations.of(context).adminEditArticle,
                  icon: const Icon(Icons.edit_outlined, color: AppColors.brown),
                  onPressed: onEdit,
                ),
                IconButton(
                  tooltip: AppLocalizations.of(context).deleteBtn,
                  icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                  onPressed: onDelete,
                ),
              ],
            ],
          ),
        ),
      ),
      openBuilder: (context, _) => ArticleScreen(articleId: id, lang: lang),
    );
  }
}

/// Article page (screen 13). Shows reviewer and review date; never renders an
/// article without a reviewer.
class ArticleScreen extends StatefulWidget {
  const ArticleScreen({super.key, required this.articleId, required this.lang});

  final String articleId;
  final String lang;

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  ArticleRow? _article;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    context.read<LearnController>().open(widget.articleId, widget.lang).then((a) {
      if (mounted) setState(() => _article = a);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final a = _article;
    final theme = Theme.of(context);

    if (a == null) {
      return Scaffold(appBar: AppBar(), body: const SizedBox.shrink());
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: l.saveArticle,
            icon: Icon(a.saved ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () async {
              final ctrl = context.read<LearnController>();
              await ctrl.toggleSaved(a.id, a.lang, !a.saved);
              final fresh = await ctrl.fetch(a.id, a.lang);
              if (mounted) setState(() => _article = fresh);
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 120,
            color: AppColors.brown,
            child: const Stack(
              children: [
                Positioned(top: 0, left: 0, right: 0, child: ZigzagBand(height: 14)),
                Positioned(bottom: 0, left: 0, right: 0,
                    child: ZigzagBand(height: 14, color: AppColors.terracotta)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpace.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a.title, style: theme.textTheme.headlineMedium),
                const SizedBox(height: AppSpace.sm),
                // Every article shown here is reviewed; the default reviewer is the Donzela Team.
                Row(
                  children: [
                    const Icon(Icons.verified_outlined, color: AppColors.sage, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        l.reviewedBy(
                          a.reviewedBy ?? defaultReviewer,
                          a.reviewedOn == null ? '' : l.dayMonthYear(a.reviewedOn!),
                        ),
                        style: const TextStyle(color: AppColors.sage, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                if (a.author != null) ...[
                  const SizedBox(height: 4),
                  Text(l.writtenBy(a.author!), style: theme.textTheme.bodyMedium),
                ],
                const SizedBox(height: 4),
                Text(
                  [
                    if (a.createdAt != null) l.createdOn(l.dayMonthYear(a.createdAt!)),
                    if (a.reviewedOn != null) l.publishedOn(l.dayMonthYear(a.reviewedOn!)),
                    l.updatedOn(l.dayMonthYear(a.updatedAt)),
                  ].join(' · '),
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: AppSpace.lg),
                MarkdownBody(
                  data: a.body,
                  styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                    p: theme.textTheme.bodyLarge,
                  ),
                ),
                const SizedBox(height: AppSpace.xl),
                FilledButton(
                  onPressed: () => context.go('/help'),
                  child: Text(l.helpTab),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

