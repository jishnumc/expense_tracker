import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ETCategoryEditor extends StatefulWidget {
  const ETCategoryEditor({
    required this.categories,
    this.onAdd,
    this.onDelete,
    super.key,
  });

  final List<String> categories;
  final ValueChanged<String>? onAdd;
  final ValueChanged<String>? onDelete;

  @override
  State<ETCategoryEditor> createState() => _ETCategoryEditorState();
}

class _ETCategoryEditorState extends State<ETCategoryEditor> {
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
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 60,
                    height: 56,
                    child: ETPrimaryButton(
                      label: '',
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          widget.onAdd?.call(_controller.text);
                          _controller.clear();
                        }
                      },
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(color: Colors.white10),
              const SizedBox(height: 12),
              ...widget.categories.map((category) => _buildCategoryRow(category, colors, textTheme)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryRow(String category, AppColors colors, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category,
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
              child: Icon(
                Icons.delete_outline,
                color: colors.error,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
