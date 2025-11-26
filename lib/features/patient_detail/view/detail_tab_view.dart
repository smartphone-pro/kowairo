import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kowairo/features/patient_detail/provider/tab_index_provider.dart';
import 'package:kowairo/features/patient_detail/view/conference_view.dart';
import 'package:kowairo/features/patient_detail/view/monthly_report_view.dart';
import 'package:kowairo/features/patient_detail/view/visit_record_view.dart';

class DetailTabView extends ConsumerWidget {
  const DetailTabView({required this.patientId, super.key});

  final String patientId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(tabIndexProvider);

    switch (index) {
      case 0:
        return VisitRecordView(patientId: patientId);
      case 1:
        return const ConferenceView();
      case 2:
        return const MonthlyReportView();
      default:
        return const SizedBox.shrink();
    }
  }
}
