import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/local_storage_services.dart';

enum AppLanguage { english, arabic, french, spanish }

class LanguageCubit extends Cubit<AppLanguage> {
  final LocalStorageService _storageService = LocalStorageService();

  LanguageCubit() : super(AppLanguage.english) {
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    final savedLang = await _storageService.getLanguage();
    if (savedLang != null) {
      final lang = AppLanguage.values.firstWhere(
        (e) => e.name == savedLang,
        orElse: () => AppLanguage.english,
      );
      emit(lang);
    }
  }

  Future<void> changeLanguage(AppLanguage lang) async {
    await _storageService.saveLanguage(lang.name);
    emit(lang);
  }
}
