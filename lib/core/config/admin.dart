/// The super-admin account. Only this Google account can edit the Learn and
/// Help content. The same rule is enforced in firestore.rules, so the app
/// check is for the interface only.
const superAdminEmail = 'ncuti60@gmail.com';

/// True when [email] is the super-admin and the address is verified.
bool isSuperAdminEmail(String? email, {required bool emailVerified}) =>
    emailVerified && email != null && email.toLowerCase() == superAdminEmail;
