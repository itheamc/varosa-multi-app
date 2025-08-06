import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/device_info.dart';
import 'device_info_event.dart';
import 'device_info_state.dart';

class DeviceInfoBloc extends Bloc<DeviceInfoEvent, DeviceInfoState> {
  static const _channel = MethodChannel(
    'com.itheamc.varosa_multi_app/native_channel',
  );

  DeviceInfoBloc() : super(DeviceInfoState()) {
    on<LoadDeviceInfo>(_onLoadDeviceInfo);
  }

  Future<void> _onLoadDeviceInfo(
    LoadDeviceInfo event,
    Emitter<DeviceInfoState> emit,
  ) async {
    emit(state.copy(loading: true, error: null));
    try {
      final result = await _channel.invokeMethod('getDeviceInfo');
      emit(
        state.copy(
          loading: false,
          info: result != null ? DeviceInfo.fromJson(result) : null,
        ),
      );
    } on PlatformException catch (e) {
      emit(state.copy(loading: false, error: e.message ?? 'Unknown error'));
    }
  }
}
