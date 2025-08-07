import '../../../../../core/services/network/typedefs/response_or_exception.dart';

import '../models/refresh_token_response.dart';

abstract class AuthRepository {
  ///  Base endpoint path for refresh
  ///
  String get path4Refresh;

  /// Method to refresh access token
  ///
  Future<EitherResponseOrException<RefreshTokenResponse>> refreshAccessToken(
    String refreshToken,
  );
}
