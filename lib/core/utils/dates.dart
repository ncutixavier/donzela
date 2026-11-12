/// Day-only helpers. Every cycle and log date is stored at local midnight.
DateTime dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Stable text key for a day, used for `daily_logs.date` (yyyy-MM-dd).
String dayKey(DateTime d) {
  final day = dayOnly(d);
  return '${day.year.toString().padLeft(4, '0')}-'
      '${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';
}

DateTime parseDayKey(String key) {
  final parts = key.split('-');
  return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
}

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Whole days from [a] to [b] (b − a), ignoring time of day.
int daysBetween(DateTime a, DateTime b) =>
    DateTime.utc(b.year, b.month, b.day)
        .difference(DateTime.utc(a.year, a.month, a.day))
        .inDays;

DateTime addDays(DateTime d, int n) => DateTime(d.year, d.month, d.day + n);

/// dd/MM, used in the nurse report's "last period" box.
String shortDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';

String _two(int n) => n.toString().padLeft(2, '0');

/// Time with seconds, "00:16:32".
String timeWithSeconds(DateTime d) => '${_two(d.hour)}:${_two(d.minute)}:${_two(d.second)}';

/// Date and time to the minute, "12/11/2026 11:40".
String dateMinuteText(DateTime d) =>
    '${_two(d.day)}/${_two(d.month)}/${d.year} ${_two(d.hour)}:${_two(d.minute)}';

/// Numeric date and time, "11/12/2026 00:16:32" (day/month/year).
String dateTimeText(DateTime d) =>
    '${_two(d.day)}/${_two(d.month)}/${d.year} ${timeWithSeconds(d)}';
