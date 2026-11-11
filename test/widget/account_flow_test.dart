import 'package:donzela/data/database/database.dart';
import 'package:donzela/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'wait.dart';

void main() {
  testWidgets('Account tab shows sign-in, and says so when the cloud is off',
      (tester) async {
    tester.view.physicalSize = const Size(360 * 2.5, 740 * 2.5);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.resetPhysicalSize);

    final db = DonzelaDatabase.memory();
    addTearDown(db.close);
    await tester.runAsync(() => db.settingsDao.put('onboarding_done', '1'));
    final root = await tester.runAsync(
        () => buildRoot(database: db, initNotifications: false));
    await tester.pumpWidget(root!);
    await waitFor(tester, find.text('Uyu munsi'));

    await tester.tap(find.text('Konti'));
    await waitFor(tester, find.text('Injira ukoresheje Google'));

    expect(find.text('Injira ukoresheje Google'), findsOneWidget);
    expect(find.text('Kopi ntiraboneka ubu. Gerageza nyuma.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
