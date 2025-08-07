import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:varosa_multi_app/core/services/connectivity/connectivity_status_cubit.dart';
import 'package:varosa_multi_app/ui/features/onboarding/blocs/active_onboarding_item_cubit.dart';
import 'package:varosa_multi_app/ui/features/onboarding/blocs/onboarding_status_cubit.dart';

import 'core/config/env/env.dart';
import 'core/config/flavor/configuration_provider.dart';
import 'core/config/flavor/flavor.dart';
import 'core/config/flavor/configuration.dart';
import 'core/services/firebase/firebase_notification/fcm_notification_service.dart';
import 'core/services/network/dio_http_service.dart';
import 'core/services/network/http_service.dart';
import 'core/services/storage/hive_storage_service.dart';
import 'core/services/storage/storage_service.dart';
import 'firebase_options.dart';
import 'l10n/l10n.dart';
import 'modules/mini_ecommerce/features/products/bloc/products_list_bloc.dart';
import 'modules/mini_ecommerce/features/products/repositories/products_repository.dart';
import 'modules/mini_ecommerce/features/products/repositories/products_repository_impl.dart';
import 'modules/todo_app/features/todos/repositories/todos_repository.dart';
import 'modules/todo_app/features/todos/repositories/todos_repository_impl.dart';
import 'utils/logger.dart';
import 'varosa_app.dart';

Future<void> main() async {
  // Ensuring widgets flutter binding initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing and loading data from .env
  await Env.instance.load();

  // Firebase app and local notification initialization
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Setup and initialize location notification
    if (!kIsWeb) {
      await setupFlutterLocalNotifications();
    }

    // Adding listener for onBackgroundMessage callback
    // (background & terminated)
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    // Error Initializing Firebase App
    Logger.logError("[main -> initializeApp] ---> $e");
  }

  // Flavor configuration
  final configuration = Configuration.of(Flavor.fromEnvironment);

  // Hive-specific initialization
  final storageService = HiveStorageService.instance;
  await storageService.init(configuration.hiveBoxName);

  runApp(
    ConfigurationProvider(
      configuration: configuration,
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<Configuration>.value(value: configuration),
          RepositoryProvider<StorageService>.value(value: storageService),
          RepositoryProvider<HttpService>(
            create: (context) => DioHttpService(
              context.read<Configuration>(),
              context.read<StorageService>(),
            ),
          ),
          RepositoryProvider<ProductsRepository>(
            create: (context) {
              return ProductsRepositoryImpl(context.read<HttpService>());
            },
          ),
          RepositoryProvider<TodosRepository>(
            create: (_) {
              return TodosRepositoryImpl();
            },
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) =>
                  LocaleCubit(storageService: context.read<StorageService>()),
            ),
            BlocProvider(create: (_) => ConnectivityStatusCubit()),
            BlocProvider(
              create: (context) =>
                  OnboardingStatusCubit(context.read<StorageService>()),
            ),
            BlocProvider(create: (_) => ActiveOnboardingItemCubit()),
            BlocProvider(
              create: (context) =>
                  ProductsListBloc(context.read<ProductsRepository>()),
            ),
          ],
          child: VarosaApp(),
        ),
      ),
    ),
  );
}

/// Method to handle the background notification handling and display
///
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (!kIsWeb) {
      await setupFlutterLocalNotifications();
    }
    // showFirebaseNotification(message);
  } catch (e) {
    Logger.logError("[main -> _firebaseMessagingBackgroundHandler] ---> $e");
  }
}
