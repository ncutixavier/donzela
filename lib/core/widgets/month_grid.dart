import 'package:flutter/material.dart';

import '../l10n/localization.dart';
import '../theme/app_theme.dart';
import '../utils/dates.dart';

/// Month grid with Monday start and Kinyarwanda weekday initials (F4).
/// Used by the onboarding date picker and the calendar.
class MonthGrid extends StatelessWidget {
  const MonthGrid({
    super.key,
    required this.month,
    required this.dayStyle,
    required this.onTap,
    this.onLongPress,
    this.selected,
    this.minDate,
    this.maxDate,
    this.today,
  });

  /// Any day in the month to show.
  final DateTime month;

  /// Returns the decoration for a day, or null for a plain day.
  final DayCell Function(DateTime day) dayStyle;
  final void Function(DateTime day) onTap;
  final void Function(DateTime day)? onLongPress;
  final DateTime? selected;
  final DateTime? minDate;
  final DateTime? maxDate;
  final DateTime? today;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final first = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leading = first.weekday - 1; // Monday = 0
    final now = today ?? DateTime.now();

    final cells = <Widget>[
      for (final initial in l.weekdayInitials)
        Center(
          child: Text(initial,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.inkMuted)),
        ),
      for (var i = 0; i < leading; i++) const SizedBox.shrink(),
      for (var d = 1; d <= daysInMonth; d++)
        _dayCell(context, DateTime(month.year, month.month, d), now),
    ];

    // Cells are square, so the grid is capped at phone width. On a wide screen
    // it stays the same size instead of growing into large circles.
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 1,
          children: cells,
        ),
      ),
    );
  }

  Widget _dayCell(BuildContext context, DateTime day, DateTime now) {
    final disabled = (minDate != null && day.isBefore(dayOnly(minDate!))) ||
        (maxDate != null && day.isAfter(dayOnly(maxDate!)));
    final style = dayStyle(day);
    final isSelected = selected != null && isSameDay(selected!, day);
    final isToday = isSameDay(now, day);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: disabled ? null : () => onTap(day),
      onLongPress: disabled || onLongPress == null
          ? null
          : () => onLongPress!(day),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? AppColors.terracotta : style.fill,
          shape: BoxShape.circle,
          border: Border.all(
            color: isToday
                ? AppColors.brown
                : (style.outline ?? Colors.transparent),
            width: isToday ? 2.5 : 1.5,
          ),
        ),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: disabled
                    ? AppColors.sandDark
                    : isSelected
                        ? Colors.white
                        : style.textColor ?? AppColors.ink,
              ),
            ),
            if (style.marked)
              Positioned(
                bottom: 2,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.white : AppColors.brown,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Visual description of one calendar day.
class DayCell {
  const DayCell({this.fill, this.outline, this.textColor, this.marked = false});
  final Color? fill;
  final Color? outline;
  final Color? textColor;

  /// Shows a small dot under the number, for example a day with log entries.
  final bool marked;
}
