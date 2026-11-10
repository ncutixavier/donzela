import 'package:donzela/data/database/database.dart';
import 'package:donzela/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> settle(WidgetTester tester) async {
  // Database writes complete on real async time; let them finish, then pump
  // the resulting route changes.
  for (var i = 0; i < 5; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 30)));
    await tester.pump(const Duration(milliseconds: 100));
  }
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  testWidgets('new user finishes onboarding and lands on first-use Today',
      (tester) async {
    tester.view.physicalSize = const Size(360 * 2.5, 740 * 2.5);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.resetPhysicalSize);

    final db = DonzelaDatabase.memory();
    addTearDown(db.close);
    final root = await tester.runAsync(
        () => buildRoot(database: db, initNotifications: false));
    await tester.pumpWidget(root!);
    await settle(tester);

    // 1. Language (Kinyarwanda is the default).
    await tester.tap(find.text('Komeza'));
    await settle(tester);

    // 2. Privacy promise.
    expect(find.text('Ndemeye, komeza'), findsOneWidget);
    await tester.tap(find.text('Ndemeye, komeza'));
    await settle(tester);

    // 3. Last period: "Sinibuka" fills in an estimate, which enables Komeza.
    expect(find.text('3 kuri 5'), findsOneWidget);
    await tester.ensureVisible(find.text('Sinibuka'));
    await tester.tap(find.text('Sinibuka'));
    await settle(tester);
    await tester.tap(find.text('Komeza'));
    await settle(tester);

    // 4. Cycle and period lengths.
    expect(find.text('4 kuri 5'), findsOneWidget);
    await tester.tap(find.text('Komeza'));
    await settle(tester);

    // 5. PIN (skipped here) and reminders; finish.
    expect(find.text('5 kuri 5'), findsOneWidget);
    await tester.tap(find.text('Simbuka'));
    await settle(tester);

    // Screen 6: Today, first-use variant.
    expect(find.text('Igereranya rya mbere'), findsOneWidget);
    expect(find.text('Andika uyu munsi'), findsOneWidget);
    expect(tester.takeException(), isNull);

    // Onboarding is saved, so a restart would go straight to Today.
    final saved = await tester.runAsync(() => db.settingsDao.readAll());
    expect(saved!['onboarding_done'], '1');
    final cycles = await tester.runAsync(() => db.cyclesDao.activeCycles());
    expect(cycles!.length, 1);
    expect(cycles.single.isEstimate, isTrue);
  });
}
