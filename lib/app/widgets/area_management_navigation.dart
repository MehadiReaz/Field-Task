import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/areas/presentation/bloc/area_bloc.dart';
import '../../features/areas/presentation/pages/areas_list_page.dart';
import '../../injection_container.dart';

/// Example widget showing how to add Area Management to your app
///
/// Usage:
/// 1. Add this file to your lib/app/widgets/ directory
/// 2. Use AreaManagementButton in your navigation drawer or app bar
/// 3. Or use navigateToAreasPage() function anywhere in your app

class AreaManagementButton extends StatelessWidget {
  const AreaManagementButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => navigateToAreasPage(context),
      icon: const Icon(Icons.location_city),
      label: const Text('Manage Areas'),
    );
  }
}

/// Navigation function to go to Areas List Page
void navigateToAreasPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => getIt<AreaBloc>(),
        child: const AreasListPage(),
      ),
    ),
  );
}

/// Example: Drawer menu item for Area Management
class AreaManagementDrawerItem extends StatelessWidget {
  const AreaManagementDrawerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.location_city),
      title: const Text('Area Management'),
      subtitle: const Text('Define zones and regions'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.pop(context); // Close drawer
        navigateToAreasPage(context);
      },
    );
  }
}

/// Example: Dashboard card for quick access
class AreaManagementCard extends StatelessWidget {
  const AreaManagementCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () => navigateToAreasPage(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.location_city,
                size: 48,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 12),
              Text(
                'Area Management',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'Create and manage zones',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 12),
              BlocProvider(
                create: (context) =>
                    getIt<AreaBloc>()..add(const LoadAreasEvent()),
                child: BlocBuilder<AreaBloc, AreaState>(
                  builder: (context, state) {
                    if (state is AreasLoaded) {
                      return Chip(
                        label: Text('${state.areas.length} Active Areas'),
                        backgroundColor: Colors.green[100],
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Example: Bottom navigation bar item
class AreaManagementBottomNavItem {
  static BottomNavigationBarItem get item => const BottomNavigationBarItem(
        icon: Icon(Icons.location_city),
        label: 'Areas',
        tooltip: 'Manage Areas',
      );

  static Widget get page => BlocProvider(
        create: (context) => getIt<AreaBloc>(),
        child: const AreasListPage(),
      );
}
