import 'package:freezed_annotation/freezed_annotation.dart';
import 'date_time_converter.dart';

part 'patient.freezed.dart';

part 'patient.g.dart';

@freezed
abstract class Patient with _$Patient {
  const factory Patient({
    required String id,
    required String stationId,
    required String patientCode,
    required String fullName,
    String? fullNameKana,
    @DateTimeConverter() DateTime? dateOfBirth,
  }) = _Patient;

  factory Patient.fromJson(Map<String, Object?> json) => _$PatientFromJson(json);

  const Patient._();

  int get age {
    final birthday = dateOfBirth;
    if (birthday == null) return 0;
    final now = DateTime.now();
    final age = now.year - birthday.year;
    if (now.month < birthday.month || (now.month == birthday.month && now.day < birthday.day)) {
      return age - 1;
    }
    return age;
  }
}
