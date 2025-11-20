import 'package:flutter/material.dart';
import 'package:kowairo/gen/colors.gen.dart';

class CardFrame extends StatelessWidget {
  const CardFrame({this.child, super.key});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 10, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.borderColor),
        borderRadius: BorderRadius.circular(6),
      ),
      child: child,
    );
  }
}
