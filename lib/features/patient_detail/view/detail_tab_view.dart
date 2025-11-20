import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kowairo/features/patient_detail/provider/tab_index_provider.dart';

import 'conference_view.dart';
import 'monthly_report_view.dart';
import 'visit_record_view.dart';

class DetailTabView extends ConsumerWidget {
  const DetailTabView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(tapIndexProvider);

    switch (index) {
      case 0:
        return VisitRecordView();
      case 1:
        return ConferenceView();
      case 2:
        return MonthlyReportView();
      default:
        return const SizedBox.shrink();
    }
  }
}
