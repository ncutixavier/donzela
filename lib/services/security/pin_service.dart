import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Outcome of a PIN attempt.
class PinCheck {
  const PinCheck._(this.ok, this.lockedSeconds);
  const PinCheck.success() : this._(true, 0);
  const PinCheck.wrong() : this._(false, 0);
  const PinCheck.locked(int seconds) : this._(false, seconds);

  final bool ok;

  /// Seconds left in the lockout, or 0 when not locked.
  final int lockedSeconds;

  bool get isLocked => lockedSeconds > 0;
}

/// Stores only a salted SHA-256 hash of the PIN, in secure storage.
/// Failed attempts and the lockout deadline are also kept there, so killing
/// and reopening the app does not reset them.
class PinService {
  PinService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const maxWrongTries = 5;
  static const lockoutSeconds = 30;

  static const _kSalt = 'pin_salt';
  static const _kHash = 'pin_hash';
  static const _kFails = 'pin_fails';
  static const _kLockUntil = 'pin_lock_until';

  static String _hash(String salt, String pin) =>
      sha256.convert(utf8.encode('$salt:$pin')).toString();

  static String _newSalt() {
    final rnd = Random.secure();
    final bytes = List<int>.generate(16, (_) => rnd.nextInt(256));
    return base64Url.encode(bytes);
  }

  /// Rejects PINs that are not 4 digits.
  static bool isValidFormat(String pin) => RegExp(r'^\d{4}$').hasMatch(pin);

  Future<bool> hasPin() async =>
      (await _storage.read(key: _kHash)) != null;

  Future<void> setPin(String pin) async {
    if (!isValidFormat(pin)) {
      throw ArgumentError('PIN must be 4 digits');
    }
    final salt = _newSalt();
    await _storage.write(key: _kSalt, value: salt);
    await _storage.write(key: _kHash, value: _hash(salt, pin));
    await _storage.write(key: _kFails, value: '0');
    await _storage.delete(key: _kLockUntil);
  }

  Future<PinCheck> verify(String pin) async {
    final lockUntil = int.tryParse(await _storage.read(key: _kLockUntil) ?? '');
    if (lockUntil != null) {
      final left =
          ((lockUntil - DateTime.now().millisecondsSinceEpoch) / 1000).ceil();
      if (left > 0) return PinCheck.locked(left);
      await _storage.delete(key: _kLockUntil);
    }

    final salt = await _storage.read(key: _kSalt);
    final stored = await _storage.read(key: _kHash);
    if (salt == null || stored == null) return const PinCheck.success();

    if (_hash(salt, pin) == stored) {
      await _storage.write(key: _kFails, value: '0');
      return const PinCheck.success();
    }

    final fails = (int.tryParse(await _storage.read(key: _kFails) ?? '') ?? 0) + 1;
    if (fails >= maxWrongTries) {
      await _storage.write(key: _kFails, value: '0');
      final until = DateTime.now()
          .add(const Duration(seconds: lockoutSeconds))
          .millisecondsSinceEpoch;
      await _storage.write(key: _kLockUntil, value: until.toString());
      return const PinCheck.locked(lockoutSeconds);
    }
    await _storage.write(key: _kFails, value: fails.toString());
    return const PinCheck.wrong();
  }

  Future<void> clear() async {
    await _storage.delete(key: _kSalt);
    await _storage.delete(key: _kHash);
    await _storage.delete(key: _kFails);
    await _storage.delete(key: _kLockUntil);
  }
}
