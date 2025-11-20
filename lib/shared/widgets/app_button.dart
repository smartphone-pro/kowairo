import 'package:flutter/material.dart';
import 'package:kowairo/gen/colors.gen.dart';

/// Base button used to construct GrayButton and BlueButton for consistent styling.
class _BaseAppButton extends StatelessWidget {
  const _BaseAppButton({
    required this.onPressed,
    this.foregroundColor,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    required this.child,
  });

  final VoidCallback? onPressed;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        elevation: 0,
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        padding: padding,
      ),
      child: child,
    );
  }
}

class GrayButton extends StatelessWidget {
  const GrayButton({required this.label, this.onPressed, this.padding, super.key});

  final String label;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return _BaseAppButton(
      onPressed: onPressed,
      foregroundColor: AppColors.primaryColor,
      backgroundColor: AppColors.lightGrayColor,
      padding: padding,
      child: Text(label),
    );
  }
}

class WhiteButton extends StatelessWidget {
  const WhiteButton({required this.label, this.onPressed, this.padding, super.key});

  final String label;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return _BaseAppButton(
      onPressed: onPressed,
      foregroundColor: AppColors.primaryColor,
      backgroundColor: Colors.white,
      padding: padding,
      child: Text(label),
    );
  }
}

class BlueButton extends StatelessWidget {
  const BlueButton({required this.label, this.onPressed, this.padding, super.key});

  final String label;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return _BaseAppButton(
      onPressed: onPressed,
      foregroundColor: Colors.white,
      backgroundColor: AppColors.primaryColor,
      padding: padding,
      child: Text(label),
    );
  }
}
