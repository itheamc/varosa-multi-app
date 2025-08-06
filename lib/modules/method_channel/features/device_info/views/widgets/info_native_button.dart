import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InfoNativeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const InfoNativeButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const viewType = 'native-button';

    final creationParams = <String, dynamic>{'text': text};

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          final channel = MethodChannel('native-button-$id');
          channel.setMethodCallHandler((call) async {
            if (call.method == 'onButtonClick') onPressed.call();
          });
        },
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          final channel = MethodChannel('native-button-$id');
          channel.setMethodCallHandler((call) async {
            if (call.method == 'onButtonClick') onPressed.call();
          });
        },
      );
    } else {
      return const Text('Unsupported platform');
    }
  }
}
