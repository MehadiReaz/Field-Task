import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../areas/domain/entities/area.dart';
import '../../../areas/presentation/bloc/area_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/domain/usecases/update_user_area.dart';
import '../../../../injection_container.dart';

/// A dialog that allows users to select an area to work in
/// Shows after login if user hasn't selected an area yet
class AreaSelectionDialog extends StatefulWidget {
  final bool isRequired; // If true, user cannot dismiss without selecting

  const AreaSelectionDialog({
    super.key,
    this.isRequired = true,
  });

  @override
  State<AreaSelectionDialog> createState() => _AreaSelectionDialogState();
}

class _AreaSelectionDialogState extends State<AreaSelectionDialog> {
  Area? _selectedArea;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    // Load areas when dialog opens
    context.read<AreaBloc>().add(const LoadAreasEvent());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !widget.isRequired,
      child: AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.location_city, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              widget.isRequired ? 'Select Your Area' : 'Change Area',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: BlocBuilder<AreaBloc, AreaState>(
            builder: (context, state) {
              if (state is AreaLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state is AreaError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          context.read<AreaBloc>().add(const LoadAreasEvent());
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              if (state is AreasLoaded) {
                if (state.areas.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_off,
                            size: 48, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text(
                          'No areas available',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.isRequired
                              ? 'Please contact your administrator to create areas.'
                              : 'Create an area to continue.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.isRequired) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline,
                                color: Colors.blue, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Please select an area to start working',
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.areas.length,
                        itemBuilder: (context, index) {
                          final area = state.areas[index];
                          final isSelected = _selectedArea?.id == area.id;

                          return Card(
                            elevation: isSelected ? 4 : 1,
                            color: isSelected ? Colors.blue.shade50 : null,
                            child: ListTile(
                              leading: Icon(
                                Icons.location_on,
                                color: isSelected ? Colors.blue : Colors.grey,
                              ),
                              title: Text(
                                area.name,
                                style: TextStyle(
                                  fontWeight:
                                      isSelected ? FontWeight.bold : null,
                                ),
                              ),
                              subtitle: Text(
                                area.description ??
                                    'Radius: ${area.radiusInMeters.toStringAsFixed(0)}m',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: isSelected
                                  ? Icon(Icons.check_circle, color: Colors.blue)
                                  : null,
                              selected: isSelected,
                              onTap: () {
                                setState(() {
                                  _selectedArea = area;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
        actions: [
          if (!widget.isRequired)
            TextButton(
              onPressed: _isUpdating ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ElevatedButton.icon(
            onPressed:
                _selectedArea == null || _isUpdating ? null : _confirmSelection,
            icon: _isUpdating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.check),
            label: Text(_isUpdating ? 'Updating...' : 'Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmSelection() async {
    if (_selectedArea == null) return;

    setState(() {
      _isUpdating = true;
    });

    try {
      final authState = context.read<AuthBloc>().state;
      if (authState is! AuthAuthenticatedState) {
        throw Exception('User not authenticated');
      }

      // Update user's selected area
      final updateUserArea = getIt<UpdateUserArea>();
      final result = await updateUserArea(
        UpdateUserAreaParams(
          userId: authState.user.id,
          areaId: _selectedArea!.id,
        ),
      );

      if (!mounted) return;

      result.fold(
        (failure) {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            _isUpdating = false;
          });
        },
        (updatedUser) {
          // Update the auth state with new user info
          context.read<AuthBloc>().add(GetCurrentUserEvent());

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Area set to ${_selectedArea!.name}'),
              backgroundColor: Colors.green,
            ),
          );

          // Close dialog and return true to indicate success
          Navigator.pop(context, true);
        },
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );

      setState(() {
        _isUpdating = false;
      });
    }
  }
}
