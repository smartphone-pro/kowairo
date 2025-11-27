import 'dart:io';

import 'package:flutter/services.dart';
import 'package:kowairo/features/patient_detail/model/recording_state.dart';
import 'package:kowairo/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:whisper_ggml/whisper_ggml.dart';

part 'recording_controller.g.dart';

@riverpod
class RecordingController extends _$RecordingController {
  late final AudioRecorder _audioRecorder;
  late final WhisperController _whisperController;
  final _model = WhisperModel.tiny;

  @override
  RecordingState build() {
    _audioRecorder = AudioRecorder();
    _whisperController = WhisperController();

    _initModel();

    ref.onDispose(() {
      _audioRecorder.dispose();
    });

    return const RecordingState();
  }

  Future<void> _initModel() async {
    try {
      final bytes = await rootBundle.load('assets/ggml/ggml-${_model.modelName}.bin');
      final modelPath = await _whisperController.getPath(_model);
      final file = File(modelPath);
      await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
      logger.d('Model copied to $modelPath');
    } catch (_) {
      await _whisperController.downloadModel(_model);
      logger.d('Model downloaded');
    }
  }

  Future<void> startRecording() async {
    if (!await _audioRecorder.hasPermission()) {
      state = state.copyWith(statusText: 'マイク権限がありません');
      return;
    }

    if (await _audioRecorder.isRecording()) return;

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/record.m4a';

    state = state.copyWith(status: RecordingStatus.recording, transcribedText: '', statusText: '録音中...');

    await _audioRecorder.start(const RecordConfig(), path: path);
  }

  Future<void> stopRecording() async {
    final isRecording = await _audioRecorder.isRecording();
    if (!isRecording) return;

    final audioPath = await _audioRecorder.stop();

    if (audioPath == null) {
      state = state.copyWith(status: RecordingStatus.normal, statusText: '録音がありません');
      return;
    }

    state = state.copyWith(status: RecordingStatus.generating, statusText: '文字起こし中...');

    final result = await _whisperController.transcribe(model: _model, audioPath: audioPath, lang: 'ja');
    logger.d('Transcription: ${result?.transcription.text}');

    state = state.copyWith(
      status: RecordingStatus.normal,
      transcribedText: result?.transcription.text ?? '',
      statusText: result?.transcription.text == null ? 'Error processing audio' : null,
    );
  }
}
