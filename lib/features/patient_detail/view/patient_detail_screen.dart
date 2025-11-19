import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kowairo/features/patient_detail/model/patient_detail_args.dart';

import 'conference_view.dart';
import 'monthly_report_view.dart';
import 'visit_record_view.dart';

class PatientDetailScreen extends ConsumerWidget {
  const PatientDetailScreen({required this.patientId, this.args, super.key});

  final String patientId;
  final PatientDetailArgs? args;

  static const _tabs = [Tab(text: '訪問記録'), Tab(text: 'カンファレンス'), Tab(text: '月次レポート')];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extra = args ?? GoRouterState.of(context).extra as PatientDetailArgs?;
    final patient = extra?.patient;
    final initialTab = extra?.initialTab ?? PatientDetailTab.visitRecord;

    if (patient == null) {
      return const Scaffold(body: Center(child: Text('患者情報が見つかりません。')));
    }

    return DefaultTabController(
      length: _tabs.length,
      initialIndex: initialTab.index,
      child: Scaffold(
        appBar: AppBar(
          title: Text(patient.fullName),
          bottom: const TabBar(tabs: _tabs),
        ),
        body: const TabBarView(children: [VisitRecordView(), ConferenceView(), MonthlyReportView()]),
      ),
    );
  }
}
