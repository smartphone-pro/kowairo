import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kowairo/core/api/supabase_client.dart';

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
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      return response;
    } catch (e) {
      // ユーザーが見つからない場合はnullを返す
      return null;
    }
  }

  /// ユーザーのフルネームを取得
  /// usersテーブルから取得し、ない場合はメタデータから取得
  Future<String> getUserFullName() async {
    final user = getCurrentUser();
    if (user == null) return '';

    // まずusersテーブルから取得を試行
    final userProfile = await getUserProfile(user.id);
    if (userProfile != null && userProfile['full_name'] != null) {
      return userProfile['full_name'] as String;
    }

    // usersテーブルにない場合は、ユーザーメタデータから取得
    final userMetadata = user.userMetadata;
    if (userMetadata != null) {
      // メタデータからフルネームを構築
      final firstName = userMetadata['first_name'] as String?;
      final lastName = userMetadata['last_name'] as String?;

      if (firstName != null && lastName != null) {
        return '$lastName $firstName';
      }

      // フルネームが直接メタデータにある場合
      final fullName = userMetadata['full_name'] as String?;
      if (fullName != null) {
        return fullName;
      }
    }

    // メタデータにもない場合は、メールアドレスの@より前の部分を使用
    final email = user.email;
    if (email != null) {
      return email.split('@')[0];
    }

    return 'ユーザー';
  }

  /// ユーザーのステーション情報を取得
  Future<Map<String, dynamic>?> getUserStation(String stationId) async {
    try {
      final response = await _supabase
          .from('stations')
          .select()
          .eq('id', stationId)
          .single();
      return response;
    } catch (e) {
      return null;
    }
  }

  /// 現在ログインしているユーザーの完全な情報を取得
  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    final user = getCurrentUser();
    if (user == null) return null;

    return await getUserProfile(user.id);
  }
}
