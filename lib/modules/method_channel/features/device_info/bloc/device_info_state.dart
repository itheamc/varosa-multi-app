import 'package:equatable/equatable.dart';

import '../models/device_info.dart';

class DeviceInfoState extends Equatable {
  final bool loading;
  final DeviceInfo? info;
  final String? error;

  const DeviceInfoState({this.loading = false, this.info, this.error});

  DeviceInfoState copy({bool? loading, DeviceInfo? info, String? error}) {
    return DeviceInfoState(
      loading: loading ?? this.loading,
      info: info ?? this.info,
      error: error,
    );
  }

  @override
  List<Object?> get props => [loading, info, error];
}
