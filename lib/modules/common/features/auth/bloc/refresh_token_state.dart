import '../models/refresh_token_response.dart';

class RefreshTokenState {
  final bool refreshing;
  final String? error;
  final RefreshTokenResponse? response;

  RefreshTokenState({this.refreshing = false, this.error, this.response});

  /// Method to copy
  RefreshTokenState copy({
    bool? refreshing,
    String? error,
    RefreshTokenResponse? response,
  }) {
    return RefreshTokenState(
      refreshing: refreshing ?? this.refreshing,
      error: error != null
          ? error.isEmpty
                ? null
                : error
          : this.error,
      response: response ?? this.response,
    );
  }
}
