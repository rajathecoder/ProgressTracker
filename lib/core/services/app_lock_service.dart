import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

/// core_features.app_lock
///
/// "Gratitude entries and daily reflections are the most personal data in the
/// app and currently sit behind nothing."
///
/// Biometric gate with a hashed-PIN fallback. The PIN is never stored in
/// plaintext - only a salted SHA-256 digest, in the platform keystore.
class AppLockService {
  AppLockService({LocalAuthentication? auth, FlutterSecureStorage? storage})
    : _auth = auth ?? LocalAuthentication(),
      _storage = storage ?? const FlutterSecureStorage();

  final LocalAuthentication _auth;
  final FlutterSecureStorage _storage;

  static const _pinKey = 'arccore.pin_hash';
  static const _saltKey = 'arccore.pin_salt';

  Future<bool> biometricsAvailable() async {
    try {
      return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } catch (e) {
      debugPrint('ArcCore: biometric auth failed ($e)');
      return false;
    }
  }

  Future<bool> hasPin() async => await _storage.read(key: _pinKey) != null;

  Future<void> setPin(String pin) async {
    final salt = DateTime.now().microsecondsSinceEpoch.toString();
    await _storage.write(key: _saltKey, value: salt);
    await _storage.write(key: _pinKey, value: _hash(pin, salt));
  }

  Future<bool> verifyPin(String pin) async {
    final salt = await _storage.read(key: _saltKey);
    final stored = await _storage.read(key: _pinKey);
    if (salt == null || stored == null) return false;
    return _hash(pin, salt) == stored;
  }

  Future<void> clearPin() async {
    await _storage.delete(key: _pinKey);
    await _storage.delete(key: _saltKey);
  }

  static String _hash(String pin, String salt) =>
      sha256.convert(utf8.encode('$salt::$pin')).toString();
}
