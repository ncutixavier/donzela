import 'package:donzela/data/database/database.dart';
import 'package:donzela/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> settle(WidgetTester tester, {int rounds = 5}) async {
  for (var i = 0; i < rounds; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 30)));
    await tester.pump(const Duration(milliseconds: 150));
  }
}

void main() {
  testWidgets('Learn lists articles and opens one reviewed by the Donzela Team',
      (tester) async {
    tester.view.physicalSize = const Size(360 * 2.5, 740 * 2.5);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.resetPhysicalSize);

    final db = DonzelaDatabase.memory();
    addTearDown(db.close);
    // Skip onboarding so the app opens on the tabs.
    await tester.runAsync(() => db.settingsDao.put('onboarding_done', '1'));
    final root = await tester.runAsync(
        () => buildRoot(database: db, initNotifications: false));
    await tester.pumpWidget(root!);
    await settle(tester);

    await tester.tap(find.text('Iga'));
    await settle(tester);

    // The list is lazy, so scroll the card into view before tapping it.
    await tester.scrollUntilVisible(
      find.text('Ukwezi gusanzwe ni ukuhe?'),
      200,
      scrollable: find.byType(Scrollable).hitTestable().first,
    );
    // Lift the card clear of the bottom navigation bar before tapping.
    await tester.drag(
      find.byType(Scrollable).hitTestable().first,
      const Offset(0, -200),
    );
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('Ukwezi gusanzwe ni ukuhe?'));
    await tester.pump(const Duration(milliseconds: 500));
    await settle(tester);
    await tester.pump(const Duration(milliseconds: 500));

    // Every article is shown as reviewed; the default reviewer is the Donzela Team.
    expect(find.textContaining('Donzela Team'), findsWidgets);
    expect(find.textContaining('ntirasuzumwa'), findsNothing);
    // The Markdown body is on screen.
    expect(find.byType(MarkdownBody), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
