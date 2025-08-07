import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/storage/storage_keys.dart';
import '../../../../../core/services/storage/storage_service.dart';

class OnboardingStatusCubit extends Cubit<bool> {
  OnboardingStatusCubit(this._storageService)
    : super(
        _storageService.get(StorageKeys.alreadyOnboarded, defaultValue: false),
      );

  final StorageService _storageService;

  void markAsOnboarded() {
    _storageService.set(StorageKeys.alreadyOnboarded, true);
    emit(true);
  }

  void resetOnboarding() {
    _storageService.set(StorageKeys.alreadyOnboarded, false);
    emit(false);
  }
}
