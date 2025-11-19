import 'package:freezed_annotation/freezed_annotation.dart';

import 'date_time_converter.dart';

part 'user.freezed.dart';

part 'user.g.dart';

enum UserRole {
  @JsonValue('service_admin')
  serviceAdmin,
  @JsonValue('admin')
  admin,
  @JsonValue('nurse')
  nurse,
}

class UserRoleConverter implements JsonConverter<UserRole?, String?> {
  const UserRoleConverter();

  @override
  UserRole? fromJson(String? json) {
    if (json == null || json.isEmpty) {
      return null;
    }

    switch (json.toLowerCase()) {
      case 'service_admin':
        return UserRole.serviceAdmin;
      case 'admin':
        return UserRole.admin;
      case 'nurse':
        return UserRole.nurse;
      default:
        return null;
    }
  }

  @override
  String? toJson(UserRole? object) {
    if (object == null) return null;

    switch (object) {
      case UserRole.serviceAdmin:
        return 'service_admin';
      case UserRole.admin:
        return 'admin';
      case UserRole.nurse:
        return 'nurse';
    }
  }
}

@freezed
abstract class User with _$User {
  const factory User({
    required String id,

    /// メールアドレス（任意、ダミーアドレス可）
    String? email,
    String? fullName,
    @UserRoleConverter() required UserRole role,
    String? stationId,
    String? phone,
    @Default(true) bool isActive,
    @DateTimeConverter() DateTime? lastActivity,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,

    /// ログイン時に使用するユーザー名（メールアドレスがない場合）
    String? username,

    /// 従業員番号（看護師の識別用）
    String? employeeId,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
