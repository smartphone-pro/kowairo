import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kowairo/domain/entities/patient.dart';
import 'package:kowairo/gen/colors.gen.dart';

class PatientTile extends StatelessWidget {
  final Patient patient;
  final VoidCallback? onVisitRecord;
  final VoidCallback? onConference;
  final VoidCallback? onMonthlyReport;

  const PatientTile({super.key, required this.patient, this.onVisitRecord, this.onConference, this.onMonthlyReport});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
          child: Row(
            children: [
              // フルネーム
              Expanded(
                child: Text(
                  patient.fullName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              // 生年月日と年齢
              if (patient.dateOfBirth != null) ...[
                Text(
                  '${DateFormat.yMMMd('ja').format(patient.dateOfBirth!)}生',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
                const SizedBox(width: 5),
              ],
              Text('${patient.age}歳', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
              const SizedBox(width: 20),
              // 訪問記録ボタン
              ElevatedButton(
                onPressed: onVisitRecord,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightGrayColor,
                  foregroundColor: AppColors.primaryColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                child: const Text('訪問記録', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 10),
              // カンファレンスボタン
              ElevatedButton(
                onPressed: onConference,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightGrayColor,
                  foregroundColor: AppColors.primaryColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                child: const Text('カンファレンス', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 10),
              // 月次レポートボタン
              ElevatedButton(
                onPressed: onMonthlyReport,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightGrayColor,
                  foregroundColor: AppColors.primaryColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                ),
                child: const Text('月次レポート', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
