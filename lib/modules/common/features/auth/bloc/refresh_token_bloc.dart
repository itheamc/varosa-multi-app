import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/services/storage/storage_keys.dart';
import '../../../../../core/services/storage/storage_service.dart';
import '../models/refresh_token_response.dart';
import '../repository/auth_repository.dart';
import 'refresh_token_event.dart';
import 'refresh_token_state.dart';

class RefreshTokenBloc extends Bloc<RefreshTokenEvent, RefreshTokenState> {
  RefreshTokenBloc({
    required AuthRepository repository,
    required StorageService storageService,
  }) : _repository = repository,
       _storageService = storageService,
       super(RefreshTokenState()) {
    on<RefreshRequested>(_onRefreshRequested);
  }

  static const int _maxHoursToRefreshToken = 24;

  final AuthRepository _repository;
  final StorageService _storageService;

  Future<void> _onRefreshRequested(
    RefreshRequested event,
    Emitter<RefreshTokenState> emit,
  ) async {
    // Check if token needs to be refreshed.
    if (await _shouldRefresh()) {
      emit(state.copy(refreshing: true));

      final refreshToken = _storageService.get(
        StorageKeys.loggedInUserRefreshToken,
        defaultValue: '',
      );

      if (refreshToken == null || refreshToken.toString().isEmpty) {
        emit(state.copy(refreshing: false, error: 'Refresh token not found'));
        event.onLogoutRequired?.call();
        return;
      }

      final response = await _repository.refreshAccessToken(
        refreshToken.toString(),
      );

      response.fold(
        (failure) {
          final needsLogout = failure.statusCode == 401;
          emit(state.copy(refreshing: false, error: failure.message));

          if (needsLogout) event.onLogoutRequired?.call();
        },
        (response) async {
          await _storeUserData(response);
          emit(state.copy(refreshing: false, response: response));
          event.onSuccess?.call(response);
        },
      );
    }
  }

  Future<void> _storeUserData(RefreshTokenResponse response) async {
    if (response.access != null) {
      await _storageService.set(StorageKeys.loggedInUserToken, response.access);
      await _storageService.set(
        StorageKeys.loggedInUserRefreshToken,
        response.refresh,
      );
      await _storageService.set(
        StorageKeys.tokenRefreshedDate,
        DateTime.now().toIso8601String(),
      );
    }
  }

  Future<bool> _shouldRefresh() async {
    try {
      final lastRefreshDateStr = _storageService.get(
        StorageKeys.tokenRefreshedDate,
      );

      if (lastRefreshDateStr == null) return true;

      final lastRefreshDate = DateTime.tryParse(lastRefreshDateStr.toString());

      if (lastRefreshDate == null) return true;

      final currentDate = DateTime.now();
      final difference = currentDate.difference(lastRefreshDate);

      return difference.inHours > _maxHoursToRefreshToken;
    } catch (e) {
      return true;
    }
  }
}
