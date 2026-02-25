import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/local_storage_services.dart';
import 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final LocalStorageService _storageService = LocalStorageService();

  OnboardingCubit() : super(OnboardingState(0));

  void updatePage(int index) => emit(OnboardingState(index));

  Future<void> completeOnboarding() async {
    await _storageService.setOnboardingComplete();
  }
}
