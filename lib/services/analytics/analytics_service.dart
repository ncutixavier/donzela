import 'package:flutter/foundation.dart';

/// Usage analytics with a hard allowlist (F7).
///
/// Only the events below can be sent, and only with the listed parameter
/// names. Dates, symptoms, moods, flow, cycle lengths and notes never pass
/// through here. Anything else is dropped before it leaves the app.
class AnalyticsService {
  AnalyticsService({this.enabled = true, this.sink});

  bool enabled;

  /// Where accepted events go. Firebase Analytics plugs in here once the
  /// Firebase project is configured. Defaults to debug output only.
  final void Function(String name, Map<String, String> params)? sink;

  static const Map<String, Set<String>> allowedEvents = {
    'onboarding_completed': {},
    'day_logged': {},
    'article_opened': {'article_id'},
    'help_opened': {},
    'report_shared': {},
    'reminder_enabled': {'type'},
    'backup_enabled': {},
  };

  static const _allowedReminderTypes = {'period', 'fertile', 'pill'};

  void track(String event, [Map<String, String> params = const {}]) {
    if (!enabled) return;
    final allowedParams = allowedEvents[event];
    if (allowedParams == null) return;

    final clean = <String, String>{};
    for (final entry in params.entries) {
      if (!allowedParams.contains(entry.key)) continue;
      if (entry.key == 'type' && !_allowedReminderTypes.contains(entry.value)) {
        continue;
      }
      clean[entry.key] = entry.value;
    }

    final out = sink;
    if (out != null) {
      out(event, clean);
    } else if (kDebugMode) {
      debugPrint('[analytics] $event $clean');
    }
  }
}

/// Crash reporting with user data stripped (F7).
///
/// Only the error type and a short, redacted message are recorded. Stack
/// traces are kept; the app never attaches cycle data to a report.
class CrashReporter {
  CrashReporter({this.sink});

  final void Function(String type, String message)? sink;

  static final _digits = RegExp(r'\d{4}-\d{2}-\d{2}|\d+');

  static String redact(String message) {
    final short = message.length > 200 ? message.substring(0, 200) : message;
    return short.replaceAll(_digits, '#');
  }

  void record(Object error, StackTrace? stack) {
    final type = error.runtimeType.toString();
    final msg = redact(error.toString());
    final out = sink;
    if (out != null) {
      out(type, msg);
    } else if (kDebugMode) {
      debugPrint('[crash] $type: $msg');
    }
  }

  /// Installs Flutter and platform error hooks.
  void install() {
    FlutterError.onError = (details) {
      record(details.exception, details.stack);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      record(error, stack);
      return true;
    };
  }
}
