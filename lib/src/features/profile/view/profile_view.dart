import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/features/profile/widgets/et_alert_limit_editor.dart';
import 'package:expense_tracker/src/features/profile/widgets/et_category_editor.dart';
import 'package:expense_tracker/src/features/profile/widgets/et_cloud_sync_card.dart';
import 'package:expense_tracker/src/features/profile/widgets/et_nickname_editor.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Profile',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              const ETNicknameEditor(initialNickname: 'Naazley'),
              const SizedBox(height: 32),
              const ETAlertLimitEditor(currentLimit: 1000),
              const SizedBox(height: 32),
              const ETCategoryEditor(
                categories: ['Food', 'Bills', 'Transport', 'Shopping'],
              ),
              const SizedBox(height: 32),
              const ETCloudSyncCard(),
              const SizedBox(height: 32),
              ETSecondaryButton(
                label: 'Log Out',
                onPressed: () {},
                icon: Icon(
                  Icons.power_settings_new,
                  color: context.zAppColors.error,
                  size: 28,
                ),
              ),
              const SizedBox(height: 120), // Extra space for bottom nav
            ],
          ),
        ),
      ),
    );
  }
}
