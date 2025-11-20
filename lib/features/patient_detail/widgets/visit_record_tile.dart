import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kowairo/domain/entities/visit_record.dart';
import 'package:kowairo/features/patient_detail/provider/visit_record_tile_expanded_provider.dart';
import 'package:kowairo/gen/assets.gen.dart';
import 'package:kowairo/gen/colors.gen.dart';
import 'package:kowairo/shared/widgets/app_button.dart';
import 'package:kowairo/shared/widgets/card_frame.dart';

class VisitRecordTile extends ConsumerWidget {
  const VisitRecordTile({required this.record, super.key});

  final VisitRecord record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpanded = ref.watch(visitRecordTileExpandedProvider(record.id));

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
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              GrayButton(label: '編集', onPressed: () {}),
              BlueButton(label: 'コピー', onPressed: () {}),
            ],
          ),
        ),

        const Divider(height: 1),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Text(
            record.transcriptionText ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: ElevatedButton(
            onPressed: () {
              ref.read(visitRecordTileExpandedProvider(record.id).notifier).toggle();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.primaryColor,
              backgroundColor: AppColors.lightGrayColor,
              elevation: 0,
              padding: const EdgeInsets.fromLTRB(20, 12, 10, 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('詳細を確認する', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),

        if (isExpanded) _soapWidget(),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _soapWidget() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.lightBlueColor, borderRadius: BorderRadius.circular(6)),
      margin: const EdgeInsets.fromLTRB(30, 10, 30, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CardFrame(
            child: Row(
              spacing: 10,
              children: [
                Expanded(
                  child: const Text('S: 主観的情報（患者の訴え）', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                GrayButton(label: '編集', onPressed: () {}),
                BlueButton(label: 'コピー', onPressed: () {}),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Text(record.soapSubjective ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),

          const SizedBox(height: 20),
          CardFrame(
            child: Row(
              spacing: 10,
              children: [
                Expanded(
                  child: const Text('O: 客観的情報（検査所見）', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                GrayButton(label: '編集', onPressed: () {}),
                BlueButton(label: 'コピー', onPressed: () {}),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Text(record.soapObjective ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),

          const SizedBox(height: 20),
          CardFrame(
            child: Row(
              spacing: 10,
              children: [
                Expanded(
                  child: const Text('A/P: 評価・計画', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                GrayButton(label: '編集', onPressed: () {}),
                BlueButton(label: 'コピー', onPressed: () {}),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Text(record.soapAssessment ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),

          const SizedBox(height: 30),
          Row(
            spacing: 10,
            children: [
              BlueButton(label: 'SOAPを一括コピー', onPressed: () {}),
              WhiteButton(label: 'FAXで送る', onPressed: () {}),
              WhiteButton(label: 'メールで送る', onPressed: () {}),
              WhiteButton(label: 'MCSへ送る', onPressed: () {}),
            ],
          ),

          const SizedBox(height: 20),
          CardFrame(
            child: Row(
              spacing: 10,
              children: [
                Expanded(
                  child: const Text(
                    '暮らしメモ（生活・価値観・支援体制など）',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                GrayButton(label: '編集', onPressed: () {}),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Text(record.soapPlan ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300)),

          const SizedBox(height: 20),
          CardFrame(
            child: Row(
              spacing: 10,
              children: [
                Expanded(
                  child: const Text('SBAR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                GrayButton(label: 'オプション', onPressed: () {}),
                BlueButton(label: record.soapAssessmentPlan == null ? '生成する' : 'コピー', onPressed: () {}),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Text(
            record.soapAssessmentPlan ?? '「生成する」ボタンを押すと、ここに生成されたSBARが表示されます',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}
