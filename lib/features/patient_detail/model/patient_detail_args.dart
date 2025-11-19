import 'package:flutter/foundation.dart';
import 'package:kowairo/domain/entities/patient.dart';

/// Tabs available on the patient detail screen.
enum PatientDetailTab { visitRecord, conference, monthlyReport }

@immutable
class PatientDetailArgs {
  const PatientDetailArgs({required this.patient, this.initialTab = PatientDetailTab.visitRecord});

  final Patient patient;
  final PatientDetailTab initialTab;
}
