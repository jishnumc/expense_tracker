import 'package:expense_tracker/src/app_ui/app_ui.dart';
import 'package:expense_tracker/src/features/auth/login/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker/src/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:expense_tracker/src/features/profile/presentation/bloc/cloud_sync_bloc.dart';
import 'package:expense_tracker/src/features/profile/widgets/et_alert_limit_editor.dart';
import 'package:expense_tracker/src/features/profile/widgets/et_category_editor.dart';
import 'package:expense_tracker/src/features/profile/widgets/et_cloud_sync_card.dart';
import 'package:expense_tracker/src/features/profile/widgets/et_nickname_editor.dart';
import 'package:expense_tracker/src/features/profile/widgets/et_sync_progress_dialog.dart';
import 'package:expense_tracker/src/features/transaction/domain/entities/category.dart';
import 'package:expense_tracker/src/features/transaction/domain/repositories/transaction_repository.dart';
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

    Future<void> handleLogout() async {
      final hasUnsynced = await sl<ITransactionRepository>().hasUnsyncedData();

      if (!context.mounted) return;

      if (hasUnsynced) {
        final shouldLogout = await showDialog<bool>(
          context: context,
          builder: (context) => const ETAlertDialog(
            title: 'Unsynced Data',
            content:
                'You have data that is not synced to the cloud. This data will be lost if you log out. Are you sure you want to proceed?',
            cancelLabel: 'Cancel',
            confirmLabel: 'Log Out',
            isDestructive: true,
          ),
        );

        if (shouldLogout == true && context.mounted) {
          context.read<AuthBloc>().add(const AuthEvent.logoutRequested());
        }
      } else {
        context.read<AuthBloc>().add(const AuthEvent.logoutRequested());
      }
    }

    return BlocProvider(
      create: (context) => sl<CloudSyncBloc>(),
      child: Builder(
        builder: (context) {
          return BlocListener<CloudSyncBloc, CloudSyncState>(
            listener: (context, state) {
              if (state is CloudSyncProgress) {
                // If it is the first progress state (0.0), open the dialog
                if (state.progress == 0.0) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (dialogContext) {
                      return BlocProvider.value(
                        value: BlocProvider.of<CloudSyncBloc>(context),
                        child: BlocBuilder<CloudSyncBloc, CloudSyncState>(
                          builder: (context, dialogState) {
                            if (dialogState is CloudSyncProgress) {
                              return ETSyncProgressDialog(
                                progress: dialogState.progress,
                                statusMessage: dialogState.message,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      );
                    },
                  );
                }
              } else if (state is CloudSyncSuccess) {
                Navigator.of(context, rootNavigator: true).pop(); // Close dialog
                ETSnackBar.show(
                  context,
                  message: 'Data synced successfully!',
                  type: ETSnackBarType.success,
                );
                // Reload categories to ensure UI is completely updated
                context.read<CategoryBloc>().add(const CategoryEvent.fetched());
              } else if (state is CloudSyncNoDataToSync) {
                Navigator.of(context, rootNavigator: true).pop(); // Close dialog
                ETSnackBar.show(
                  context,
                  message: 'Nothing to sync!',
                  type: ETSnackBarType.info,
                );
              } else if (state is CloudSyncAlreadySynced) {
                Navigator.of(context, rootNavigator: true).pop(); // Close dialog
                ETSnackBar.show(
                  context,
                  message: 'Data is up to date and fully synced!',
                  type: ETSnackBarType.success,
                );
              } else if (state is CloudSyncFailure) {
                Navigator.of(context, rootNavigator: true).pop(); // Close dialog
                ETSnackBar.show(
                  context,
                  message: 'Sync failed: ${state.error}',
                  type: ETSnackBarType.error,
                );
              }
            },
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
                                context.read<CategoryBloc>().add(
                                      CategoryEvent.created(name),
                                    );
                              },
                              onDelete: (category) async {
                                final shouldDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => ETAlertDialog(
                                    title: 'Delete Category',
                                    content:
                                        'Are you sure you want to delete "${category.name}"? This action cannot be undone.',
                                    cancelLabel: 'Cancel',
                                    confirmLabel: 'Delete',
                                    isDestructive: true,
                                  ),
                                );

                                if (shouldDelete == true && context.mounted) {
                                  context.read<CategoryBloc>().add(
                                        CategoryEvent.deleted(category.id),
                                      );
                                }
                              },
                            ),
                            error: (message) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ETCategoryEditor(
                                  categories: const [],
                                  onAdd: (name) {
                                    context.read<CategoryBloc>().add(
                                          CategoryEvent.created(name),
                                        );
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    message,
                                    style: TextStyle(
                                      color: colors.error,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            orElse: () => const SizedBox.shrink(),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      ETCloudSyncCard(
                        onSync: () {
                          context.read<CloudSyncBloc>().add(const SyncTriggered());
                        },
                      ),
                      const SizedBox(height: 32),
                      BlocListener<AuthBloc, AuthState>(
                        listener: (context, state) {
                          state.maybeWhen(
                            loading: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (dialogContext) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            initial: () {
                              // Clear active category & profile states
                              context.read<ProfileBloc>().add(const ProfileEvent.fetched());
                              context.read<CategoryBloc>().add(const CategoryEvent.fetched());
                              context.go('/login');
                            },
                            orElse: () {},
                          );
                        },
                        child: ETSecondaryButton(
                          label: 'Log Out',
                          onPressed: handleLogout,
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
        },
      ),
    );
  }
}
