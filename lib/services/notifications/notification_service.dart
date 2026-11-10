import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../prediction/prediction_service.dart';

/// Local reminders (F5). No server is needed: everything is scheduled on the
/// phone in its own time zone.
///
/// Titles and bodies are passed in already translated. They are always the
/// neutral text, so no health information is ever shown on the lock screen.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const _idPeriod = 1;
  static const _idFertile = 2;
  static const _idPill = 3;
  static const _channel = 'donzela_reminders';

  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;
    try {
      tzdata.initializeTimeZones();
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      // Falls back to UTC. Reminders would then be off by the zone offset,
      // so the app asks the plugin for the device zone on every launch.
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    _ready = true;
  }

  /// Android 13+ needs a runtime permission. Returns true when granted.
  Future<bool> requestPermission() async {
    if (!_ready) return false;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission();
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    final iosGranted =
        await ios?.requestPermissions(alert: true, badge: false, sound: true);
    return granted ?? iosGranted ?? true;
  }

  NotificationDetails get _details => const NotificationDetails(
        android: AndroidNotificationDetails(
          _channel,
          'Donzela',
          channelDescription: 'Donzela reminders',
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      );

  /// Cancels everything and schedules fresh reminders from the current
  /// prediction. Call after every change to predictions or reminder settings.
  Future<void> rescheduleAll({
    required PredictionResult prediction,
    required bool periodOn,
    required bool fertileOn,
    required bool pillOn,
    required int pillHour,
    required int pillMinute,
    required String title,
    required String body,
    required DateTime now,
  }) async {
    if (!_ready) return;
    await _plugin.cancelAll();

    if (periodOn && prediction.nextPeriodStart != null) {
      // Two days before the predicted start, at 08:00.
      final when = DateTime(
        prediction.nextPeriodStart!.year,
        prediction.nextPeriodStart!.month,
        prediction.nextPeriodStart!.day - 2,
        8,
      );
      await _once(_idPeriod, when, now, title, body);
    }

    if (fertileOn && prediction.fertileStart != null) {
      final s = prediction.fertileStart!;
      await _once(_idFertile, DateTime(s.year, s.month, s.day, 8), now, title, body);
    }

    if (pillOn) {
      await _daily(_idPill, pillHour, pillMinute, title, body);
    }
  }

  Future<void> _once(
    int id,
    DateTime when,
    DateTime now,
    String title,
    String body,
  ) async {
    if (!when.isAfter(now)) return;
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(when, tz.local),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> _daily(
    int id,
    int hour,
    int minute,
    String title,
    String body,
  ) async {
    final now = tz.TZDateTime.now(tz.local);
    var when = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!when.isAfter(now)) when = when.add(const Duration(days: 1));
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: when,
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAll() async {
    if (!_ready) return;
    await _plugin.cancelAll();
  }

  @visibleForTesting
  static const reminderIds = [_idPeriod, _idFertile, _idPill];
}
