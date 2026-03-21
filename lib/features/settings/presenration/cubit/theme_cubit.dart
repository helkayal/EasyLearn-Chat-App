import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/local_storage_services.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final LocalStorageService _storageService = LocalStorageService();

  ThemeCubit() : super(ThemeMode.light) {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final savedTheme = await _storageService.getTheme();
    if (savedTheme != null) {
      final mode = ThemeMode.values.firstWhere(
        (e) => e.toString() == savedTheme,
        orElse: () => ThemeMode.light,
      );
      emit(mode);
    }
  }

  Future<void> updateTheme(ThemeMode mode) async {
    await _storageService.saveTheme(mode.toString());
    emit(mode);
  }
}
