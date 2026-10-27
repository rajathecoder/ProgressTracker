import 'dart:convert';

import 'package:arccore/core/constants/app_constants.dart';
import 'package:arccore/core/services/backup_service.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // The envelope is a pure function of its payload, so these tests never touch
  // storage.
  final payload = <String, dynamic>{
    'arcs': [
      {'id': 1, 'name': 'Winter Arc 2026'},
    ],
    'habits': [
      {'id': 1, 'title_key': 'habitEarlyWake'},
    ],
    'daily_logs': [
      {'date_key': '2026-09-01', 'entries': []},
    ],
  };

  test('stamps schema version, app version and an ISO timestamp', () {
    final env = BackupService.envelope(payload);
    expect(env.schemaVersion, AppConstants.schemaVersion);
    expect(env.appVersion, AppConstants.appVersion);
    expect(DateTime.tryParse(env.exportedAt), isNotNull);
    expect(env.encrypted, isFalse);
  });

  test('checksum is the SHA-256 of the serialised payload', () {
    final env = BackupService.envelope(payload);
    final expected = sha256
        .convert(utf8.encode(jsonEncode(payload)))
        .toString();
    expect(env.checksum, expected);
    expect(env.checksum.length, 64);
  });

  test('a single changed byte changes the checksum', () {
    final a = BackupService.envelope(payload).checksum;
    final tampered = Map<String, dynamic>.from(payload)
      ..['habits'] = [
        {'id': 1, 'title_key': 'habitGymWorkout'},
      ];
    expect(BackupService.envelope(tampered).checksum, isNot(a));
  });

  test('an encrypted envelope hides the payload behind a cipher blob', () {
    final env = BackupService.envelope(payload, passphrase: 'winter-arc');
    expect(env.encrypted, isTrue);
    expect(env.payload.keys, ['cipher']);
    final cipher = env.payload['cipher'] as String;
    expect(cipher, contains(':'), reason: 'iv:ciphertext');
    expect(cipher, isNot(contains('habitEarlyWake')));
  });

  test('the checksum still covers the plaintext payload', () {
    final plain = BackupService.envelope(payload).checksum;
    final encrypted = BackupService.envelope(payload, passphrase: 'x').checksum;
    expect(
      encrypted,
      plain,
      reason: 'so a decrypted restore can verify integrity',
    );
  });

  test('the same passphrase produces different ciphertext each time', () {
    final a = BackupService.envelope(
      payload,
      passphrase: 'k',
    ).payload['cipher'];
    final b = BackupService.envelope(
      payload,
      passphrase: 'k',
    ).payload['cipher'];
    expect(a, isNot(b), reason: 'random IV per export');
  });

  test('toJson round-trips into a restorable shape', () {
    final json = BackupService.envelope(payload).toJson();
    expect(
      json.keys,
      containsAll([
        'schema_version',
        'app_version',
        'exported_at',
        'checksum',
        'encrypted',
        'payload',
      ]),
    );
    final decoded = jsonDecode(jsonEncode(json)) as Map<String, dynamic>;
    expect(decoded['schema_version'], AppConstants.schemaVersion);
  });
}
