import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/features/auth/login/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/src/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:expense_tracker/src/features/profile/widgets/et_alert_limit_editor.dart';
import 'package:expense_tracker/src/features/profile/widgets/et_category_editor.dart';
import 'package:expense_tracker/src/features/profile/widgets/et_cloud_sync_card.dart';
import 'package:expense_tracker/src/features/profile/widgets/et_nickname_editor.dart';
import 'package:expense_tracker/src/features/transaction/domain/entities/category.dart';
import 'package:expense_tracker/src/features/transaction/presentation/bloc/category_bloc.dart';
import 'package:expense_tracker/src/system/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.zAppColors;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<CategoryBloc>()..add(const CategoryEvent.fetched()),
        ),
        BlocProvider(
          create: (context) => sl<ProfileBloc>()..add(const ProfileEvent.fetched()),
        ),
      ],
      child: Scaffold(
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
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () => const Skeletonizer(
                        enabled: true,
                        child: ETAlertLimitEditor(currentLimit: 0),
                      ),
                      success: (profile) => ETAlertLimitEditor(
                        currentLimit: profile.budgetLimit,
                        onSet: (limit) {
                          context.read<ProfileBloc>().add(
                            ProfileEvent.budgetLimitUpdated(limit),
                          );
                        },
                      ),
                      error: (message) => ETAlertLimitEditor(
                        currentLimit: 0,
                        onSet: (limit) {
                          context.read<ProfileBloc>().add(
                            ProfileEvent.budgetLimitUpdated(limit),
                          );
                        },
                      ),
                      orElse: () => const ETAlertLimitEditor(currentLimit: 0),
                    );
                  },
                ),
                const SizedBox(height: 32),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    return state.maybeWhen(
                      loading: () => Skeletonizer(
                        enabled: true,
                        child: ETCategoryEditor(
                          categories: [
                            Category(id: '1', name: 'Loading'),
                            Category(id: '2', name: 'Loading'),
                            Category(id: '3', name: 'Loading'),
                          ],
                        ),
                      ),
                      success: (categories) => ETCategoryEditor(
                        categories: categories,
                        onAdd: (name) {
                          context.read<CategoryBloc>().add(CategoryEvent.created(name));
                        },
                        onDelete: (category) {
                          context.read<CategoryBloc>().add(CategoryEvent.deleted(category.id));
                        },
                      ),
                      error: (message) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ETCategoryEditor(
                            categories: const [],
                            onAdd: (name) {
                              context.read<CategoryBloc>().add(CategoryEvent.created(name));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              message,
                              style: TextStyle(color: colors.error, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                      orElse: () => const SizedBox.shrink(),
                    );
                  },
                ),
                const SizedBox(height: 32),
                const ETCloudSyncCard(),
                const SizedBox(height: 32),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    state.maybeWhen(
                      initial: () => context.go('/login'),
                      orElse: () {},
                    );
                  },
                  child: ETSecondaryButton(
                    label: 'Log Out',
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        const AuthEvent.logoutRequested(),
                      );
                    },
                    icon: Icon(
                      Icons.power_settings_new,
                      color: context.zAppColors.error,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 120), // Extra space for bottom nav
              ],
            ),
          ),
        ),
      ),
    );
  }
}
