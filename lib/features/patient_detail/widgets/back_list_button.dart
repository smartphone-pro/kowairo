import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kowairo/features/patient_detail/provider/recording_controller.dart';
import 'package:kowairo/gen/colors.gen.dart';

class BackListButton extends ConsumerWidget {
  const BackListButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canBack = ref.watch(recordingControllerProvider) == RecordingStatus.normal;

    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: InkWell(
        onTap: canBack ? context.pop : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            Icon(Icons.format_list_bulleted, color: canBack ? AppColors.primaryColor : AppColors.grayColor),
            Text(
              '患者一覧',
              style: TextStyle(
                color: canBack ? AppColors.primaryText : AppColors.grayColor,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
