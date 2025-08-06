import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';

import '../../../../../../core/services/router/app_router.dart';
import '../../bloc/device_info_bloc.dart';
import '../../bloc/device_info_event.dart';
import '../../bloc/device_info_state.dart';
import '../widgets/info_card_view.dart';
import '../widgets/info_native_button.dart';

class DeviceInfoScreen extends StatelessWidget {
  const DeviceInfoScreen({super.key});

  /// Method to navigate to this screen
  ///
  static Future<T?> navigate<T>(BuildContext context, {bool go = false}) async {
    if (go) {
      context.goNamed(AppRouter.deviceInfo.toPathName);
      return null;
    }

    return context.pushNamed(AppRouter.deviceInfo.toPathName);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeviceInfoBloc()..add(LoadDeviceInfo()),
      child: Scaffold(
        appBar: AppBar(title: const Text("Device Info"), centerTitle: true),
        body: Column(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 48.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: InfoNativeButton(
                  text: "Refresh",
                  onPressed: () {
                    context.read<DeviceInfoBloc>().add(LoadDeviceInfo());
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<DeviceInfoBloc, DeviceInfoState>(
                builder: (context, state) {
                  if (state.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.error != null) {
                    return Center(
                      child: Text(
                        state.error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final info = state.info;

                  return ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    children: [
                      InfoCardView(
                        icon: Icons.battery_full,
                        title: "Battery Level",
                        value: "${info?.batteryLevel ?? 0}%",
                        color: Colors.green,
                      ),
                      InfoCardView(
                        icon: Icons.phone_android,
                        title: "Device Model",
                        value: info?.deviceModel ?? "Unknown",
                        color: Colors.blue,
                      ),
                      InfoCardView(
                        icon: Icons.power,
                        title: "Is Charging",
                        value: (info?.isCharging ?? false).toString(),
                        color: Colors.orange,
                      ),
                      InfoCardView(
                        icon: Icons.access_time,
                        title: "System Time",
                        value: info?.systemTime?.toIso8601String() ?? "Unknown",
                        color: Colors.purple,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
