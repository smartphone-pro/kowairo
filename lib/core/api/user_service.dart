import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kowairo/core/api/supabase_client.dart';
import 'package:kowairo/domain/entities/user.dart' as app_user;

part 'user_service.g.dart';

@riverpod
UserService userService(Ref ref) {
  return UserService(ref.watch(supabaseClientProvider));
}

class UserService {
  final SupabaseClient _supabase;

  UserService(this._supabase);

  /// 現在ログインしているユーザーの情報を取得
  User? getCurrentUser() {
    return _supabase.auth.currentUser;
  }

  /// ユーザーのプロフィール情報を取得（usersテーブルから）
  Future<app_user.User?> getUserProfile(String userId) async {
    try {
      final response = await _supabase.from('users').select().eq('id', userId).single();
      return app_user.User.fromJson(response);
    } catch (e) {
      // ユーザーが見つからない場合はnullを返す
      return null;
    }
  }

  /// 現在ログインしているユーザーの完全な情報を取得
  Future<app_user.User?> getCurrentUserProfile() async {
    final user = getCurrentUser();
    if (user == null) return null;

    return await getUserProfile(user.id);
  }
}
