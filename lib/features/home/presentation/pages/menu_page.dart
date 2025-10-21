import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/routes/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/widgets/safe_network_image.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../sync/presentation/bloc/sync_bloc.dart';
import '../../../sync/presentation/bloc/sync_event.dart';
import '../../../sync/presentation/bloc/sync_state.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Profile Header with Gradient
          SliverToBoxAdapter(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthAuthenticatedState) {
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Menu',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      context.push(RouteNames.settings),
                                  icon: const Icon(
                                    Icons.settings_outlined,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SafeCircleAvatar(
                              imageUrl: state.user.photoUrl,
                              fallbackText: state.user.displayName,
                              radius: 45,
                              backgroundColor: Colors.white,
                              foregroundColor: AppColors.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.user.displayName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              state.user.email,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Sync Status Card
                BlocBuilder<SyncBloc, SyncState>(
                  builder: (context, state) {
                    final pendingCount = state is SyncIdle
                        ? state.pendingCount
                        : state is SyncInProgress
                            ? state.queueCount
                            : 0;

                    final isSyncing = state is SyncInProgress;

                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: pendingCount > 0
                              ? [
                                  AppColors.warning.withOpacity(0.1),
                                  AppColors.warning.withOpacity(0.05),
                                ]
                              : [
                                  AppColors.success.withOpacity(0.1),
                                  AppColors.success.withOpacity(0.05),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: pendingCount > 0
                              ? AppColors.warning.withOpacity(0.3)
                              : AppColors.success.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: pendingCount > 0 && !isSyncing
                              ? () {
                                  context
                                      .read<SyncBloc>()
                                      .add(const TriggerSyncEvent());
                                }
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: pendingCount > 0
                                            ? AppColors.warning
                                            : AppColors.success,
                                        borderRadius: BorderRadius.circular(14),
                                        boxShadow: [
                                          BoxShadow(
                                            color: (pendingCount > 0
                                                    ? AppColors.warning
                                                    : AppColors.success)
                                                .withOpacity(0.3),
                                            blurRadius: 12,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        isSyncing
                                            ? Icons.sync_rounded
                                            : pendingCount > 0
                                                ? Icons.cloud_upload_outlined
                                                : Icons.cloud_done_rounded,
                                        color: Colors.white,
                                        size: 28,
                                      ),
                                    ),
                                    if (pendingCount > 0)
                                      Positioned(
                                        right: -6,
                                        top: -6,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 7,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.error,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.error
                                                    .withOpacity(0.4),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Text(
                                            pendingCount > 99
                                                ? '99+'
                                                : '$pendingCount',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isSyncing
                                            ? 'Syncing...'
                                            : pendingCount > 0
                                                ? 'Pending Sync'
                                                : 'All Synced',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        isSyncing
                                            ? 'Syncing data with server...'
                                            : pendingCount > 0
                                                ? '$pendingCount ${pendingCount == 1 ? 'item' : 'items'} waiting to sync'
                                                : 'All data synced with server',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (pendingCount > 0 && !isSyncing)
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: AppColors.textSecondary,
                                    size: 18,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 28),

                // Menu Section Title
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 12),
                  child: Text(
                    'Account',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                // Menu Items
                _buildMenuItem(
                  context,
                  icon: Icons.person_outline_rounded,
                  title: 'Profile',
                  subtitle: 'View and edit your profile',
                  onTap: () => context.push('/profile'),
                ),
                // const SizedBox(height: 10),
                // _buildMenuItem(
                //   context,
                //   icon: Icons.notifications_outlined,
                //   title: 'Notifications',
                //   subtitle: 'Manage notification settings',
                //   onTap: () {
                //     // TODO: Navigate to notifications settings
                //   },
                // ),

                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.only(left: 4, bottom: 12),
                  child: Text(
                    'More',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                // _buildMenuItem(
                //   context,
                //   icon: Icons.help_outline_rounded,
                //   title: 'Help & Support',
                //   subtitle: 'Get help and contact support',
                //   onTap: () {
                //     // TODO: Navigate to help
                //   },
                // ),
                const SizedBox(height: 10),
                _buildMenuItem(
                  context,
                  icon: Icons.info_outline_rounded,
                  title: 'About',
                  subtitle: 'App version and information',
                  onTap: () => _showAboutDialog(context),
                ),

                const SizedBox(height: 24),

                // Logout Button
                _buildMenuItem(
                  context,
                  icon: Icons.logout_rounded,
                  title: 'Logout',
                  subtitle: 'Sign out of your account',
                  iconColor: AppColors.error,
                  isDestructive: true,
                  onTap: () => _showLogoutDialog(context),
                ),

                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    bool isDestructive = false,
  }) {
    final color = iconColor ?? AppColors.primary;

    return Container(
      decoration: BoxDecoration(
        color: isDestructive
            ? AppColors.error.withOpacity(0.05)
            : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDestructive
              ? AppColors.error.withOpacity(0.2)
              : AppColors.divider,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: isDestructive
                              ? AppColors.error
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: AppColors.error,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Logout',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to logout? Any unsynced data will remain on your device.',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(SignOutEvent());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'TaskTrackr',
      applicationVersion: '1.0.0',
      applicationIcon: SizedBox(
        width: 80,
        height: 80,
        // decoration: BoxDecoration(
        //   gradient: AppColors.primaryGradient,
        //   borderRadius: BorderRadius.circular(16),
        // ),
        child: Image.asset(
          'assets/images/app_icon.png',
          width: 40,
          height: 40,
        ),
      ),
      children: const [
        SizedBox(height: 16),
        Text(
          'A mobile app for field agents to manage location-based tasks with offline support and real-time synchronization.',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
