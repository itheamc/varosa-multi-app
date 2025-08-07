import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'connectivity_service.dart';

class ConnectivityStatusCubit extends Cubit<bool> {
  ConnectivityStatusCubit() : super(true) {
    _subscription = _service.onConnectivityChanged.listen(
      _onConnectivityChanged,
    );
    _initialize();
  }

  final ConnectivityService _service = ConnectivityService.instance;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;

  /// Initial check on startup
  Future<void> _initialize() async {
    final connected = await _service.hasActiveConnection();
    final hasInternet = connected ? await _hasActiveInternet() : false;
    emit(connected && hasInternet);
  }

  Future<void> _onConnectivityChanged(List<ConnectivityResult> results) async {
    final isConnected = _isConnected(results);
    final hasInternet = isConnected ? await _hasActiveInternet() : false;
    emit(isConnected && hasInternet);
  }

  bool _isConnected(List<ConnectivityResult> results) {
    return results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.ethernet) ||
        results.contains(ConnectivityResult.bluetooth);
  }

  Future<bool> _hasActiveInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
