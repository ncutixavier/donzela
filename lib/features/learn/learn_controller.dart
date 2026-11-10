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
  String _query = '';
  String _lang = 'rw';
  bool _loading = true;

  List<ArticleRow> get articles => _articles;
  String get category => _category;
  String get query => _query;
  bool get loading => _loading;

  Future<void> load({required String lang}) async {
    _lang = lang;
    _loading = true;
    notifyListeners();
    _articles = await _content.visibleArticles(
      lang,
      category: _category,
      query: _query,
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

  Future<void> toggleSaved(String id, String lang, bool saved) async {
    await _content.setSaved(id, lang, saved);
    await load(lang: _lang);
  }
}
