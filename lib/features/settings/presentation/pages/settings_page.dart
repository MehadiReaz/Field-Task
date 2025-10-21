import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../notifier/theme_notifier.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       Theme.of(context).colorScheme.background,
        //       Theme.of(context).colorScheme.primary.withOpacity(0.05),
        //     ],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        // ),
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) => ListView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            children: [
              const SizedBox(height: 30),
              // Theme Section
              _buildSectionHeader(
                context,
                icon: Icons.palette_outlined,
                title: 'Appearance',
                subtitle: 'Customize how the app looks',
              ),
              const SizedBox(height: 14),
              Card(
                elevation: 0,
                shadowColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      _buildThemeOption(
                        context: context,
                        icon: Icons.brightness_auto,
                        title: 'System',
                        subtitle: 'Follow device theme',
                        value: ThemeMode.system,
                        groupValue: state.mode,
                        onChanged: (value) {
                          if (value != null) {
                            context
                                .read<ThemeBloc>()
                                .add(SetThemeModeEvent(value));
                          }
                        },
                      ),
                      const Divider(height: 1, indent: 72),
                      _buildThemeOption(
                        context: context,
                        icon: Icons.light_mode,
                        title: 'Light',
                        subtitle: 'Always use light theme',
                        value: ThemeMode.light,
                        groupValue: state.mode,
                        onChanged: (value) {
                          if (value != null) {
                            context
                                .read<ThemeBloc>()
                                .add(SetThemeModeEvent(value));
                          }
                        },
                      ),
                      const Divider(height: 1, indent: 72),
                      _buildThemeOption(
                        context: context,
                        icon: Icons.dark_mode,
                        title: 'Dark',
                        subtitle: 'Always use dark theme',
                        value: ThemeMode.dark,
                        groupValue: state.mode,
                        onChanged: (value) {
                          if (value != null) {
                            context
                                .read<ThemeBloc>()
                                .add(SetThemeModeEvent(value));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // App Info Section
              _buildSectionHeader(
                context,
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'App information and version',
              ),
              const SizedBox(height: 14),
              Card(
                elevation: 0,
                shadowColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  splashColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  onTap: () => _showAboutDialog(context),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.13),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.task_alt,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Task Trackr',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Version 1.0.0',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        // Container(
        //   padding: const EdgeInsets.all(8),
        //   decoration: BoxDecoration(
        //     color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        //   child: Icon(
        //     icon,
        //     color: Theme.of(context).colorScheme.primary,
        //     size: 20,
        //   ),
        // ),
        // const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                  letterSpacing: 0.2,
                ),
              ),
              // Text(
              //   subtitle,
              //   style: TextStyle(
              //     fontSize: 14,
              //     color:
              //         Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required ThemeMode value,
    required ThemeMode groupValue,
    required ValueChanged<ThemeMode?> onChanged,
  }) {
    final isSelected = value == groupValue;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
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
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Task Trackr',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.task_alt,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 32,
        ),
      ),
      children: [
        const SizedBox(height: 16),
        Text(
          'A mobile app for field agents to manage location-based tasks with offline support.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
