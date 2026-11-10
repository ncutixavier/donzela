import 'package:donzela/data/database/database.dart';
import 'package:donzela/data/repositories/daily_log_repository.dart';
import 'package:donzela/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> settle(WidgetTester tester, {int rounds = 6}) async {
  for (var i = 0; i < rounds; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 30)));
    await tester.pump(const Duration(milliseconds: 150));
  }
}

void main() {
  testWidgets('a logged day appears in Logs and drives Insights', (tester) async {
    tester.view.physicalSize = const Size(360 * 2.5, 740 * 2.5);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.resetPhysicalSize);

    final db = DonzelaDatabase.memory();
    addTearDown(db.close);
    await tester.runAsync(() async {
      await db.settingsDao.put('onboarding_done', '1');
      await DailyLogRepository(db).save(DayLog(
        date: DateTime.now(),
        flow: FlowLevel.medium,
        symptoms: ['cramps'],
        mood: ['calm'],
        note: 'Ndi hano',
      ));
    });
    final root = await tester.runAsync(
        () => buildRoot(database: db, initNotifications: false));
    await tester.pumpWidget(root!);
    await settle(tester);

    // Calendar tab, then the Logs button in the history card.
    await tester.tap(find.text('Kalendari'));
    await settle(tester);
    await tester.scrollUntilVisible(
      find.widgetWithText(OutlinedButton, 'Ibyo nanditse'),
      200,
      scrollable: find.byType(Scrollable).hitTestable().first,
    );
    // Lift the button clear of the bottom navigation bar before tapping.
    await tester.drag(
      find.byType(Scrollable).hitTestable().first,
      const Offset(0, -200),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.widgetWithText(OutlinedButton, 'Ibyo nanditse'));
    await settle(tester);
    expect(find.text('Ibyo nanditse'), findsWidgets);

    // The logged day shows its symptom and note.
    expect(find.text('Kuribwa mu nda'), findsWidgets);
    expect(find.text('Ndi hano'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Insights tab reflects the same data.
    await tester.tap(find.text('Imibare'));
    await settle(tester);
    expect(find.text('Iminsi wanditse: 1'), findsOneWidget);
    expect(find.text('Kuribwa mu nda'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
