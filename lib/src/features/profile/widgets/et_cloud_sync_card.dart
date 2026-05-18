import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/app_ui/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ETCloudSyncCard extends StatelessWidget {
  const ETCloudSyncCard({this.onSync, super.key});

  final VoidCallback? onSync;

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CLOUD SYNC',
          style: textTheme.labelMedium?.copyWith(
            color: colors.white,
            letterSpacing: 1.2,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: GestureDetector(
            onTap: onSync,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sync To Cloud',
                          style: textTheme.titleLarge?.copyWith(
                            color: colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sync and update data to the backend',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SvgPicture.asset(AppAssets.etCloud, width: 21, height: 18),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
