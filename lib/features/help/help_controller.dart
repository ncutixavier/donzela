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

  // Starts on "All districts", so every centre shows until a district is picked.
  String _district = allDistricts;
  List<HealthCentreRow> _centres = const [];
  List<String> _districts = ContentRepository.defaultDistricts;

  /// Value for the "All districts" choice in the district picker.
  static const allDistricts = 'all';

  String get district => _district;
  bool get showingAll => _district == allDistricts;
  List<HealthCentreRow> get centres => _centres;

  /// Default districts plus any new one a centre uses.
  List<String> get districts => _districts;

  /// Urgent numbers. The super-admin can add, change and remove them.
  List<EmergencyContact> emergency = const [];

  void opened() => _analytics.track('help_opened');

  Future<void> selectDistrict(String d) async {
    _district = d;
    await _load();
  }

  Future<void> load() async {
    _analytics.track('help_opened');
    await _load();
  }

  /// Re-reads the centres and numbers, for example after an admin change.
  Future<void> reload() => _load();

  Future<void> _load() async {
    _districts = await _content.districts();
    _centres = showingAll
        ? await _content.allCentres()
        : await _content.centresIn(_district);
    emergency = await _content.emergencyContacts();
    notifyListeners();
  }
}
