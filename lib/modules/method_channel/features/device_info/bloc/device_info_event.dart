import 'package:equatable/equatable.dart';

abstract class DeviceInfoEvent extends Equatable {
  const DeviceInfoEvent();

  @override
  List<Object?> get props => [];
}

class LoadDeviceInfo extends DeviceInfoEvent {}
