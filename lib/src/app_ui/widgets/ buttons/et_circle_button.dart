import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ETCircleButton extends StatelessWidget {
  const ETCircleButton({
    required this.onPressed,
    this.icon = Icons.arrow_back,
    super.key,
  });

  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colors.white.withValues(alpha: 0.5)),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: colors.white),
      ),
    );
  }
}
