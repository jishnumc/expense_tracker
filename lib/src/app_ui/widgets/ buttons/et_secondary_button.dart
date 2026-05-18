import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ETSecondaryButton extends StatelessWidget {
  const ETSecondaryButton({
    required this.label,
    this.onPressed,
    this.icon,
    this.color,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final displayColor = color ?? colors.error;

    return SizedBox(
      width: double.infinity,
      height: 64,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: colors.white.withValues(alpha: 0.05),
          side: BorderSide(
            color: colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: displayColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (icon != null) ...[const SizedBox(width: 12), icon!],
          ],
        ),
      ),
    );
  }
}
