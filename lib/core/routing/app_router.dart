import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kowairo/features/auth/provider/auth_provider.dart';
import 'package:kowairo/features/auth/view/login_screen.dart';
import 'package:kowairo/features/patient_list/view/patient_list_screen.dart';
import 'package:kowairo/features/patient_detail/view/patient_detail_screen.dart';

part 'app_router.g.dart';

// Private routes that require the user to be logged in
const privateRoutes = ['/patients', '/patients/:id'];

@riverpod
GoRouter goRouter(Ref ref) {
  // Watch the auth provider to trigger redirects when auth state changes
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',

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

      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      // If the user is NOT authenticated and is trying to access a private route,
      // redirect them to the login page.
      if (!isAuthenticated && privateRoutes.contains(state.matchedLocation)) {
        // You could also redirect to a "please verify your email" screen here
        return '/login';
      }

      // If the user IS authenticated and tries to go to login/register,
      // redirect them to the main patient list.
      if (isAuthenticated && isLoggingIn) {
        return '/patients';
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
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/patients',
        builder: (context, state) => const PatientListScreen(),
        routes: [
          // Nested route for patient details
          GoRoute(
            path: ':id', // e.g., /patients/123
            builder: (context, state) {
              final patientId = state.pathParameters['id']!;
              return PatientDetailScreen(patientId: patientId);
            },
          ),
        ],
      ),
    ],
  );
}
