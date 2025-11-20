import 'package:flutter/foundation.dart';
import 'package:kowairo/domain/entities/patient.dart';

/// Tabs available on the patient detail screen.
enum PatientDetailTab { visitRecord, conference, monthlyReport }

extension PatientDetailTabLabel on PatientDetailTab {
  String get label {
    switch (this) {
      case PatientDetailTab.visitRecord:
        return '訪問記録';
      case PatientDetailTab.conference:
        return 'カンファレンス';
      case PatientDetailTab.monthlyReport:
        return '月次レポート';
    }
  }
}

@immutable
class PatientDetailArgs {
  const PatientDetailArgs({required this.patient, this.initialTab = PatientDetailTab.visitRecord});

  final Patient patient;
  final PatientDetailTab initialTab;
}
