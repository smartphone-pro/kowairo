import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kowairo/features/auth/provider/auth_provider.dart';
import 'package:kowairo/features/auth/view/login_screen.dart';
import 'package:kowairo/features/patient_list/view/patient_list_screen.dart';
import 'package:kowairo/features/patient_detail/view/patient_detail_screen.dart';
import 'package:kowairo/features/patient_detail/model/patient_detail_args.dart';

part 'app_router.g.dart';

enum RoutePath {
  login('login'),
  patients('patients'),
  patientDetail('patients/:id');

  const RoutePath(this.pathKey);

  final String pathKey;

  String get path => '/$pathKey';

  String withId(String id) {
    if (!pathKey.contains(':')) {
      return path;
    }
    return '/${pathKey.replaceAll(':id', id)}';
  }

  bool matches(String location) {
    if (!pathKey.contains(':')) {
      return location == path;
    }
    final templatedPattern = path.replaceAllMapped(RegExp(r':[^/]+'), (_) => r'[^/]+');
    return RegExp('^$templatedPattern\$').hasMatch(location);
  }
}

// Private routes that require the user to be logged in
const privateRoutes = [RoutePath.patients, RoutePath.patientDetail];

bool _isPrivateRoute(String location) {
  return privateRoutes.any((route) => route.matches(location));
}

@riverpod
GoRouter goRouter(Ref ref) {
  // Watch the auth provider to trigger redirects when auth state changes
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: RoutePath.login.path,

    errorBuilder: (context, state) => Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),

    // refreshListenable: // Optional: for more complex scenarios
    redirect: (context, state) {
      // Get the current auth state value (the User object or null)
      final user = authState.value;

      // Check if the user is logged in
      final isLoggedIn = user != null;

      // Correctly check for Supabase email verification status.
      // It's in the user_metadata.
      final isEmailVerified = user?.userMetadata?['email_verified'] == true;

      // The user is fully authenticated only if they are logged in AND verified.
      final isAuthenticated = isLoggedIn && isEmailVerified;

      final isLoggingIn = state.matchedLocation == RoutePath.login.path;

      // If the user is NOT authenticated and is trying to access a private route,
      // redirect them to the login page.
      if (!isAuthenticated && _isPrivateRoute(state.matchedLocation)) {
        // You could also redirect to a "please verify your email" screen here
        return RoutePath.login.path;
      }

      // If the user IS authenticated and tries to go to login/register,
      // redirect them to the main patient list.
      if (isAuthenticated && isLoggingIn) {
        return RoutePath.patients.path;
      }

      // If a user is logged in but their email is not verified,
      // and they are on the login/register page, keep them there to avoid a redirect loop.
      if (isLoggedIn && !isEmailVerified && isLoggingIn) {
        return null;
      }

      // No redirect needed in all other cases.
      return null;
    },
    routes: [
      GoRoute(path: RoutePath.login.path, builder: (context, state) => const LoginScreen()),
      GoRoute(path: RoutePath.patients.path, builder: (context, state) => const PatientListScreen()),
      GoRoute(
        path: RoutePath.patientDetail.path,
        builder: (context, state) {
          final patientId = state.pathParameters['id']!;
          final args = state.extra is PatientDetailArgs ? state.extra as PatientDetailArgs : null;
          return PatientDetailScreen(patientId: patientId, args: args);
        },
      ),
    ],
  );
}
