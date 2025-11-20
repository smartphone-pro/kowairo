import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kowairo/features/patient_detail/provider/visit_record_provider.dart';
import 'package:kowairo/features/patient_detail/widgets/visit_record_tile.dart';

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
          itemBuilder: (_, index) => VisitRecordTile(record: records[index]),
          separatorBuilder: (_, _) => const Divider(height: 1),
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
