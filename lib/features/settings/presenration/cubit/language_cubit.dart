// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/services/local_storage_services.dart';

// enum AppLanguage { english, arabic, french, spanish }

// class LanguageCubit extends Cubit<AppLanguage> {
//   final LocalStorageService _storageService = LocalStorageService();

//   LanguageCubit() : super(AppLanguage.english) {
//     loadLanguage();
//   }

//   Future<void> loadLanguage() async {
//     final savedLang = await _storageService.getLanguage();
//     if (savedLang != null) {
//       final lang = AppLanguage.values.firstWhere(
//         (e) => e.name == savedLang,
//         orElse: () => AppLanguage.english,
//       );
//       emit(lang);
//     }
//   }

//   Future<void> changeLanguage(BuildContext context, AppLanguage lang) async {
//     await _storageService.saveLanguage(lang.name);

//     Locale newLocale;
//     switch (lang) {
//       case AppLanguage.arabic:
//         newLocale = const Locale('ar');
//         break;
//       case AppLanguage.french:
//         newLocale = const Locale('fr');
//         break;
//       case AppLanguage.spanish:
//         newLocale = const Locale('es');
//         break;
//       default:
//         newLocale = const Locale('en');
//     }
//     if (!context.mounted) return;
//     await context.setLocale(newLocale);
//     emit(lang);
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/services/local_storage_services.dart';

enum AppLanguage { english, arabic, french, spanish }

class LanguageCubit extends Cubit<AppLanguage> {
  final LocalStorageService _storageService = LocalStorageService();

  LanguageCubit() : super(AppLanguage.english);

  // Call this in the very first build of your app (e.g., in HomeScreen or ChatApp)
  void initLocale(BuildContext context) async {
    final savedLangCode = await _storageService.getLanguage();

    if (savedLangCode != null) {
      // 1. If we have a saved value, make sure easy_localization matches it
      if (!context.mounted) return;
      context.setLocale(Locale(savedLangCode));
      emit(_mapCodeToEnum(savedLangCode));
    } else {
      // 2. First run: Sync Cubit with whatever EasyLocalization detected from device
      if (!context.mounted) return;
      final deviceCode = context.locale.languageCode;
      emit(_mapCodeToEnum(deviceCode));
    }
  }

  Future<void> changeLanguage(BuildContext context, AppLanguage lang) async {
    final code = _mapEnumToCode(lang);
    await _storageService.saveLanguage(code); // Save to disk
    if (!context.mounted) return;
    await context.setLocale(Locale(code)); // Switch JSON files
    emit(lang); // Update UI
  }

  // Helpers to translate between Enum and Strings
  String _mapEnumToCode(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.arabic:
        return 'ar';
      case AppLanguage.french:
        return 'fr';
      case AppLanguage.spanish:
        return 'es';
      default:
        return 'en';
    }
  }

  AppLanguage _mapCodeToEnum(String code) {
    if (code == 'ar') return AppLanguage.arabic;
    if (code == 'fr') return AppLanguage.french;
    if (code == 'es') return AppLanguage.spanish;
    return AppLanguage.english;
  }
}
