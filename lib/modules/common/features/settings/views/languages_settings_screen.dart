import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';

import '../../../../../core/services/router/app_router.dart';
import '../../../../../l10n/l10n.dart';

class LanguagesSettingsScreen extends StatelessWidget {
  const LanguagesSettingsScreen({super.key});

  /// Method to navigate to this screen
  ///
  static Future<T?> navigate<T>(BuildContext context, {bool go = false}) async {
    if (go) {
      context.goNamed(AppRouter.languages.toPathName);
      return null;
    }

    return context.pushNamed(AppRouter.languages.toPathName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.appLocalization.languages),
        leading: const BackButton(
          style: ButtonStyle(iconSize: WidgetStatePropertyAll(20)),
        ),
      ),
      body: BlocBuilder<LocaleCubit, Locale>(
        builder: (_, locale) {
          return ListView.separated(
            itemCount: L10n.all.length,
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            itemBuilder: (BuildContext context, int index) {
              final l = L10n.all[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: InkWell(
                  onTap: () {
                    context.read<LocaleCubit>().changeLocale(l);
                  },
                  borderRadius: BorderRadius.circular(12.0),
                  highlightColor: Colors.transparent,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 175),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: l.languageCode == locale.languageCode
                            ? context.theme.colorScheme.primary
                            : context.theme.dividerColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          l.flag,
                          style: context.textTheme.titleLarge?.copyWith(
                            height: 0.75,
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Text(
                          l.unlocalizedLabel,
                          style: context.textTheme.labelLarge,
                        ),
                        const Spacer(),
                        Text(
                          "(${l.translatedLabel})",
                          style: context.textTheme.labelMedium?.copyWith(
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 12.0);
            },
          );
        },
      ),
    );
  }
}
