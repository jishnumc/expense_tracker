import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';

class ETCountryCodePicker extends StatelessWidget {
  const ETCountryCodePicker({
    required this.selectedCountryCode,
    required this.onChanged,
    super.key,
  });

  final String selectedCountryCode;
  final ValueChanged<String> onChanged;

  Future<void> _showPicker(BuildContext context) async {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;

    final countryPicker = FlCountryCodePicker(
      showDialCode: true,
      showSearchBar: true,
      title: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        child: Text(
          'Select Country Code',
          style: textTheme.titleMedium?.copyWith(
            color: colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      countryTextStyle: textTheme.bodyLarge?.copyWith(color: colors.white),
      dialCodeTextStyle: textTheme.bodyLarge?.copyWith(
        color: colors.white.withValues(alpha: 0.6),
      ),
      searchBarTextStyle: textTheme.bodyLarge?.copyWith(color: colors.white),
      searchBarDecoration: InputDecoration(
        hintText: 'Search country...',
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colors.white.withValues(alpha: 0.4),
        ),
        prefixIcon: Icon(
          Icons.search,
          color: colors.white.withValues(alpha: 0.4),
        ),
        filled: true,
        fillColor: colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary.withValues(alpha: 0.5)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );

    final code = await countryPicker.showPicker(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    );

    if (code != null) {
      onChanged(code.dialCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPicker(context),
      behavior: HitTestBehavior.opaque,
      child: Text(
        selectedCountryCode,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: context.zAppColors.white,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
