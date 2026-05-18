import 'package:flutter/material.dart';
import 'package:expense_tracker/src/app_ui/app_ui.dart';

class ETPrimaryButton extends StatelessWidget {
  const ETPrimaryButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.child,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  final String label;

  final VoidCallback? onPressed;

  final Widget? icon;
  final Widget? child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;

    return SizedBox(
      width: child != null ? null : double.infinity,
      height: 48,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: padding,
        ),
        child:
            child ??
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[icon!, const SizedBox(width: 10)],
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.zAppColors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
