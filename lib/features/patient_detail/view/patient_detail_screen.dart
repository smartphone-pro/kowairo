import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kowairo/features/patient_detail/model/patient_detail_args.dart';
import 'package:kowairo/features/patient_detail/view/detail_tab_view.dart';
import 'package:kowairo/features/patient_detail/widgets/back_list_button.dart';
import 'package:kowairo/features/patient_detail/widgets/top_tab_bar.dart';

class PatientDetailScreen extends ConsumerWidget {
  const PatientDetailScreen({required this.patientId, this.args, super.key});

  final String patientId;
  final PatientDetailArgs? args;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extra = args ?? GoRouterState.of(context).extra as PatientDetailArgs?;
    final patient = extra?.patient;

    if (patient == null) {
      return const Scaffold(body: Center(child: Text('患者情報が見つかりません。')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(patient.fullName),
        leading: const BackListButton(),
        leadingWidth: 130,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 5,
              children: [
                Text(patient.birthday, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
                Text(patient.age, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(42),
          child: Padding(padding: const EdgeInsets.symmetric(horizontal: 30), child: const TopTabBar()),
        ),
      ),
      body: const DetailTabView(),
    );
  }
}
