import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'configuration.dart';

class ConfigurationProvider extends InheritedWidget {
  final Configuration configuration;

  const ConfigurationProvider({
    super.key,
    required this.configuration,
    required super.child,
  });

  static ConfigurationProvider of(BuildContext context) {
    final ConfigurationProvider? result = context
        .dependOnInheritedWidgetOfExactType<ConfigurationProvider>();
    assert(
      result != null,
      'No ConfigurationProvider found in the widget tree.',
    );
    return result!;
  }

  static ConfigurationProvider? maybeOf(BuildContext context) {
    final ConfigurationProvider? result = context
        .dependOnInheritedWidgetOfExactType<ConfigurationProvider>();
    return result!;
  }

  @override
  bool updateShouldNotify(covariant ConfigurationProvider oldWidget) {
    throw configuration != oldWidget.configuration;
  }
}

/// Cubit that provides instance of [Configuration]
///
class ConfigurationCubit extends Cubit<Configuration> {
  ConfigurationCubit() : super(Configuration.of());
}
