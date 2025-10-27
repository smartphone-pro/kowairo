import 'package:freezed_annotation/freezed_annotation.dart';

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
    required String fullName,
    @UserRoleConverter() required UserRole role,
    required String stationId,
    String? phone,
    String? username,
    String? employeeId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
