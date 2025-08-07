import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/services/storage/storage_keys.dart';
import '../core/services/storage/storage_service.dart';

/// L10n Class for handling localization of the app
///
class L10n {
  static const Locale en = Locale('en', 'US'); // English
  static const Locale ne = Locale('ne', 'NP'); // Nepali

  static final all = [en, ne];

  static Locale fromLanguageCode(String code) {
    if (code == ne.languageCode) return ne;
    return en;
  }
}

/// LocaleCubit for locale state handling
///
class LocaleCubit extends Cubit<Locale> {
  final StorageService storageService;

  LocaleCubit({required this.storageService}) : super(L10n.en) {
    _loadLocale(); // Load on startup
  }

  /// Load saved locale from storage
  void _loadLocale() {
    final code = storageService.get(
      StorageKeys.locale,
      defaultValue: L10n.en.languageCode,
    );
    emit(L10n.fromLanguageCode(code ?? L10n.en.languageCode));
  }

  /// Change and persist new locale
  Future<void> changeLocale(Locale locale) async {
    final newLocale = L10n.fromLanguageCode(locale.languageCode);
    if (state.languageCode != newLocale.languageCode) {
      await storageService.set(StorageKeys.locale, newLocale.languageCode);
      emit(newLocale);
    }
  }
}
