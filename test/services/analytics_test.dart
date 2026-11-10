import 'package:donzela/services/analytics/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('only allowlisted events are sent', () {
    final sent = <String>[];
    final a = AnalyticsService(sink: (name, _) => sent.add(name));
    a.track('day_logged');
    a.track('made_up_event');
    expect(sent, ['day_logged']);
  });

  test('health fields never leave the app as parameters', () {
    final sent = <Map<String, String>>[];
    final a = AnalyticsService(sink: (_, p) => sent.add(p));
    a.track('article_opened', {
      'article_id': 'cycle-basics',
      'symptoms': 'cramps',
      'flow': 'heavy',
      'date': '2026-01-01',
    });
    a.track('reminder_enabled', {'type': 'period', 'note': 'secret'});
    expect(sent[0], {'article_id': 'cycle-basics'});
    expect(sent[1], {'type': 'period'});
  });

  test('reminder type must be one of the known types', () {
    final sent = <Map<String, String>>[];
    final a = AnalyticsService(sink: (_, p) => sent.add(p));
    a.track('reminder_enabled', {'type': 'Ukwezi 2026-01-01'});
    expect(sent.single, isEmpty);
  });

  test('disabled analytics sends nothing', () {
    var count = 0;
    final a = AnalyticsService(enabled: false, sink: (_, __) => count++);
    a.track('day_logged');
    expect(count, 0);
  });

  test('crash messages are redacted of numbers and dates', () {
    final msg = CrashReporter.redact('bad value 2026-01-09 for cycle 28');
    expect(msg, isNot(contains('2026')));
    expect(msg, isNot(contains('28')));
  });
}
