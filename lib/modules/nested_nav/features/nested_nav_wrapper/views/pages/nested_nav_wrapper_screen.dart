import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:varosa_multi_app/utils/extension_functions.dart';

import '../../../../../../core/services/connectivity/connectivity_status_cubit.dart';
import '../../../../../../core/services/firebase/firebase_notification/fcm_notification_handler.dart';
import '../../../item1/bloc/counter_cubit_1.dart';
import '../../../item2/bloc/counter_cubit_2.dart';
import '../../../item3/bloc/counter_cubit_3.dart';
import '../../enums/nav_item.dart';
import '../widgets/naxa_bottom_navigation.dart';

class NestedNavWrapperScreen extends StatefulWidget {
  final StatefulNavigationShell shell;
  final GoRouterState state;

  const NestedNavWrapperScreen({
    super.key,
    required this.shell,
    required this.state,
  });

  @override
  State<NestedNavWrapperScreen> createState() => _NestedNavWrapperScreenState();
}

class _NestedNavWrapperScreenState extends State<NestedNavWrapperScreen> {
  /// Init State
  ///
  @override
  void initState() {
    super.initState();

    // Initialize firebase notification service
    _initializeFirebaseNotificationService();
  }

  /// Method to set up firebase notification service
  ///
  Future<void> _initializeFirebaseNotificationService() async {
    FCMNotificationHandler.requestPermission().then((granted) {
      // If not granted return
      if (!granted) return;

      // Else initialize
      FCMNotificationHandler.initialize(
        onTokenRefreshed: (token) {
          // Update token to database
          if (mounted) {
            final connected = context.read<ConnectivityStatusCubit>();

            // If internet available
            if (connected.state) {
              // Here, you  can update fcm token to the server
            }
          }
        },
        onMessageOpenedApp: (message) {
          // Handle navigation as per the data
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // I am adding block providers here as this os the starting of the
    // nested_nav app module And i want to separate this from the main app module
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CounterCubit1()),
        BlocProvider(create: (_) => CounterCubit2()),
        BlocProvider(create: (_) => CounterCubit3()),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: context.theme.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        ),
        child: Scaffold(
          body: widget.shell,
          bottomNavigationBar: AnimatedSize(
            duration: const Duration(milliseconds: 175),
            child: VarosaBottomNavigation(
              items: NavItem.values,
              currentNavItem: NavItem.values[widget.shell.currentIndex],
              onSelect: (i, item) {
                widget.shell.goBranch(i);
              },
            ),
          ),
        ),
      ),
    );
  }
}
