import 'package:flutter/material.dart';

class MapSelectionPage extends StatelessWidget {
  final double? initialLat;
  final double? initialLng;

  const MapSelectionPage({
    super.key,
    this.initialLat,
    this.initialLng,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: const Center(
        child: Text('Map Selection - Coming Soon'),
      ),
    );
  }
}
