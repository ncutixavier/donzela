import 'package:donzela/data/database/database.dart';
import 'package:donzela/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'wait.dart';

void main() {
  testWidgets('Log today opens the sheet without layout errors', (tester) async {
    tester.view.physicalSize = const Size(360 * 2.5, 740 * 2.5);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.resetPhysicalSize);

    final db = DonzelaDatabase.memory();
    addTearDown(db.close);
    await tester.runAsync(() => db.settingsDao.put('onboarding_done', '1'));
    final root = await tester.runAsync(
        () => buildRoot(database: db, initNotifications: false));
    await tester.pumpWidget(root!);
    await waitFor(tester, find.text('Andika uyu munsi'));

    await tester.tap(find.text('Andika uyu munsi'));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));

    expect(tester.takeException(), isNull);
    expect(find.text('Bika'), findsOneWidget);
  });
}
