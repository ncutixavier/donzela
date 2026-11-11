import 'package:flutter_test/flutter_test.dart';

/// Pumps until [finder] matches, letting database writes finish on real time
/// in between. Fails with a clear message after [limit].
Future<void> waitFor(
  WidgetTester tester,
  Finder finder, {
  Duration limit = const Duration(seconds: 8),
}) async {
  final end = DateTime.now().add(limit);
  while (finder.evaluate().isEmpty) {
    if (DateTime.now().isAfter(end)) {
      fail('Timed out waiting for $finder');
    }
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
    await tester.pump(const Duration(milliseconds: 50));
  }
  await tester.pump(const Duration(milliseconds: 300));
}
