import 'package:kowairo/core/api/supabase_client.dart';
import 'package:kowairo/core/api/user_service.dart';
import 'package:kowairo/domain/entities/patient.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'patient_list_provider.g.dart';

@riverpod
Future<List<Patient>> patientList(Ref ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final userService = ref.watch(userServiceProvider);
  final currentUser = await userService.getCurrentUserProfile();
  final stationId = currentUser?.stationId;
  if (stationId == null) {
    return [];
  }

  // Fetch data from the 'patients' table
  final response = await supabase.from('patients').select().eq('station_id', stationId);

  // Convert the JSON list to a list of Patient entities
  final patients = (response as List<dynamic>)
      .map((json) => Patient.fromJson(Map<String, dynamic>.from(json)))
      .toList();

  return patients;
}

@riverpod
class PatientSearchKeyword extends _$PatientSearchKeyword {
  @override
  String build() => '';

  void updateKeyword(String value) => state = value;
}

@riverpod
AsyncValue<List<Patient>> filteredPatientList(Ref ref) {
  final patientsAsync = ref.watch(patientListProvider);
  final keyword = ref.watch(patientSearchKeywordProvider).trim().toLowerCase();

  if (keyword.isEmpty) return patientsAsync;

  return patientsAsync.whenData(
    (patients) => patients.where((patient) => patient.fullName.toLowerCase().contains(keyword)).toList(),
  );
}
