import 'package:donzela/services/cloud/profile_store.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 11, 11, 9, 30);

  test('a profile holds only the allowed fields, never a role or health data', () {
    final data = profileData(
      uid: 'u1',
      email: 'Name@Gmail.com',
      name: 'Ncuti Xavier',
      photoUrl: 'https://example.com/p.jpg',
      now: now,
      createdAt: now,
    );
    expect(data.keys.toSet().difference(profileFields), isEmpty);
    expect(data['email'], 'name@gmail.com');
    expect(data['name'], 'Ncuti Xavier');
    expect(data['provider'], 'google');
  });

  test('the name falls back to the email, and no photo is stored when there is none', () {
    final data = profileData(
      uid: 'u2',
      email: 'someone@gmail.com',
      name: '  ',
      photoUrl: null,
      now: now,
    );
    expect(data['name'], 'someone@gmail.com');
    expect(data.containsKey('photo_url'), isTrue);
    expect(data['photo_url'], isNull);
  });

  test('created_at is set only on the first sign-in', () {
    final first = profileData(uid: 'u3', email: 'a@b.co', name: 'A', photoUrl: null, now: now, createdAt: now);
    final again = profileData(uid: 'u3', email: 'a@b.co', name: 'A', photoUrl: null, now: now);
    expect(first.containsKey('created_at'), isTrue);
    expect(again.containsKey('created_at'), isFalse);
  });
}
