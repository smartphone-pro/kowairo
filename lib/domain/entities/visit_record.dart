import 'package:freezed_annotation/freezed_annotation.dart';

import 'date_time_converter.dart';

part 'visit_record.freezed.dart';

part 'visit_record.g.dart';

enum RecordStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('completed')
  completed,
}

class RecordStatusConverter implements JsonConverter<RecordStatus, String> {
  const RecordStatusConverter();

  @override
  RecordStatus fromJson(String json) {
    switch (json) {
      case 'draft':
        return RecordStatus.draft;
      case 'scheduled':
        return RecordStatus.scheduled;
      case 'completed':
        return RecordStatus.completed;
      default:
        throw ArgumentError('Invalid RecordStatus value: $json');
    }
  }

  @override
  String toJson(RecordStatus object) {
    switch (object) {
      case RecordStatus.draft:
        return 'draft';
      case RecordStatus.scheduled:
        return 'scheduled';
      case RecordStatus.completed:
        return 'completed';
    }
  }
}

@freezed
abstract class VisitRecord with _$VisitRecord {
  const factory VisitRecord({
    required String id,
    required String stationId,
    required String userId,
    required String patientId,
    @DateTimeConverter() required DateTime visitDate,
    @DateTimeConverter() required DateTime visitStartTime,
    @DateTimeConverter() DateTime? visitEndTime,
    @RecordStatusConverter() required RecordStatus status,
    String? notes,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,
    String? soapSubjective,
    String? soapObjective,
    String? soapAssessment,
    String? soapPlan,
    String? lifestyleMemo,
    String? transcriptionText,
    String? recordingUrl,
    bool? hasRecordings,

    /// SOAPのAssessment(評価)とPlan(計画)を統合したA/P欄
    String? soapAssessmentPlan,
  }) = _VisitRecord;

  factory VisitRecord.fromJson(Map<String, dynamic> json) => _$VisitRecordFromJson(json);
}
