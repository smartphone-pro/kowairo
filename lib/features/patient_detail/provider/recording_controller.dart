import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recording_controller.g.dart';

enum RecordingStatus {
  normal, // 何もしていない
  recording, // 録音中
  generating, // 生成中
}

@riverpod
class RecordingController extends _$RecordingController {
  @override
  RecordingStatus build() {
    return RecordingStatus.normal;
  }

  void startRecording() {
    state = RecordingStatus.recording;
  }

  Future<void> stopRecording() async {
    state = RecordingStatus.generating;
    await Future.delayed(const Duration(seconds: 2));
    state = RecordingStatus.normal;
  }
}
