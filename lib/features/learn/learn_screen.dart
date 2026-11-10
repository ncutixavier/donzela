import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/l10n/localization.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/imigongo.dart';
import '../../data/database/database.dart';
import 'learn_controller.dart';

const _categories = [
  ('all', 'filterAll'),
  ('mine', 'filterMine'),
  ('hygiene', 'filterHygiene'),
  ('contraception', 'filterContraception'),
];

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
    WidgetsBinding.instance.addPostFrameCallback((_) => ctrl.load(lang: lang));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  String _categoryLabel(AppLocalizations l, String key) => switch (key) {
        'mine' => l.filterMine,
        'hygiene' => l.filterHygiene,
        'contraception' => l.filterContraception,
        _ => l.filterAll,
      };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final ctrl = context.watch<LearnController>();
    final lang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpace.lg),
          children: [
            Text(l.learnTitle, style: Theme.of(context).textTheme.headlineMedium),
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
                for (final c in _categories)
                  ChoiceChip(
                    label: Text(_categoryLabel(l, c.$1)),
                    selected: ctrl.category == c.$1,
                    selectedColor: AppColors.brown,
                    labelStyle: TextStyle(
                      color: ctrl.category == c.$1 ? Colors.white : AppColors.ink,
                      fontWeight: FontWeight.w700,
                    ),
                    onSelected: (_) => ctrl.setCategory(c.$1),
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
                    category: _categoryLabel(l, a.category),
                    title: a.title,
                    lang: lang,
                    draft: a.reviewedBy == null,
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
    required this.draft,
  });

  final String id;
  final String category;
  final String title;
  final String lang;
  final bool draft;

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
                    if (draft) ...[
                      const SizedBox(height: 4),
                      _DraftBadge(text: AppLocalizations.of(context).draftBadge),
                    ],
                  ],
                ),
              ),
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
    final draft = a.reviewedBy == null;

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
                if (draft)
                  _DraftBadge(text: l.draftBadge)
                else
                  Row(
                    children: [
                      const Icon(Icons.verified_outlined, color: AppColors.sage, size: 18),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          l.reviewedBy(
                            a.reviewedBy!,
                            a.reviewedOn == null ? '' : l.dayMonthYear(a.reviewedOn!),
                          ),
                          style: const TextStyle(color: AppColors.sage, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
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

class _DraftBadge extends StatelessWidget {
  const _DraftBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.goldSoft,
        borderRadius: BorderRadius.circular(AppRadius.chip),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.brown,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
