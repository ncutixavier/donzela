import 'package:donzela/core/config/admin.dart';
import 'package:donzela/features/admin/admin_users_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('emails are stored in lowercase, without spaces', () {
    expect(normalizeAdminEmail('  Name@Gmail.COM '), 'name@gmail.com');
  });

  test('an admin email must look like an email', () {
    expect(isValidAdminEmail('name@gmail.com'), isTrue);
    expect(isValidAdminEmail(' name@gmail.com '), isTrue);
    expect(isValidAdminEmail('name'), isFalse);
    expect(isValidAdminEmail('name@'), isFalse);
    expect(isValidAdminEmail('two words@gmail.com'), isFalse);
  });
}
