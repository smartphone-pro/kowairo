import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kowairo/features/patient_detail/model/patient_detail_args.dart';
import 'package:kowairo/features/patient_detail/provider/tab_index_provider.dart';
import 'package:kowairo/gen/colors.gen.dart';

class TopTabBar extends ConsumerWidget {
  const TopTabBar({super.key});

  static final _tabs = [
    PatientDetailTab.visitRecord.label,
    PatientDetailTab.conference.label,
    PatientDetailTab.monthlyReport.label,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(tapIndexProvider);
    debugPrint('index: $index');
    return Row(
      spacing: 20,
      children: List.generate(_tabs.length, (i) {
        final selected = i == index;

        return Expanded(
          flex: i == 0 ? 2 : 1,
          child: GestureDetector(
            onTap: () => ref.read(tapIndexProvider.notifier).setTab(i),
            child: AnimatedContainer(
              padding: const EdgeInsets.symmetric(vertical: 9),
              duration: const Duration(milliseconds: 180),
              decoration: BoxDecoration(
                color: selected ? Colors.white : AppColors.blueColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
              ),
              alignment: Alignment.center,
              child: Text(
                _tabs[i],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primaryColor),
              ),
            ),
          ),
        );
      }),
    );
  }
}
