import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import 'date_time_converter.dart';

part 'patient.freezed.dart';

part 'patient.g.dart';

enum Gender {
  @JsonValue('male')
  male,
  @JsonValue('female')
  female,
  @JsonValue('other')
  other,
}

class GenderConverter implements JsonConverter<Gender?, String> {
  const GenderConverter();

  @override
  Gender? fromJson(String json) {
    if (json.isEmpty) {
      return null;
    }

    switch (json.toLowerCase()) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      case 'other':
        return Gender.other;
      default:
        return null;
    }
  }

  @override
  String toJson(Gender? object) {
    if (object == null) return '';

    switch (object) {
      case Gender.male:
        return 'male';
      case Gender.female:
        return 'female';
      case Gender.other:
        return 'other';
    }
  }
}

@freezed
abstract class Patient with _$Patient {
  const factory Patient({
    required String id,
    required String stationId,
    required String patientCode,
    required String fullName,
    String? fullNameKana,
    @DateTimeConverter() DateTime? dateOfBirth,
    @GenderConverter() Gender? gender,
    String? phone,
    String? address,
    String? emergencyContact,
    String? notes,
    @Default(true) bool isActive,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _Patient;

  factory Patient.fromJson(Map<String, Object?> json) => _$PatientFromJson(json);

  const Patient._();

  String get age {
    final birthday = dateOfBirth;
    if (birthday == null) return '';
    final now = DateTime.now();
    final age = now.year - birthday.year;
    if (now.month < birthday.month || (now.month == birthday.month && now.day < birthday.day)) {
      return '${age - 1}歳';
    }
    return '$age歳';
  }

  String get birthday {
    final birthday = dateOfBirth;
    if (birthday == null) return '';
    return '${DateFormat.yMMMMd('ja').format(birthday)}生';
  }
}
