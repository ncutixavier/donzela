import 'package:flutter/foundation.dart';

import '../../data/database/database.dart';
import '../../data/repositories/content_repository.dart';
import '../../services/analytics/analytics_service.dart';

/// Learn list and article page (F6). Only reviewed articles are returned by
/// the repository, so unreviewed content can never reach this screen.
class LearnController extends ChangeNotifier {
  LearnController({
    required ContentRepository content,
    required AnalyticsService analytics,
  })  : _content = content,
        _analytics = analytics;

  final ContentRepository _content;
  final AnalyticsService _analytics;

  List<ArticleRow> _articles = const [];
  String _category = 'all';
  bool _showDrafts = false;
  String _query = '';
  String _lang = 'rw';
  bool _loading = true;

  List<String> _categories = ContentRepository.defaultCategories;
  List<String> _usedCategories = const [];

  List<ArticleRow> get articles => _articles;

  /// Every category the admin can pick (defaults plus any in use). Used by the editor.
  List<String> get categories => _categories;

  /// Only the categories that have at least one article the reader can see.
  /// Used by the Learn filter chips, so an empty category is not offered.
  List<String> get usedCategories => _usedCategories;
  String get category => _category;
  String get query => _query;
  bool get loading => _loading;

  /// [showDrafts] is set for the super-admin, who sees unreviewed articles.
  Future<void> load({required String lang, bool? showDrafts}) async {
    _lang = lang;
    if (showDrafts != null) _showDrafts = showDrafts;
    _loading = true;
    notifyListeners();
    _categories = await _content.categories();
    final visible = await _content.visibleArticles(lang, showDrafts: _showDrafts);
    _usedCategories = usedCategoryKeys(visible, _categories);
    _articles = await _content.visibleArticles(
      lang,
      category: _category,
      query: _query,
      showDrafts: _showDrafts,
    );
    _loading = false;
    notifyListeners();
  }

  Future<void> setCategory(String c) async {
    _category = c;
    await load(lang: _lang);
  }

  Future<void> setQuery(String q) async {
    _query = q;
    await load(lang: _lang);
  }

  /// Opens an article and records the view. Use [fetch] to re-read it
  /// without counting another view.
  Future<ArticleRow?> open(String id, String lang) async {
    _analytics.track('article_opened', {'article_id': id});
    return _content.article(id, lang);
  }

  Future<ArticleRow?> fetch(String id, String lang) => _content.article(id, lang);

  /// The article in each language it exists in, for the translation status.
  Future<Map<String, ArticleRow>> articlesOf(String id) => _content.articlesOf(id);

  Future<void> toggleSaved(String id, String lang, bool saved) async {
    await _content.setSaved(id, lang, saved);
    await load(lang: _lang);
  }
}

/// The keys in [all] that at least one article uses, in the same order.
List<String> usedCategoryKeys(List<ArticleRow> articles, List<String> all) {
  final used = {for (final a in articles) a.category};
  return [for (final c in all) if (used.contains(c)) c];
}
