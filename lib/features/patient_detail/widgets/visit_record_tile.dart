import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kowairo/domain/entities/visit_record.dart';
import 'package:kowairo/gen/assets.gen.dart';
import 'package:kowairo/gen/colors.gen.dart';

class VisitRecordTile extends StatelessWidget {
  const VisitRecordTile({required this.record, super.key});

  final VisitRecord record;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
          child: Row(
            spacing: 10,
            children: [
              Assets.icons.icFile.svg(),
              Expanded(
                child: Text(
                  DateFormat.yMMMEd('ja').format(record.visitDate),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  backgroundColor: AppColors.lightGrayColor,
                  elevation: 0,
                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                child: Text('編集'),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColors.primaryColor,
                  elevation: 0,
                  textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                child: Text('コピー'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Text(record.transcriptionText ?? '', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
              backgroundColor: AppColors.lightGrayColor,
              elevation: 0,
              padding: EdgeInsets.fromLTRB(20, 12, 10, 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('詳細を確認する', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Icon(Icons.expand_more),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
