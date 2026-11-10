import 'package:flutter/foundation.dart';

import '../../data/database/database.dart';
import '../../data/repositories/content_repository.dart';
import '../../services/analytics/analytics_service.dart';

/// Find-help screen (F6). Districts start with Kigali's three districts,
/// verified by phone (plan). Other districts are added after launch.
class HelpController extends ChangeNotifier {
  HelpController({
    required ContentRepository content,
    required AnalyticsService analytics,
  })  : _content = content,
        _analytics = analytics;

  final ContentRepository _content;
  final AnalyticsService _analytics;

  static const districts = ['Gasabo', 'Kicukiro', 'Nyarugenge'];

  String _district = districts.first;
  List<HealthCentreRow> _centres = const [];

  String get district => _district;
  List<HealthCentreRow> get centres => _centres;

  void opened() => _analytics.track('help_opened');

  Future<void> selectDistrict(String d) async {
    _district = d;
    await _load();
  }

  Future<void> load() async {
    _analytics.track('help_opened');
    await _load();
  }

  Future<void> _load() async {
    _centres = await _content.centresIn(_district);
    notifyListeners();
  }
}
