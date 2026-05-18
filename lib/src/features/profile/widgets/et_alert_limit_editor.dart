import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/outer_layer/validation/validation_result.dart';
import 'package:expense_tracker/src/outer_layer/validation/validators/amount_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ETAlertLimitEditor extends StatefulWidget {
  const ETAlertLimitEditor({required this.currentLimit, this.onSet, super.key});

  final double currentLimit;
  final ValueChanged<double>? onSet;

  @override
  State<ETAlertLimitEditor> createState() => _ETAlertLimitEditorState();
}

class _ETAlertLimitEditorState extends State<ETAlertLimitEditor> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

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
        Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            decoration: BoxDecoration(
              color: colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.white.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ALERT LIMIT (₹)',
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.white,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ETTextField(
                        controller: _controller,
                        hintText: 'Amount (₹)',
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) return null;
                          final result = const AmountValidator().validate(
                            value,
                          );
                          if (result is ValidationFailure) {
                            return result.error.message;
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 64,
                      height: 48,
                      child: ETPrimaryButton(
                        label: 'Set',
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            final value = double.tryParse(_controller.text);
                            if (value != null) {
                              widget.onSet?.call(value);
                              _controller.clear();
                              FocusScope.of(context).unfocus();
                            }
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
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
