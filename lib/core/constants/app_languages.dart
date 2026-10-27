/// The language picker's catalogue.
///
/// Two things are deliberately separate here:
///
///  * what the picker *offers* - this list;
///  * what is actually *translated* - the ARB files under lib/l10n.
///
/// A locale with no ARB still works: gen_l10n falls back to English key by key,
/// so choosing it changes what it can and leaves the rest legible rather than
/// blank. [isTranslated] marks the ones with real coverage so the UI can say so
/// instead of implying every language is finished.
class AppLanguage {
  const AppLanguage({
    required this.code,
    required this.nativeName,
    required this.englishName,
    this.isTranslated = false,
    this.isIndian = false,
    this.isRtl = false,
  });

  final String code;

  /// Shown in the picker - a language list is far easier to scan in its own
  /// script than transliterated into English.
  final String nativeName;
  final String englishName;
  final bool isTranslated;
  final bool isIndian;
  final bool isRtl;
}

abstract final class AppLanguages {
  /// Indian languages first: the app's primary audience, and the list the user
  /// most needs to find themselves in.
  static const List<AppLanguage> indian = [
    AppLanguage(
      code: 'hi',
      nativeName: 'हिन्दी',
      englishName: 'Hindi',
      isTranslated: true,
      isIndian: true,
    ),
    AppLanguage(
      code: 'ta',
      nativeName: 'தமிழ்',
      englishName: 'Tamil',
      isTranslated: true,
      isIndian: true,
    ),
    AppLanguage(
      code: 'bn',
      nativeName: 'বাংলা',
      englishName: 'Bengali',
      isIndian: true,
    ),
    AppLanguage(
      code: 'te',
      nativeName: 'తెలుగు',
      englishName: 'Telugu',
      isIndian: true,
    ),
    AppLanguage(
      code: 'mr',
      nativeName: 'मराठी',
      englishName: 'Marathi',
      isIndian: true,
    ),
    AppLanguage(
      code: 'gu',
      nativeName: 'ગુજરાતી',
      englishName: 'Gujarati',
      isIndian: true,
    ),
    AppLanguage(
      code: 'kn',
      nativeName: 'ಕನ್ನಡ',
      englishName: 'Kannada',
      isIndian: true,
    ),
    AppLanguage(
      code: 'ml',
      nativeName: 'മലയാളം',
      englishName: 'Malayalam',
      isIndian: true,
    ),
    AppLanguage(
      code: 'pa',
      nativeName: 'ਪੰਜਾਬੀ',
      englishName: 'Punjabi',
      isIndian: true,
    ),
    AppLanguage(
      code: 'or',
      nativeName: 'ଓଡ଼ିଆ',
      englishName: 'Odia',
      isIndian: true,
    ),
    AppLanguage(
      code: 'as',
      nativeName: 'অসমীয়া',
      englishName: 'Assamese',
      isIndian: true,
    ),
    AppLanguage(
      code: 'ur',
      nativeName: 'اردو',
      englishName: 'Urdu',
      isIndian: true,
      isRtl: true,
    ),
    AppLanguage(
      code: 'ne',
      nativeName: 'नेपाली',
      englishName: 'Nepali',
      isIndian: true,
    ),
    AppLanguage(
      code: 'si',
      nativeName: 'සිංහල',
      englishName: 'Sinhala',
      isIndian: true,
    ),
    AppLanguage(
      code: 'sa',
      nativeName: 'संस्कृतम्',
      englishName: 'Sanskrit',
      isIndian: true,
    ),
    AppLanguage(
      code: 'mai',
      nativeName: 'मैथिली',
      englishName: 'Maithili',
      isIndian: true,
    ),
    AppLanguage(
      code: 'kok',
      nativeName: 'कोंकणी',
      englishName: 'Konkani',
      isIndian: true,
    ),
    AppLanguage(
      code: 'doi',
      nativeName: 'डोगरी',
      englishName: 'Dogri',
      isIndian: true,
    ),
    AppLanguage(
      code: 'brx',
      nativeName: 'बड़ो',
      englishName: 'Bodo',
      isIndian: true,
    ),
    AppLanguage(
      code: 'mni',
      nativeName: 'মৈতৈলোন্',
      englishName: 'Manipuri',
      isIndian: true,
    ),
    AppLanguage(
      code: 'sat',
      nativeName: 'ᱥᱟᱱᱛᱟᱲᱤ',
      englishName: 'Santali',
      isIndian: true,
    ),
    AppLanguage(
      code: 'ks',
      nativeName: 'کٲشُر',
      englishName: 'Kashmiri',
      isIndian: true,
      isRtl: true,
    ),
    AppLanguage(
      code: 'sd',
      nativeName: 'سنڌي',
      englishName: 'Sindhi',
      isIndian: true,
      isRtl: true,
    ),
  ];

  static const List<AppLanguage> world = [
    AppLanguage(
      code: 'en',
      nativeName: 'English',
      englishName: 'English',
      isTranslated: true,
    ),
    AppLanguage(
      code: 'es',
      nativeName: 'Español',
      englishName: 'Spanish',
      isTranslated: true,
    ),
    AppLanguage(
      code: 'fr',
      nativeName: 'Français',
      englishName: 'French',
      isTranslated: true,
    ),
    AppLanguage(
      code: 'de',
      nativeName: 'Deutsch',
      englishName: 'German',
      isTranslated: true,
    ),
    AppLanguage(
      code: 'pt',
      nativeName: 'Português',
      englishName: 'Portuguese',
      isTranslated: true,
    ),
    AppLanguage(
      code: 'it',
      nativeName: 'Italiano',
      englishName: 'Italian',
      isTranslated: true,
    ),
    AppLanguage(
      code: 'ru',
      nativeName: 'Русский',
      englishName: 'Russian',
      isTranslated: true,
    ),
    AppLanguage(
      code: 'zh',
      nativeName: '中文',
      englishName: 'Chinese',
      isTranslated: true,
    ),
    AppLanguage(
      code: 'ja',
      nativeName: '日本語',
      englishName: 'Japanese',
      isTranslated: true,
    ),
    AppLanguage(
      code: 'ko',
      nativeName: '한국어',
      englishName: 'Korean',
      isTranslated: true,
    ),
    AppLanguage(
      code: 'id',
      nativeName: 'Bahasa Indonesia',
      englishName: 'Indonesian',
      isTranslated: true,
    ),
    AppLanguage(
      code: 'vi',
      nativeName: 'Tiếng Việt',
      englishName: 'Vietnamese',
      isTranslated: true,
    ),
    AppLanguage(
      code: 'th',
      nativeName: 'ไทย',
      englishName: 'Thai',
      isTranslated: true,
    ),
    AppLanguage(
      code: 'tr',
      nativeName: 'Türkçe',
      englishName: 'Turkish',
      isTranslated: true,
    ),
    AppLanguage(
      code: 'ar',
      nativeName: 'العربية',
      englishName: 'Arabic',
      isTranslated: true,
      isRtl: true,
    ),
    AppLanguage(
      code: 'fa',
      nativeName: 'فارسی',
      englishName: 'Persian',
      isTranslated: true,
      isRtl: true,
    ),
    AppLanguage(
      code: 'sw',
      nativeName: 'Kiswahili',
      englishName: 'Swahili',
      isTranslated: true,
    ),
    AppLanguage(
      code: 'ms',
      nativeName: 'Bahasa Melayu',
      englishName: 'Malay',
      isTranslated: true,
    ),
    AppLanguage(
      code: 'nl',
      nativeName: 'Nederlands',
      englishName: 'Dutch',
      isTranslated: true,
    ),
    AppLanguage(
      code: 'pl',
      nativeName: 'Polski',
      englishName: 'Polish',
      isTranslated: true,
    ),
  ];

  static List<AppLanguage> get all => [...indian, ...world];

  static AppLanguage? byCode(String? code) {
    if (code == null) return null;
    for (final l in all) {
      if (l.code == code) return l;
    }
    return null;
  }

  /// Every locale the picker can select. Handed to MaterialApp so a chosen
  /// language is actually applied rather than silently ignored.
  static List<String> get supportedCodes =>
      all.map((l) => l.code).toList(growable: false);

  static bool isRtl(String? code) => byCode(code)?.isRtl ?? false;
}
