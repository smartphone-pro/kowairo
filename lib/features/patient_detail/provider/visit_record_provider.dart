import 'package:kowairo/core/api/supabase_client.dart';
import 'package:kowairo/core/api/user_service.dart';
import 'package:kowairo/domain/entities/visit_record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'visit_record_provider.g.dart';

const _kTableName = 'visit_records';

@riverpod
Future<List<VisitRecord>> visitRecordList(Ref ref, {required String patientId}) async {
  final supabase = ref.watch(supabaseClientProvider);
  final user = ref.read(userServiceProvider).getCurrentUser();
  if (user == null) {
    return [];
  }

  final response = await supabase
      .from(_kTableName)
      .select()
      .eq('user_id', user.id)
      .eq('patient_id', patientId)
      .order('updated_at', ascending: false);

  // Convert the JSON list to a list of VisitRecord entities
  final visitRecords = (response as List<dynamic>)
      .map((json) => VisitRecord.fromJson(Map<String, dynamic>.from(json)))
      .toList();

  return visitRecords;
}

/// 新規訪問記録を作成する
@riverpod
Future<VisitRecord> createVisitRecord(Ref ref, VisitRecord record) async {
  final supabase = ref.watch(supabaseClientProvider);

  // insert して返ってきたレコードを VisitRecord に変換
  final inserted = await supabase.from(_kTableName).insert(record.toJson()..remove('id')).select().single();

  return VisitRecord.fromJson(Map<String, dynamic>.from(inserted as Map));
}
