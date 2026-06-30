import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../feature/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../feature/auth/presentation/pages/auth_page.dart';
import '../../feature/main/presentation/page/main_page.dart';
import '../../feature/services/presentation/page/services_page.dart';
import '../di/injection.dart';
import '../notifier/auth_notifier.dart';
import 'routes_name.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RoutesName.loginPath,
    debugLogDiagnostics: true,
    refreshListenable: inject<AuthNotifier>(),
    redirect: (context, state) {
      final auth = inject<AuthNotifier>();
      final path = state.uri.path;
      final isLogin = path == RoutesName.loginPath;

      if (!auth.initialized) {
        return null;
      }

      if (!auth.isAuthenticated) {
        return isLogin ? null : RoutesName.loginPath;
      }

      if (isLogin) {
        return RoutesName.servicesPath;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RoutesName.loginPath,
        name: RoutesName.loginName,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => inject<AuthBloc>(),
            child: const AuthPage(),
          );
        },
      ),
      GoRoute(
        path: RoutesName.servicesPath,
        name: RoutesName.servicesName,
        builder: (context, state) => const ServicesPage(),
      ),
      GoRoute(
        path: RoutesName.renewalPath,
        name: RoutesName.renewalName,
        builder: (context, state) {
          final serviceType =
              state.pathParameters['serviceType'] ?? 'id_renewal';
          return MainPage(serviceType: serviceType);
        },
      ),
    ],
  );
}
