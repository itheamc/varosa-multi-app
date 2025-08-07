import 'dart:isolate';

import 'package:fpdart/fpdart.dart';

import '../../../../../core/config/api_endpoints.dart';
import '../../../../../core/services/network/http_exception.dart';
import '../../../../../core/services/network/http_response_validator.dart';
import '../../../../../core/services/network/http_service.dart';
import '../../../../../core/services/network/models/multipart_form_data.dart';
import '../../../../../core/services/network/typedefs/response_or_exception.dart';
import '../models/refresh_token_response.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  /// Http Service Instance
  final HttpService httpService;

  /// Constructor
  AuthRepositoryImpl(this.httpService);

  ///  Base endpoint path for refresh
  ///
  @override
  String get path4Refresh => ApiEndpoints.refreshToken;

  /// Method to refresh access token
  ///
  @override
  Future<EitherResponseOrException<RefreshTokenResponse>> refreshAccessToken(
    String refreshToken,
  ) async {
    try {
      final response = await httpService.post(
        path4Refresh,
        MultipartFormData(fields: {"refresh": refreshToken}),
        contentType: ContentType.json,
        isAuthenticated: false,
      );

      if (ResponseValidator.isValidResponse(response)) {
        final refreshTokenResponse = await Isolate.run(() {
          return RefreshTokenResponse.fromJson(response.data);
        });

        return Right(refreshTokenResponse);
      }

      return Left(HttpException.fromResponse(response));
    } on HttpException catch (e) {
      return Left(e);
    } catch (e) {
      return Left(HttpException.fromException(e));
    }
  }
}
