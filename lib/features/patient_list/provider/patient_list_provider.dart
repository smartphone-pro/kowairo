import 'package:kowairo/core/api/supabase_client.dart';
import 'package:kowairo/domain/entities/patient.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'patient_list_provider.g.dart';

@riverpod
Future<List<Patient>> patientList(Ref ref) async {
  final supabase = ref.watch(supabaseClientProvider);

  // Fetch data from the 'patients' table
  final response = await supabase.from('patients').select();

  // Convert the JSON list to a list of Patient entities
  final patients = (response as List<dynamic>)
      .map((json) => Patient.fromJson(Map<String, dynamic>.from(json)))
      .toList();

  return patients;
}
