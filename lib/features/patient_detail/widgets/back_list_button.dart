import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kowairo/gen/colors.gen.dart';

class BackListButton extends StatelessWidget {
  const BackListButton({super.key, this.isDisabled = false});

  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: InkWell(
        onTap: isDisabled ? null : context.pop,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            Icon(Icons.format_list_bulleted, color: isDisabled ? AppColors.grayColor : AppColors.primaryColor),
            Text(
              '患者一覧',
              style: TextStyle(
                color: isDisabled ? AppColors.grayColor : AppColors.primaryText,
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
