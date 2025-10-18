import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../injection_container.dart';
import '../../../areas/presentation/bloc/area_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/area_selection_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmation(context);
            },
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticatedState) {
            // Navigate to login page after logout
            context.go(RouteNames.login);
          } else if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticatedState) {
              final user = state.user;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: user.photoUrl != null
                                ? NetworkImage(user.photoUrl!)
                                : null,
                            child: user.photoUrl == null
                                ? const Icon(Icons.person, size: 50)
                                : null,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user.displayName,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            user.email,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Chip(
                            label: Text(user.role.displayName),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Account Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: Text(user.email),
                    ),
                    ListTile(
                      leading: const Icon(Icons.badge),
                      title: const Text('User ID'),
                      subtitle: Text(user.id),
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: const Text('Member Since'),
                      subtitle: Text(
                        '${user.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}',
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Work Area',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.location_city),
                      title: const Text('Selected Area'),
                      subtitle: Text(
                        user.selectedAreaName != null
                            ? user.selectedAreaName!
                            : 'No area selected',
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: ElevatedButton.icon(
                          onPressed: () => _showChangeAreaDialog(context),
                          icon: const Icon(Icons.edit, size: 16),
                          label: const Text('Change',
                              style: TextStyle(fontSize: 12)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  void _showChangeAreaDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider(
        create: (context) => getIt<AreaBloc>(),
        child: const AreaSelectionDialog(isRequired: false),
      ),
    );
  }
}

// Helper function to show logout confirmation
void _showLogoutConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(dialogContext);
            context.read<AuthBloc>().add(SignOutEvent());
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Logout'),
        ),
      ],
    ),
  );
}
