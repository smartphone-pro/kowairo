enum RecordingStatus {
  normal, // 何もしていない
  recording, // 録音中
  generating, // 生成中
}

class RecordingState {
  const RecordingState({this.status = RecordingStatus.normal, this.transcribedText = '', this.statusText});

  final RecordingStatus status;
  final String transcribedText;
  final String? statusText;

  RecordingState copyWith({RecordingStatus? status, String? transcribedText, String? statusText}) {
    return RecordingState(
      status: status ?? this.status,
      transcribedText: transcribedText ?? this.transcribedText,
      statusText: statusText,
    );
  }
}
