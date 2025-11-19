import 'package:freezed_annotation/freezed_annotation.dart';

import 'date_time_converter.dart';

part 'conference.freezed.dart';

part 'conference.g.dart';

@freezed
abstract class Conference with _$Conference {
  const factory Conference({
    required String id,
    required String stationId,
    required String userId,
    required String patientId,
    @DateTimeConverter() required DateTime conferenceDate,
    String? notes,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _Conference;

  factory Conference.fromJson(Map<String, dynamic> json) => _$ConferenceFromJson(json);
}
