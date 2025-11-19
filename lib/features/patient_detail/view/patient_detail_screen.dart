import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kowairo/domain/entities/patient.dart';

import 'conference_view.dart';
import 'monthly_report_view.dart';
import 'visit_record_view.dart';

class PatientDetailScreen extends ConsumerWidget {
  const PatientDetailScreen({required this.patientId, super.key});

  final String patientId;

  static const _tabs = [Tab(text: '訪問記録'), Tab(text: 'カンファレンス'), Tab(text: '月次レポート')];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patient = GoRouterState.of(context).extra as Patient;
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(patient.fullName),
          bottom: const TabBar(tabs: _tabs),
        ),
        body: TabBarView(children: [VisitRecordView(), ConferenceView(), MonthlyReportView()]),
      ),
    );
  }
}
