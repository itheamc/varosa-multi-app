import 'dart:ui';

import 'package:equatable/equatable.dart';

import '../models/refresh_token_response.dart';

sealed class RefreshTokenEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class RefreshRequested extends RefreshTokenEvent {
  final void Function(RefreshTokenResponse)? onSuccess;
  final VoidCallback? onLogoutRequired;

  RefreshRequested({this.onSuccess, this.onLogoutRequired});

  @override
  List<Object?> get props => [onSuccess, onLogoutRequired];
}
