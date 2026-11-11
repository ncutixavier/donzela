/// Roles come from Firestore, not from code. Each account has an optional
/// document `roles/{email}` with `role` set to:
/// - `owner`: manages the admin list and everything an admin can do.
/// - `admin`: edits Learn and Help content.
/// - `user`: a member. This is also the default when there is no document.
///
/// The owner document is created once by hand in the Firebase console. After
/// that the owner adds admins from the app. firestore.rules enforce the same.
enum AppRole { owner, admin, user }

/// Firestore collection of roles. The document id is the lowercase email.
const adminRoleCollection = 'roles';

/// The email in the form used as a document id.
String normalizeAdminEmail(String email) => email.trim().toLowerCase();

/// Reads the role from a `roles/{email}` document. Anything unknown, or no
/// document at all, is a normal user.
AppRole roleFromData(Map<String, dynamic>? data) => switch (data?['role']) {
      'owner' => AppRole.owner,
      'admin' => AppRole.admin,
      _ => AppRole.user,
    };
