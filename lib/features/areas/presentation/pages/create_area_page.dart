import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/utils/distance_calculator.dart' as dc;
import '../../../location/presentation/bloc/location_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/area_bloc.dart';
import '../../domain/entities/area.dart';

class CreateAreaPage extends StatefulWidget {
  final Area? area; // null for create, non-null for edit

  const CreateAreaPage({super.key, this.area});

  @override
  State<CreateAreaPage> createState() => _CreateAreaPageState();
}

class _CreateAreaPageState extends State<CreateAreaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _radiusController = TextEditingController();
  final _mapController = MapController();

  late LocationBloc _locationBloc;
  LatLng? _selectedPosition;
  double _currentRadius = 100.0; // Default radius in meters
  bool _isLoadingAddress = false;
  String? _selectedAddress;

  bool get _isEditMode => widget.area != null;

  @override
  void initState() {
    super.initState();
    _locationBloc = context.read<LocationBloc>();

    if (_isEditMode) {
      // Edit mode - populate with existing data
      _nameController.text = widget.area!.name;
      _descriptionController.text = widget.area!.description ?? '';
      _radiusController.text = widget.area!.radiusInMeters.toStringAsFixed(0);
      _currentRadius = widget.area!.radiusInMeters;
      _selectedPosition = LatLng(
        widget.area!.centerLatitude,
        widget.area!.centerLongitude,
      );
    } else {
      // Create mode - get current location
      _radiusController.text = _currentRadius.toStringAsFixed(0);
      _locationBloc.add(const GetCurrentLocationEvent());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Area' : 'Create Area'),
        actions: [
          if (_selectedPosition != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveArea,
              tooltip: 'Save Area',
            ),
        ],
      ),
      body: BlocListener<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is LocationLoaded && !_isEditMode) {
            setState(() {
              _selectedPosition = LatLng(
                state.location.latitude,
                state.location.longitude,
              );
            });
            _mapController.move(_selectedPosition!, 15.0);
          } else if (state is AddressLoaded) {
            setState(() {
              _selectedAddress = state.address;
              _isLoadingAddress = false;
            });
          } else if (state is LocationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocListener<AreaBloc, AreaState>(
          listener: (context, state) {
            if (state is AreaCreated || state is AreaUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isEditMode
                        ? 'Area updated successfully'
                        : 'Area created successfully',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context, true);
            } else if (state is AreaError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Column(
            children: [
              // Map section
              Expanded(
                flex: 2,
                child: _buildMap(),
              ),
              // Form section
              Expanded(
                flex: 1,
                child: _buildForm(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMap() {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _selectedPosition ?? const LatLng(23.8103, 90.4125),
            initialZoom: 15.0,
            onTap: (_, position) {
              setState(() {
                _selectedPosition = position;
                _isLoadingAddress = true;
              });
              _locationBloc.add(
                GetAddressEvent(
                  latitude: position.latitude,
                  longitude: position.longitude,
                ),
              );
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.task_trackr',
            ),
            if (_selectedPosition != null) ...[
              // Circle overlay showing the area radius
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: _selectedPosition!,
                    radius: _currentRadius,
                    useRadiusInMeter: true,
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                    borderColor: Theme.of(context).primaryColor,
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
              // Center marker
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedPosition!,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        // Current location button
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.small(
            heroTag: 'current_location',
            onPressed: () {
              _locationBloc.add(const GetCurrentLocationEvent());
            },
            child: const Icon(Icons.my_location),
          ),
        ),
        // Address display
        if (_selectedAddress != null)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedAddress!,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (_isLoadingAddress)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Loading address...',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Area Name *',
                hintText: 'e.g., Banani Zone',
                prefixIcon: Icon(Icons.label),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an area name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Additional details about this area',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _radiusController,
              decoration: InputDecoration(
                labelText: 'Radius (meters) *',
                hintText: '100',
                prefixIcon: const Icon(Icons.radio_button_unchecked),
                border: const OutlineInputBorder(),
                suffixText: 'm',
                helperText: _currentRadius > 0
                    ? 'Approx. ${dc.DistanceCalculator.formatDistance(_currentRadius)}'
                    : null,
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a radius';
                }
                final radius = double.tryParse(value);
                if (radius == null || radius <= 0) {
                  return 'Please enter a valid radius';
                }
                if (radius > 10000) {
                  return 'Radius cannot exceed 10km';
                }
                return null;
              },
              onChanged: (value) {
                final radius = double.tryParse(value);
                if (radius != null && radius > 0) {
                  setState(() {
                    _currentRadius = radius;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            if (_selectedPosition != null)
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline,
                              size: 20, color: Colors.blue[700]),
                          const SizedBox(width: 8),
                          Text(
                            'Selected Location',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Lat: ${_selectedPosition!.latitude.toStringAsFixed(6)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        'Lng: ${_selectedPosition!.longitude.toStringAsFixed(6)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveArea,
                icon: const Icon(Icons.save),
                label: Text(_isEditMode ? 'Update Area' : 'Create Area'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveArea() {
    if (_formKey.currentState!.validate() && _selectedPosition != null) {
      final authState = context.read<AuthBloc>().state;
      if (authState is! AuthAuthenticatedState) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You must be logged in to create an area'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final area = Area(
        id: _isEditMode ? widget.area!.id : const Uuid().v4(),
        name: _nameController.text.trim(),
        centerLatitude: _selectedPosition!.latitude,
        centerLongitude: _selectedPosition!.longitude,
        radiusInMeters: double.parse(_radiusController.text),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        assignedAgentIds: _isEditMode ? widget.area!.assignedAgentIds : [],
        createdById: _isEditMode ? widget.area!.createdById : authState.user.id,
        createdByName: _isEditMode
            ? widget.area!.createdByName
            : authState.user.displayName,
        createdAt: _isEditMode ? widget.area!.createdAt : DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: _isEditMode ? widget.area!.isActive : true,
      );

      if (_isEditMode) {
        context.read<AreaBloc>().add(UpdateAreaEvent(area));
      } else {
        context.read<AreaBloc>().add(CreateAreaEvent(area));
      }
    } else if (_selectedPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a location on the map'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}
