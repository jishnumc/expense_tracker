import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/app_ui/assets.dart';
import 'package:expense_tracker/src/features/transaction/domain/entities/category.dart';
import 'package:expense_tracker/src/outer_layer/validation/validation_result.dart';
import 'package:expense_tracker/src/outer_layer/validation/validators/category_validator.dart';
import 'package:expense_tracker/src/system/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
            color: colors.white,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
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
                    width: 48,
                    height: 48,
                    child: ETPrimaryButton(
                      padding: EdgeInsets.all(10),
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
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 16,
                      ),
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
                (category) => _CategoryRow(
                  category: category,
                  onDelete: () => widget.onDelete?.call(category),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category, required this.onDelete});

  final Category category;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;
    const iconDimension = 16.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category.name.toCapitalized(),
            style: textTheme.titleMedium?.copyWith(
              color: colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.expenseSecondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colors.expenseSecondary.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: SvgPicture.asset(
                AppAssets.etDelete,
                width: iconDimension,
                height: iconDimension,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
