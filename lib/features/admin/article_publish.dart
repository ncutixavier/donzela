import '../../data/repositories/content_repository.dart';

/// Reviewer shown when none is named. Articles are reviewed by the Donzela
/// Team unless the admin names a specific health professional.
const defaultReviewer = 'Donzela Team';

/// What one language of an article needs before it can be published.
class LanguageDraft {
  const LanguageDraft({
    required this.title,
    required this.body,
    required this.category,
    required this.proposedReviewer,
  });

  final String? title;
  final String? body;
  final String? category;
  final String? proposedReviewer;
}

/// Problems that stop an article from being published, per language. A
/// language with no problems is ready. An article is published only when
/// every language in [contentLanguages] is ready, so users never meet a
/// half-translated article.
class PublishCheck {
  const PublishCheck(this.problems);

  /// Language code -> what is missing ('missing', 'title', 'body', 'category').
  final Map<String, List<String>> problems;

  bool get ok => problems.isEmpty;

  /// Checks every app language. [drafts] has an entry for each language the
  /// article exists in; a language without an entry is missing.
  static PublishCheck of(Map<String, LanguageDraft> drafts) {
    final problems = <String, List<String>>{};
    for (final lang in contentLanguages) {
      final d = drafts[lang];
      if (d == null) {
        problems[lang] = const ['missing'];
        continue;
      }
      final missing = <String>[
        if (_blank(d.title)) 'title',
        if (_blank(d.body)) 'body',
        if (_blank(d.category)) 'category',
      ];
      if (missing.isNotEmpty) problems[lang] = missing;
    }
    return PublishCheck(problems);
  }

  static bool _blank(String? v) => v == null || v.trim().isEmpty;
}
