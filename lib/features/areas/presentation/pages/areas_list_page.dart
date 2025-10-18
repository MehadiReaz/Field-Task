import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/area_bloc.dart';
import '../../domain/entities/area.dart';
import '../../../../core/utils/distance_calculator.dart';
import 'create_area_page.dart';
import '../../../../injection_container.dart';
import '../../../location/presentation/bloc/location_bloc.dart';

class AreasListPage extends StatefulWidget {
  const AreasListPage({super.key});

  @override
  State<AreasListPage> createState() => _AreasListPageState();
}

class _AreasListPageState extends State<AreasListPage> {
  @override
  void initState() {
    super.initState();
    // Use post-frame callback to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AreaBloc>().add(const LoadAreasEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Area Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AreaBloc>().add(const LoadAreasEvent());
            },
          ),
        ],
      ),
      body: BlocConsumer<AreaBloc, AreaState>(
        listener: (context, state) {
          if (state is AreaError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AreaDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Area deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
            // Reload areas
            context.read<AreaBloc>().add(const LoadAreasEvent());
          }
        },
        builder: (context, state) {
          if (state is AreaLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AreasLoaded) {
            if (state.areas.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_off,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No areas found',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Tap the + button to create a new area'),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.areas.length,
              itemBuilder: (context, index) {
                final area = state.areas[index];
                return _AreaCard(
                  area: area,
                  onTap: () => _navigateToEditArea(context, area),
                  onDelete: () => _showDeleteConfirmation(context, area),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreateArea(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Area'),
      ),
    );
  }

  void _navigateToCreateArea(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => getIt<LocationBloc>(),
            ),
            BlocProvider(
              create: (_) => getIt<AreaBloc>(),
            ),
          ],
          child: const CreateAreaPage(),
        ),
      ),
    );

    if (result == true) {
      if (mounted) {
        context.read<AreaBloc>().add(const LoadAreasEvent());
      }
    }
  }

  void _navigateToEditArea(BuildContext context, Area area) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => getIt<LocationBloc>(),
            ),
            BlocProvider(
              create: (_) => getIt<AreaBloc>(),
            ),
          ],
          child: CreateAreaPage(area: area),
        ),
      ),
    );

    if (result == true) {
      if (mounted) {
        context.read<AreaBloc>().add(const LoadAreasEvent());
      }
    }
  }

  void _showDeleteConfirmation(BuildContext context, Area area) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Area'),
        content: Text('Are you sure you want to delete "${area.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AreaBloc>().add(DeleteAreaEvent(area.id));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _AreaCard extends StatelessWidget {
  final Area area;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _AreaCard({
    required this.area,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      area.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: onDelete,
                    tooltip: 'Delete Area',
                  ),
                ],
              ),
              if (area.description != null && area.description!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  area.description!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.location_on,
                label: 'Center',
                value:
                    '${area.centerLatitude.toStringAsFixed(6)}, ${area.centerLongitude.toStringAsFixed(6)}',
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.radio_button_unchecked,
                label: 'Radius',
                value: DistanceCalculator.formatDistance(area.radiusInMeters),
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.people,
                label: 'Assigned Agents',
                value: area.assignedAgentIds.isEmpty
                    ? 'None'
                    : '${area.assignedAgentIds.length} agent(s)',
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.person,
                label: 'Created by',
                value: area.createdByName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
