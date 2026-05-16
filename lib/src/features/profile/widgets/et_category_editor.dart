import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/features/transaction/domain/entities/category.dart';
import 'package:expense_tracker/src/outer_layer/validation/validation_result.dart';
import 'package:expense_tracker/src/outer_layer/validation/validators/category_validator.dart';
import 'package:flutter/material.dart';

class ETCategoryEditor extends StatefulWidget {
  const ETCategoryEditor({
    required this.categories,
    this.onAdd,
    this.onDelete,
    super.key,
  });

  final List<Category> categories;
  final ValueChanged<String>? onAdd;
  final ValueChanged<Category>? onDelete;

  @override
  State<ETCategoryEditor> createState() => _ETCategoryEditorState();
}

class _ETCategoryEditorState extends State<ETCategoryEditor> {
  late TextEditingController _controller;
  final ValueNotifier<String?> _errorNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _errorNotifier.dispose();
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
          'CATEGORIES',
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
            children: [
              Row(
                children: [
                  Expanded(
                    child: ETTextField(
                      controller: _controller,
                      hintText: 'New category Name',
                      onChanged: (value) {
                        if (_errorNotifier.value != null) {
                          _errorNotifier.value = null;
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 60,
                    height: 56,
                    child: ETPrimaryButton(
                      label: '',
                      onPressed: () {
                        final validator = CategoryValidator(
                          widget.categories.map((c) => c.name).toList(),
                        );
                        final result = validator.validate(_controller.text);

                        if (result is ValidationFailure) {
                          _errorNotifier.value = result.error.message;
                          return;
                        }

                        widget.onAdd?.call(_controller.text.trim());
                        _controller.clear();
                        _errorNotifier.value = null;
                      },
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
              ValueListenableBuilder<String?>(
                valueListenable: _errorNotifier,
                builder: (context, errorText, _) {
                  if (errorText == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      errorText,
                      style: textTheme.labelSmall?.copyWith(
                        color: colors.error,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              const Divider(color: Colors.white10),
              const SizedBox(height: 12),
              ...widget.categories.map(
                (category) => _buildCategoryRow(category, colors, textTheme),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryRow(
    Category category,
    AppColors colors,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category.name,
            style: textTheme.titleMedium?.copyWith(
              color: colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () => widget.onDelete?.call(category),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colors.error.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Icon(Icons.delete_outline, color: colors.error, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
