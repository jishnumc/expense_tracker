import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ETAlertLimitEditor extends StatefulWidget {
  const ETAlertLimitEditor({
    required this.currentLimit,
    this.onSet,
    super.key,
  });

  final double currentLimit;
  final ValueChanged<double>? onSet;

  @override
  State<ETAlertLimitEditor> createState() => _ETAlertLimitEditorState();
}

class _ETAlertLimitEditorState extends State<ETAlertLimitEditor> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ALERT LIMIT (₹)',
          style: textTheme.labelMedium?.copyWith(
            color: colors.white.withValues(alpha: 0.5),
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ETTextField(
                      controller: _controller,
                      hintText: 'Amount (₹)',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 80,
                    height: 56,
                    child: ETPrimaryButton(
                      label: 'Set',
                      onPressed: () {
                        final value = double.tryParse(_controller.text);
                        if (value != null) {
                          widget.onSet?.call(value);
                          _controller.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Current Limit: ₹${widget.currentLimit.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: textTheme.bodyLarge?.copyWith(
                  color: colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
