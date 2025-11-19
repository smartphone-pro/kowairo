import 'package:freezed_annotation/freezed_annotation.dart';

import 'date_time_converter.dart';

part 'monthly_report.freezed.dart';

part 'monthly_report.g.dart';

@freezed
abstract class MonthlyReport with _$MonthlyReport {
  const factory MonthlyReport({
    required String id,
    required String patientId,
    required String stationId,
    required String createdBy,
    required int year,
    required int month,
    String? conditionProgress,
    String? nursingContent,
    Map<String, dynamic>? soapDataSummary,
    @Default(false) bool isApproved,
    String? approvedBy,
    @DateTimeConverter() DateTime? approvedAt,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _MonthlyReport;

  factory MonthlyReport.fromJson(Map<String, dynamic> json) => _$MonthlyReportFromJson(json);
}
