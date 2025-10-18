import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../injection_container.dart';
import '../bloc/location_bloc.dart';

class MapSelectionPage extends StatefulWidget {
  final double? initialLat;
  final double? initialLng;

  const MapSelectionPage({
    super.key,
    this.initialLat,
    this.initialLng,
  });

  @override
  State<MapSelectionPage> createState() => _MapSelectionPageState();
}

class _MapSelectionPageState extends State<MapSelectionPage> {
  late final LocationBloc _locationBloc;
  late final MapController _mapController;
  LatLng? _selectedPosition;
  String? _selectedAddress;
  bool _isLoadingAddress = false;

  @override
  void initState() {
    super.initState();
    _locationBloc = getIt<LocationBloc>();
    _mapController = MapController();

    // Initialize with provided coordinates or get current location
    if (widget.initialLat != null && widget.initialLng != null) {
      _selectedPosition = LatLng(widget.initialLat!, widget.initialLng!);
      _locationBloc.add(GetAddressEvent(
        latitude: widget.initialLat!,
        longitude: widget.initialLng!,
      ));
    } else {
      _locationBloc.add(GetCurrentLocationEvent());
    }
  }

  @override
  void dispose() {
    _locationBloc.close();
    _mapController.dispose();
    super.dispose();
  }

  void _onMapTap(TapPosition tapPosition, LatLng position) {
    setState(() {
      _selectedPosition = position;
      _isLoadingAddress = true;
    });

    _locationBloc.add(GetAddressEvent(
      latitude: position.latitude,
      longitude: position.longitude,
    ));
  }

  void _getCurrentLocation() {
    _locationBloc.add(GetCurrentLocationEvent());
  }

  void _confirmSelection() {
    if (_selectedPosition != null) {
      final result = {
        'latitude': _selectedPosition!.latitude,
        'longitude': _selectedPosition!.longitude,
        'address': _selectedAddress,
      };
      Navigator.of(context).pop(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _locationBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Select Location'),
          actions: [
            if (_selectedPosition != null)
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: _confirmSelection,
                tooltip: 'Confirm Location',
              ),
          ],
        ),
        body: BlocConsumer<LocationBloc, LocationState>(
          listener: (context, state) {
            if (state is LocationLoaded) {
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
          builder: (context, state) {
            if (state is LocationLoading && _selectedPosition == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _selectedPosition ?? const LatLng(0, 0),
                    initialZoom: 15.0,
                    onTap: _onMapTap,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.task_trackr',
                    ),
                    if (_selectedPosition != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _selectedPosition!,
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.location_pin,
                              color: Colors.red,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                // Address display card
                if (_selectedAddress != null || _isLoadingAddress)
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: _isLoadingAddress
                            ? const Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Loading address...'),
                                ],
                              )
                            : Row(
                                children: [
                                  const Icon(Icons.location_on, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _selectedAddress!,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                // Confirm button
                if (_selectedPosition != null)
                  Positioned(
                    bottom: 80,
                    left: 16,
                    right: 16,
                    child: ElevatedButton.icon(
                      onPressed: _confirmSelection,
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Confirm Location'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _getCurrentLocation,
          tooltip: 'My Location',
          child: const Icon(Icons.my_location),
        ),
      ),
    );
  }
}
