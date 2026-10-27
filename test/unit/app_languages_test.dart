import 'package:arccore/core/constants/app_languages.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('offers well over thirty languages', () {
    expect(AppLanguages.all.length, greaterThanOrEqualTo(30));
  });

  test('language codes are unique', () {
    final codes = AppLanguages.all.map((l) => l.code).toList();
    expect(codes.toSet().length, codes.length);
  });

  test('covers the major Indian languages', () {
    final indian = AppLanguages.indian.map((l) => l.code).toSet();
    expect(
      indian,
      containsAll([
        'hi',
        'ta',
        'bn',
        'te',
        'mr',
        'gu',
        'kn',
        'ml',
        'pa',
        'or',
        'as',
        'ur',
        'ne',
        'sa',
        'mai',
        'kok',
        'doi',
        'brx',
        'mni',
        'sat',
        'ks',
        'sd',
      ]),
    );
    expect(indian.length, greaterThanOrEqualTo(20));
  });

  test('every entry has a native name and an English name', () {
    for (final lang in AppLanguages.all) {
      expect(lang.nativeName.trim(), isNotEmpty, reason: lang.code);
      expect(lang.englishName.trim(), isNotEmpty, reason: lang.code);
    }
  });

  test('only the locales with an ARB claim to be translated', () {
    final translated = AppLanguages.all
        .where((l) => l.isTranslated)
        .map((l) => l.code)
        .toSet();
    expect(translated, {
      'en',
      'ta',
      'es',
      'hi',
      'fr',
      'de',
      'pt',
      'it',
      'ru',
      'zh',
      'ja',
      'ko',
      'id',
      'vi',
      'th',
      'tr',
      'ar',
      'fa',
      'sw',
      'ms',
      'nl',
      'pl',
    }, reason: 'flag must track lib/l10n, not aspiration');
  });

  test('right-to-left scripts are flagged', () {
    for (final code in ['ur', 'ar', 'fa', 'ks', 'sd']) {
      expect(AppLanguages.isRtl(code), isTrue, reason: code);
    }
    for (final code in ['en', 'hi', 'ta', 'zh']) {
      expect(AppLanguages.isRtl(code), isFalse, reason: code);
    }
  });

  test('byCode resolves and rejects cleanly', () {
    expect(AppLanguages.byCode('ta')?.englishName, 'Tamil');
    expect(AppLanguages.byCode('zz'), isNull);
    expect(AppLanguages.byCode(null), isNull);
  });

  test('supportedCodes matches the catalogue', () {
    expect(AppLanguages.supportedCodes.length, AppLanguages.all.length);
  });
}
