import 'package:freezed_annotation/freezed_annotation.dart';

part 'station.freezed.dart';

part 'station.g.dart';

@freezed
abstract class Station with _$Station {
  const factory Station({
    required String id,
    required String name,
    required String address,
    String? phone,
    String? email,
    String? description,
    String? directorName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Station;

  factory Station.fromJson(Map<String, dynamic> json) =>
      _$StationFromJson(json);
}
