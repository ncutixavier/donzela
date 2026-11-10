import 'package:donzela/data/database/database.dart';
import 'package:donzela/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'wait.dart';

Future<void> pumpPhone(WidgetTester tester, Widget app) async {
  // Low-end Android size: 360 x 740 dp at 2.5x.
  tester.view.physicalSize = const Size(360 * 2.5, 740 * 2.5);
  tester.view.devicePixelRatio = 2.5;
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(app);
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  testWidgets('starts in Kinyarwanda and onboarding step 1', (tester) async {
    final db = DonzelaDatabase.memory();
    addTearDown(db.close);
    final root = await tester.runAsync(
        () => buildRoot(database: db, initNotifications: false));
    await pumpPhone(tester, root!);

    expect(tester.takeException(), isNull);
    expect(find.text('Komeza'), findsOneWidget);
    expect(find.text('Ikinyarwanda'), findsOneWidget);
  });

  testWidgets('changing language rebuilds visible text at once', (tester) async {
    final db = DonzelaDatabase.memory();
    addTearDown(db.close);
    final root = await tester.runAsync(
        () => buildRoot(database: db, initNotifications: false));
    await pumpPhone(tester, root!);

    await tester.tap(find.text('English'));
    await waitFor(tester, find.text('Continue'));
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Komeza'), findsNothing);

    await tester.tap(find.text('Français'));
    await waitFor(tester, find.text('Continuer'));
    expect(find.text('Continuer'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('continue moves to privacy step, then back resumes at same step',
      (tester) async {
    final db = DonzelaDatabase.memory();
    addTearDown(db.close);
    final root = await tester.runAsync(
        () => buildRoot(database: db, initNotifications: false));
    await pumpPhone(tester, root!);

    await tester.tap(find.text('Komeza'));
    await waitFor(tester, find.text('Ndemeye, komeza'));
    expect(find.text('Ndemeye, komeza'), findsOneWidget);
    expect(find.text('2 kuri 5'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
