import 'package:flutter/foundation.dart';

import '../../core/config/admin.dart';
import '../../services/auth/auth_service.dart';
import '../../services/cloud/profile_store.dart';
import '../../services/cloud/role_store.dart';

/// Email check for the admin list: one @ with text on both sides.
bool isValidAdminEmail(String raw) {
  final email = raw.trim();
  return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
}

/// One person in the Users list: their profile, and their role.
class UserRow {
  const UserRow({required this.profile, required this.role});

  final UserProfile profile;
  final AppRole role;
}

/// Lists everyone who has signed in and changes admin rights. Only the owner
/// can use it; the rules enforce the same.
class AdminUsersController extends ChangeNotifier {
  AdminUsersController({
    required AuthService auth,
    required RoleStore? roles,
    required ProfileStore? profiles,
  })  : _auth = auth,
        _roles = roles,
        _profiles = profiles;

  final AuthService _auth;
  final RoleStore? _roles;
  final ProfileStore? _profiles;

  List<UserRow> _users = const [];
  bool _loading = false;
  String? _error;

  List<UserRow> get users => _users;
  bool get loading => _loading;
  String? get error => _error;

  /// Only the owner account manages users and roles.
  bool get canManage => _auth.isRootAdmin && _roles != null && _profiles != null;

  Future<void> load() async {
    final roles = _roles;
    final profiles = _profiles;
    if (!canManage || roles == null || profiles == null) return;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final profileList = await profiles.all();
      final roleMap = await roles.roles();
      _users = [
        for (final p in profileList)
          UserRow(
            profile: p,
            role: roleFromData({'role': roleMap[normalizeAdminEmail(p.email)]}),
          ),
      ];
    } catch (_) {
      _error = 'load';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Makes an account admin. Works before the person has signed in, so the
  /// role is waiting for them. Returns null on success, or 'invalid', 'owner',
  /// or 'failed'.
  Future<String?> makeAdmin(String email) => _change(email, admin: true);

  Future<String?> removeAdmin(String email) => _change(email, admin: false);

  Future<String?> _change(String email, {required bool admin}) async {
    final roles = _roles;
    final by = _auth.email;
    if (!canManage || roles == null || by == null) return 'failed';
    if (!isValidAdminEmail(email)) return 'invalid';
    // The owner's own role is not changed from the app.
    if (normalizeAdminEmail(email) == normalizeAdminEmail(by)) return 'owner';
    try {
      await roles.setRole(email, admin: admin, byEmail: by);
      await load();
      return null;
    } catch (_) {
      return 'failed';
    }
  }
}
