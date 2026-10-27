import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../../l10n/app_localizations.dart';
import '../constants/app_languages.dart';

/// Lets the picker offer every language in [AppLanguages] without pretending
/// they are all translated.
///
/// Flutter's normal contract is all-or-nothing: a locale that any delegate does
/// not support is refused outright, so a 40-language picker would need 40
/// complete ARB files and 40 complete Material translations. These delegates
/// resolve per-layer instead - the app's own strings fall back to English where
/// there is no ARB, while Material's own widgets (date pickers, tooltips, the
/// text-selection menu) still speak the chosen language wherever Flutter ships
/// a translation for it.
class AppLocalizationsFallbackDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsFallbackDelegate();

  static const _fallback = Locale('en');

  @override
  bool isSupported(Locale locale) =>
      AppLanguages.byCode(locale.languageCode) != null;

  @override
  Future<AppLocalizations> load(Locale locale) {
    final translated = AppLocalizations.supportedLocales.any(
      (l) => l.languageCode == locale.languageCode,
    );
    return AppLocalizations.delegate.load(translated ? locale : _fallback);
  }

  @override
  bool shouldReload(AppLocalizationsFallbackDelegate old) => false;
}

/// Wraps one of the `flutter_localizations` global delegates so an unsupported
/// locale degrades to English rather than tripping MaterialApp's assertion.
class _Fallback<T> extends LocalizationsDelegate<T> {
  const _Fallback(this._inner);

  final LocalizationsDelegate<T> _inner;
  static const _fallback = Locale('en');

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<T> load(Locale locale) =>
      _inner.load(_inner.isSupported(locale) ? locale : _fallback);

  @override
  bool shouldReload(covariant LocalizationsDelegate<T> old) => false;
}

/// The full delegate list for MaterialApp.
const appLocalizationDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizationsFallbackDelegate(),
  _Fallback<MaterialLocalizations>(GlobalMaterialLocalizations.delegate),
  _Fallback<WidgetsLocalizations>(GlobalWidgetsLocalizations.delegate),
  _Fallback<CupertinoLocalizations>(GlobalCupertinoLocalizations.delegate),
];

/// Every locale the picker may select.
List<Locale> get appSupportedLocales =>
    AppLanguages.supportedCodes.map(Locale.new).toList(growable: false);
