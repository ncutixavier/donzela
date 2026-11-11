import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../l10n/app_localizations.dart';

export '../../l10n/app_localizations.dart';

/// Kinyarwanda is the default. Flutter ships no Material/Widgets/Cupertino
/// strings for `rw`, so those come from English. Every string the user sees
/// from our own code comes from the ARB files.
const supportedLocales = [Locale('rw'), Locale('en'), Locale('fr')];

Locale localeFor(String code) => supportedLocales.firstWhere(
      (l) => l.languageCode == code,
      orElse: () => const Locale('rw'),
    );

class _RwFallback<T> extends LocalizationsDelegate<T> {
  const _RwFallback(this._base);

  final LocalizationsDelegate<T> _base;

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'rw' || _base.isSupported(locale);

  @override
  Future<T> load(Locale locale) => _base.load(
        locale.languageCode == 'rw' ? const Locale('en') : locale,
      );

  @override
  bool shouldReload(covariant LocalizationsDelegate<T> old) => false;
}

/// Delegates for MaterialApp.localizationsDelegates.
const localizationDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  _RwFallback<MaterialLocalizations>(GlobalMaterialLocalizations.delegate),
  _RwFallback<WidgetsLocalizations>(GlobalWidgetsLocalizations.delegate),
  _RwFallback<CupertinoLocalizations>(GlobalCupertinoLocalizations.delegate),
];

/// Kinyarwanda and other dates are built from ARB names, since Flutter's
/// date formatter has no `rw` data.
extension DateText on AppLocalizations {
  List<String> get monthNames => [
        m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12,
      ];

  /// Single-letter/initial weekday labels, Monday first.
  List<String> get weekdayInitials => [w1, w2, w3, w4, w5, w6, w7];

  /// Full weekday names, Monday = index 0.
  List<String> get weekdayNames => [d1, d2, d3, d4, d5, d6, d7];

  /// "9 Ugushyingo 2026"
  String dayMonthYear(DateTime d) => '${d.day} ${monthNames[d.month - 1]} ${d.year}';

  /// "Ku wa mbere, 9 Ugushyingo" (rw), "On Monday, 9 November" (en/fr).
  String longDate(DateTime d) {
    final prefix = onWeekday.isEmpty ? '' : '$onWeekday ';
    return '$prefix${weekdayNames[d.weekday - 1]}, ${d.day} ${monthNames[d.month - 1]}';
  }

  /// Label for a symptom key from the daily log.
  String symptomLabel(String key) => switch (key) {
        'cramps' => symptomCramps,
        'headache' => symptomHeadache,
        'backache' => symptomBackache,
        'bloating' => symptomBloating,
        'acne' => symptomAcne,
        'breast' => symptomBreast,
        _ => symptomFatigue,
      };

  /// Label for a mood key from the daily log.
  String moodLabel(String key) => switch (key) {
        'calm' => moodCalm,
        'happy' => moodHappy,
        'sad' => moodSad,
        'irritable' => moodIrritable,
        _ => moodAnxious,
      };

  /// "Ugushyingo 2026"
  String monthYear(DateTime d) => '${monthNames[d.month - 1]} ${d.year}';
}
