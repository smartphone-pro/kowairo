import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kowairo/core/api/user_service.dart';
import 'package:kowairo/domain/entities/visit_record.dart';
import 'package:kowairo/features/patient_detail/model/patient_detail_args.dart';
import 'package:kowairo/features/patient_detail/model/recording_state.dart';
import 'package:kowairo/features/patient_detail/provider/recording_controller.dart';
import 'package:kowairo/features/patient_detail/provider/tab_index_provider.dart';
import 'package:kowairo/features/patient_detail/provider/visit_record_provider.dart';
import 'package:kowairo/features/patient_detail/view/detail_tab_view.dart';
import 'package:kowairo/features/patient_detail/view/recording_bar.dart';
import 'package:kowairo/features/patient_detail/widgets/back_list_button.dart';
import 'package:kowairo/features/patient_detail/widgets/top_tab_bar.dart';
import 'package:kowairo/main.dart';

class PatientDetailScreen extends ConsumerStatefulWidget {
  const PatientDetailScreen({required this.patientId, this.args, super.key});

  final String patientId;
  final PatientDetailArgs? args;

  @override
  ConsumerState<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends ConsumerState<PatientDetailScreen> {
  late final ProviderSubscription<RecordingState> _recordingSub;

  @override
  void initState() {
    super.initState();

    final extra = widget.args ?? GoRouterState.of(context).extra as PatientDetailArgs?;
    final initialTabIndex = extra?.initialTab.index;
    if (initialTabIndex != null) {
      Future.microtask(() => ref.read(tabIndexProvider.notifier).setTab(initialTabIndex));
    }

    // RecordingState の変化を監視
    _recordingSub = ref.listenManual<RecordingState>(recordingControllerProvider, (previous, next) {
      final finishedTranscribing =
          previous?.status == RecordingStatus.generating &&
          next.status == RecordingStatus.normal &&
          next.transcribedText.isNotEmpty;

      if (finishedTranscribing) {
        _showSaveDialog(next.transcribedText);
      }
    });
  }

  @override
  void dispose() {
    _recordingSub.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final extra = widget.args ?? GoRouterState.of(context).extra as PatientDetailArgs?;
    final patient = extra?.patient;

    if (patient == null) {
      return const Scaffold(body: Center(child: Text('患者情報が見つかりません。')));
    }

    final tabIndex = ref.watch(tabIndexProvider);

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
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(42),
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 30), child: TopTabBar()),
        ),
      ),
      body: DetailTabView(patientId: widget.patientId),
      bottomNavigationBar: tabIndex == 2 ? null : const RecordingBar(),
    );
  }

  Future<void> _showSaveDialog(String transcribedText) async {
    if (!mounted) return;

    final extra = widget.args ?? GoRouterState.of(context).extra as PatientDetailArgs?;
    final patient = extra?.patient;
    if (patient == null) return;

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('文字起こしを保存しますか？'),
          content: SingleChildScrollView(child: Text(transcribedText, style: const TextStyle(fontSize: 14))),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('キャンセル')),
            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('保存')),
          ],
        );
      },
    );

    if (shouldSave != true) return;

    // Supabase へ visit_records を作成
    try {
      final userService = ref.read(userServiceProvider);
      final user = userService.getCurrentUser();
      if (user == null) {
        logger.e('User is not logged in');
        return;
      }

      await ref.read(
        createVisitRecordProvider(
          VisitRecord(
            id: '',
            stationId: patient.stationId,
            userId: user.id,
            patientId: widget.patientId,
            visitDate: DateTime.now(),
            visitStartTime: TimeOfDay.now(),
            status: RecordStatus.completed,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            transcriptionText: transcribedText,
            hasRecordings: true,
          ),
        ).future,
      );

      // ここで list を invalidate
      ref.invalidate(visitRecordListProvider(patientId: widget.patientId));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('訪問記録を保存しました')));
    } catch (e) {
      if (!mounted) return;
      logger.e('Failed to save visit record: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('保存に失敗しました')));
    }
  }
}
