import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/services/firebase/firebase_notification/fcm_notification_handler.dart';
import '../../../../../core/services/connectivity/connectivity_status_cubit.dart';
import '../../../../../ui/features/main_wrapper/views/widgets/naxa_bottom_navigation.dart';
import '../../enums/nav_item.dart';
import '../../../../../utils/extension_functions.dart';

class MainWrapperScreen extends StatefulWidget {
  final StatefulNavigationShell shell;
  final GoRouterState state;

  const MainWrapperScreen({
    super.key,
    required this.shell,
    required this.state,
  });

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  /// For controlling the visibility of bottom navigation and app bar
  ///
  bool get _showNavBar => NavItem.values
      .map((e) => e.path)
      .any(
        (p) => context.goRouter.routeInformationProvider.value.uri.path
            .startsWith(p),
      );

  /// For controlling the visibility app bar
  ///
  // bool get _showAppBar {
  //   // getting the paths of navigation items excluding the "profile" & "map"
  //   final paths = NavItem.values
  //       .where((item) => (item != NavItem.profile && item != NavItem.map))
  //       .map((e) => e.path);
  //
  //   // Checking if the current route's path matches any of the remaining paths
  //   return paths
  //       .contains(context.goRouter.routeInformationProvider.value.uri.path);
  // }

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
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
          child: _showNavBar
              ? VarosaBottomNavigation(
                  items: NavItem.values,
                  currentNavItem: NavItem.values[widget.shell.currentIndex],
                  onSelect: (i, item) {
                    widget.shell.goBranch(i);
                  },
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
