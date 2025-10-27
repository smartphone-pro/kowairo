import 'package:kowairo/core/api/supabase_client.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  Future<User?> build() async {
    // Return the initial user state
    return ref.watch(supabaseClientProvider).auth.currentUser;
  }

  Future<void> signInWithPassword(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final authResponse = await ref
          .read(supabaseClientProvider)
          .auth
          .signInWithPassword(email: email, password: password);
      return authResponse.user;
    });
  }

  Future<void> signOut() async {
    await ref.read(supabaseClientProvider).auth.signOut();
    state = const AsyncValue.data(null);
  }
}
