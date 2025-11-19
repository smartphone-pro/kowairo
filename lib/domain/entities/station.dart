import 'package:freezed_annotation/freezed_annotation.dart';

import 'date_time_converter.dart';

part 'station.freezed.dart';

part 'station.g.dart';

@freezed
abstract class Station with _$Station {
  const factory Station({
    required String id,
    required String name,
    required String address,
    required String phone,
    String? email,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,

    /// ステーションの説明文
    String? description,

    /// ステーション管理者名
    required String directorName,

    /// ステーションの有効/無効状態
    @Default(true) bool isActive,
  }) = _Station;

  factory Station.fromJson(Map<String, dynamic> json) => _$StationFromJson(json);
}
