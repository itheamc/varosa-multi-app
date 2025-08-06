class DeviceInfo {
  final String? deviceModel;
  final bool? isCharging;
  final int? batteryLevel;
  final DateTime? systemTime;

  DeviceInfo({
    this.deviceModel,
    this.isCharging,
    this.batteryLevel,
    this.systemTime,
  });

  factory DeviceInfo.fromJson(dynamic json) => DeviceInfo(
    deviceModel: json["deviceModel"]?.toString(),
    isCharging: bool.tryParse(json["isCharging"]?.toString() ?? 'false'),
    batteryLevel: int.tryParse(json["batteryLevel"]?.toString() ?? '0'),
    systemTime: json["systemTime"] == null
        ? null
        : DateTime.tryParse(json["systemTime"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "deviceModel": deviceModel,
    "isCharging": isCharging,
    "batteryLevel": batteryLevel,
    "systemTime": systemTime?.toIso8601String(),
  };
}
