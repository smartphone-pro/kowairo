import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:kowairo/core/api/user_service.dart';
import 'package:kowairo/features/auth/provider/auth_provider.dart';

part 'user_provider.g.dart';

@riverpod
class UserInfo extends _$UserInfo {
  @override
  Future<String> build() async {
    // 認証状態を監視
    ref.listen(authProvider, (previous, next) {
      // 認証状態が変わったら再構築
      ref.invalidateSelf();
    });

    final userService = ref.watch(userServiceProvider);
    return await userService.getUserFullName();
  }

  /// ユーザー情報を更新
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final userService = ref.read(userServiceProvider);
      return await userService.getUserFullName();
    });
  }
}
