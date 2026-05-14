import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ETNicknameEditor extends StatefulWidget {
  const ETNicknameEditor({
    required this.initialNickname,
    this.onSave,
    super.key,
  });

  final String initialNickname;
  final ValueChanged<String>? onSave;

  @override
  State<ETNicknameEditor> createState() => _ETNicknameEditorState();
}

class _ETNicknameEditorState extends State<ETNicknameEditor> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNickname);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NICKNAME',
          style: textTheme.labelMedium?.copyWith(
            color: colors.white.withValues(alpha: 0.5),
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _isEditing ? _buildEditMode(colors, textTheme) : _buildViewMode(colors, textTheme),
        ),
      ],
    );
  }

  Widget _buildViewMode(AppColors colors, TextTheme textTheme) {
    return Container(
      key: const ValueKey('view'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _controller.text,
            style: textTheme.headlineMedium?.copyWith(
              color: colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: _toggleEditing,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colors.white,
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditMode(AppColors colors, TextTheme textTheme) {
    return Container(
      key: const ValueKey('edit'),
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
          ETTextField(
            controller: _controller,
            hintText: 'Enter nickname',
            suffixIcon: Icon(
              Icons.check_circle_outline,
              color: colors.success,
              size: 24,
            ),
          ),
          const SizedBox(height: 20),
          ETPrimaryButton(
            label: 'Save',
            onPressed: () {
              widget.onSave?.call(_controller.text);
              _toggleEditing();
            },
          ),
        ],
      ),
    );
  }
}
