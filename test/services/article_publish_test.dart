import 'package:donzela/features/admin/article_publish.dart';
import 'package:flutter_test/flutter_test.dart';

LanguageDraft ready() => const LanguageDraft(
      title: 'Title',
      body: 'Body',
      category: 'mine',
      proposedReviewer: 'Dr A',
    );

void main() {
  group('publishing needs every language', () {
    test('publishes when all three languages are ready', () {
      final check = PublishCheck.of({'rw': ready(), 'en': ready(), 'fr': ready()});
      expect(check.ok, isTrue);
    });

    test('a missing language blocks publishing and is named', () {
      final check = PublishCheck.of({'en': ready(), 'fr': ready()});
      expect(check.ok, isFalse);
      expect(check.problems, {'rw': ['missing']});
    });

    test('a missing reviewer does not block: the Donzela Team is the default', () {
      final check = PublishCheck.of({
        'rw': ready(),
        'en': const LanguageDraft(title: 'T', body: 'B', category: 'mine', proposedReviewer: ' '),
        'fr': ready(),
      });
      expect(check.ok, isTrue);
    });

    test('empty title, body or category are each reported', () {
      final check = PublishCheck.of({
        'rw': ready(),
        'en': const LanguageDraft(title: '', body: null, category: 'x', proposedReviewer: 'Dr'),
        'fr': ready(),
      });
      expect(check.problems, {'en': ['title', 'body']});
    });
  });
}
