import '../../core/l10n/localization.dart';

/// Label for a category key. The three built-in categories are translated;
/// a category the admin created shows as typed (first letter capitalised).
String categoryLabel(AppLocalizations l, String key) => switch (key) {
      'all' => l.filterAll,
      'mine' => l.filterMine,
      'hygiene' => l.filterHygiene,
      'contraception' => l.filterContraception,
      _ => prettyCategory(key),
    };

String prettyCategory(String key) {
  final s = key.replaceAll('-', ' ').trim();
  if (s.isEmpty) return key;
  return s[0].toUpperCase() + s.substring(1);
}
