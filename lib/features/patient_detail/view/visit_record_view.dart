import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kowairo/domain/entities/visit_record.dart';
import 'package:kowairo/features/patient_detail/provider/visit_record_provider.dart';

class VisitRecordView extends ConsumerWidget {
  const VisitRecordView({required this.patientId, super.key});

  final String patientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsAsync = ref.watch(visitRecordListProvider(patientId: patientId));

    return recordsAsync.when(
      data: (records) {
        if (records.isEmpty) {
          return const Center(child: Text('訪問記録がありません。'));
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          itemBuilder: (context, index) => _VisitRecordTile(record: records[index]),
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemCount: records.length,
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('訪問記録の取得に失敗しました。'),
            const SizedBox(height: 8),
            Text(error.toString(), style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(visitRecordListProvider(patientId: patientId)),
              child: const Text('再読み込み'),
            ),
          ],
        ),
      ),
    );
  }
}

class _VisitRecordTile extends StatelessWidget {
  const _VisitRecordTile({required this.record});

  final VisitRecord record;

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat('yyyy/MM/dd').format(record.visitDate);
    final start = record.visitStartTime.format(context);
    final end = record.visitEndTime != null ? record.visitEndTime!.format(context) : '--:--';

    return Card(
      child: ListTile(
        title: Text('$dateText  $start - $end'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ステータス: ${record.status.name}'),
            if (record.notes?.isNotEmpty ?? false) Text('メモ: ${record.notes}'),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
