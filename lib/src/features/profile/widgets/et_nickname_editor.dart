import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/app_ui/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
  final ValueNotifier<bool> _isEditingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNickname);
  }

  @override
  void dispose() {
    _controller.dispose();
    _isEditingNotifier.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    _isEditingNotifier.value = !_isEditingNotifier.value;
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
            color: colors.white,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ValueListenableBuilder<bool>(
          valueListenable: _isEditingNotifier,
          builder: (context, isEditing, _) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isEditing
                  ? _NicknameEditMode(
                      controller: _controller,
                      onSavePressed: () {
                        widget.onSave?.call(_controller.text);
                        _toggleEditing();
                      },
                    )
                  : _NicknameViewMode(
                      nickname: _controller.text,
                      onEditPressed: _toggleEditing,
                    ),
            );
          },
        ),
      ],
    );
  }
}

class _NicknameViewMode extends StatelessWidget {
  const _NicknameViewMode({
    required this.nickname,
    required this.onEditPressed,
  });

  final String nickname;
  final VoidCallback onEditPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      key: const ValueKey('view'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nickname,
            style: textTheme.headlineSmall?.copyWith(
              color: colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: onEditPressed,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.white, width: 1),
              ),
              child: SvgPicture.asset(
                AppAssets.etEdit,
                colorFilter: ColorFilter.mode(colors.white, BlendMode.srcIn),
                height: 12.5,
                width: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NicknameEditMode extends StatelessWidget {
  const _NicknameEditMode({
    required this.controller,
    required this.onSavePressed,
  });

  final TextEditingController controller;
  final VoidCallback onSavePressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;

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
            controller: controller,
            hintText: 'Enter nickname',
            suffixIcon: Icon(
              Icons.check_circle_outline,
              color: colors.success,
              size: 24,
            ),
          ),
          const SizedBox(height: 20),
          ETPrimaryButton(label: 'Save', onPressed: onSavePressed),
        ],
      ),
    );
  }
}
