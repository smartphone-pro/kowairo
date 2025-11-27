import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kowairo/features/patient_detail/model/recording_state.dart';
import 'package:kowairo/features/patient_detail/provider/recording_controller.dart';
import 'package:kowairo/gen/assets.gen.dart';
import 'package:kowairo/gen/colors.gen.dart';

class RecordingBar extends StatelessWidget {
  const RecordingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.primaryText,
      child: SafeArea(child: SizedBox(height: 100, child: _BarContent())),
    );
  }
}

class _BarContent extends ConsumerWidget {
  const _BarContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordingState = ref.watch(recordingControllerProvider);

    switch (recordingState.status) {
      case RecordingStatus.normal:
        return _NormalContent(onTapRecord: () => ref.read(recordingControllerProvider.notifier).startRecording());
      case RecordingStatus.recording:
        return _RecordingContent(onTapStop: () => ref.read(recordingControllerProvider.notifier).stopRecording());
      case RecordingStatus.generating:
        return const _GeneratingContent();
    }
  }
}

// 何もしていない状態
class _NormalContent extends StatelessWidget {
  const _NormalContent({this.onTapRecord});

  final VoidCallback? onTapRecord;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onTapRecord,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppColors.orange,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 28),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            Assets.icons.icWave.svg(),
            const Text('今日の訪問記録を開始', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
            Assets.icons.icWave.svg(),
          ],
        ),
      ),
    );
  }
}

// 録音中
class _RecordingContent extends StatelessWidget {
  const _RecordingContent({this.onTapStop});

  final VoidCallback? onTapStop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        spacing: 30,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                Assets.icons.icWave.svg(),
                const Text(
                  '録音中...',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          InkWell(onTap: onTapStop, child: Assets.icons.icStop.svg()),
          const Spacer(),
        ],
      ),
    );
  }
}

// 生成中
class _GeneratingContent extends StatelessWidget {
  const _GeneratingContent();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '訪問記録を生成中...',
        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
      ),
    );
  }
}
