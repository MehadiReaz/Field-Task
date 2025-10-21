import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
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
      _isLoadingAddress = true; // Set loading state
      _locationBloc.add(GetAddressEvent(
        latitude: widget.initialLat!,
        longitude: widget.initialLng!,
      ));
    } else {
      _locationBloc.add(const GetCurrentLocationEvent());
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
      _selectedAddress = null; // Clear previous address
    });

    _locationBloc.add(GetAddressEvent(
      latitude: position.latitude,
      longitude: position.longitude,
    ));
  }

  void _getCurrentLocation() {
    _locationBloc.add(const GetCurrentLocationEvent());
  }

  void _confirmSelection() {
    if (_selectedPosition != null) {
      // If address is still loading, show a message
      if (_isLoadingAddress) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please wait while we get the address...'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }

      final result = {
        'latitude': _selectedPosition!.latitude,
        'longitude': _selectedPosition!.longitude,
        'address': _selectedAddress,
      };
      Navigator.of(context).pop(result);
    }
  }

  // 👇 New: open a dialog for searching an address
  Future<void> _openSearchDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.search, color: Colors.blue),
                  const SizedBox(width: 12),
                  const Text(
                    'Search Location',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter city, address, or place',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    Navigator.pop(context, value.trim());
                  }
                },
              ),
              const SizedBox(height: 8),
              const Text(
                'Examples: "Dhaka, Bangladesh" or "Times Square, New York"',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        Navigator.pop(context, controller.text.trim());
                      }
                    },
                    icon: const Icon(Icons.search),
                    label: const Text('Search'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (result != null && result.isNotEmpty) {
      await _searchLocation(result);
    }
  }

  // 👇 New: use geocoding to find coordinates for searched address
  Future<void> _searchLocation(String query) async {
    setState(() {
      _isLoadingAddress = true;
    });

    // Show loading indicator
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Text('Searching for "$query"...'),
            ],
          ),
          duration: const Duration(seconds: 5),
        ),
      );
    }

    try {
      final locations = await locationFromAddress(query);

      // Clear the loading snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
      }

      if (locations.isNotEmpty) {
        final location = locations.first;
        final newPosition = LatLng(location.latitude, location.longitude);

        setState(() {
          _selectedPosition = newPosition;
          _isLoadingAddress = true; // Keep loading while getting address
        });

        // Animate to the new position
        _mapController.move(newPosition, 15.0);

        // Get the formatted address for this location
        _locationBloc.add(GetAddressEvent(
          latitude: location.latitude,
          longitude: location.longitude,
        ));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text('Location found!'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        setState(() => _isLoadingAddress = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text('No results found for "$query"'),
                  ),
                ],
              ),
              backgroundColor: Colors.orange,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isLoadingAddress = false);
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                      'Error: ${e.toString().replaceAll('Exception: ', '')}'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'RETRY',
              textColor: Colors.white,
              onPressed: () => _searchLocation(query),
            ),
          ),
        );
      }
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
            // IconButton(
            //   icon: const Icon(Icons.search),
            //   tooltip: 'Search Location',
            //   onPressed: _openSearchDialog,
            // ),
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
                _isLoadingAddress = true; // Start loading address
              });
              _mapController.move(_selectedPosition!, 15.0);

              // Automatically load address for the current location
              _locationBloc.add(GetAddressEvent(
                latitude: state.location.latitude,
                longitude: state.location.longitude,
              ));
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
              setState(() {
                _isLoadingAddress = false;
              });
            }
          },
          builder: (context, state) {
            if (state is LocationLoading && _selectedPosition == null) {
              return const Center(child: CircularProgressIndicator());
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
                if (_selectedPosition != null)
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
                            : _selectedAddress != null
                                ? Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 20, color: Colors.blue),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _selectedAddress!,
                                          style: const TextStyle(fontSize: 14),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Row(
                                    children: [
                                      Icon(Icons.touch_app,
                                          size: 20, color: Colors.grey),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Tap on the map to select a location',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                    ),
                  ),

                // Instruction card when no location is selected
                if (_selectedPosition == null)
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Card(
                      elevation: 4,
                      color: Colors.blue[50],
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(Icons.touch_app, size: 32, color: Colors.blue),
                            SizedBox(height: 8),
                            Text(
                              'Tap anywhere on the map to select a location',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'or',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search,
                                    size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(
                                  'Use the search button above',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (_selectedPosition != null)
                  Positioned(
                    bottom: 100,
                    left: 16,
                    right: 16,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isLoadingAddress ? null : _confirmSelection,
                        icon: _isLoadingAddress
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Icon(Icons.check_circle),
                        label: Text(_isLoadingAddress
                            ? 'Loading Address...'
                            : 'Confirm Location'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                        ),
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
