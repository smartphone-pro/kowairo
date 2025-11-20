import 'package:kowairo/core/api/supabase_client.dart';
import 'package:kowairo/core/api/user_service.dart';
import 'package:kowairo/domain/entities/visit_record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'visit_record_provider.g.dart';

@riverpod
Future<List<VisitRecord>> visitRecordList(Ref ref, {required String patientId}) async {
  final supabase = ref.watch(supabaseClientProvider);
  final user = ref.read(userServiceProvider).getCurrentUser();
  if (user == null) {
    return [];
  }

  final response = await supabase.from('visit_records').select().eq('user_id', user.id).eq('patient_id', patientId);

  // Convert the JSON list to a list of VisitRecord entities
  final visitRecords = (response as List<dynamic>)
      .map((json) => VisitRecord.fromJson(Map<String, dynamic>.from(json)))
      .toList();

  return visitRecords;
}
