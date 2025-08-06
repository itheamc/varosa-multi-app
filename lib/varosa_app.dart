import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:varosa_multi_app/core/config/flavor/configuration_provider.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';

import 'core/services/router/app_router.dart';
import 'core/styles/varosa_app_theme.dart';
import 'l10n/app_localizations.dart';
import 'l10n/l10n.dart';

/// Main App Widget
///
class VarosaApp extends StatefulWidget {
  /// Creates new instance of [VarosaApp]
  const VarosaApp({super.key});

  @override
  State<VarosaApp> createState() => _VarosaAppState();
}

class _VarosaAppState extends State<VarosaApp> {
  @override
  void initState() {
    super.initState();

    // Set app orientation
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
      builder: (_, locale) {
        return MaterialApp.router(
          title:
              "VarosaMultiApp - ${ConfigurationProvider.of(context).configuration.flavor.name.capitalize}",
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.system,
          theme: VarosaAppTheme.light(),
          darkTheme: VarosaAppTheme.dark(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
