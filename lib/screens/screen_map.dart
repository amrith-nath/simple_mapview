import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logicart/data/models/location_model.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenMap extends StatefulWidget {
  const ScreenMap({
    super.key,
    required this.locations,
  });
  final List<LocationModel> locations;
  @override
  State<ScreenMap> createState() => _ScreenMapState();
}

class _ScreenMapState extends State<ScreenMap> {
  @override
  void initState() {
    getPermissions();
    super.initState();
  }

  late GoogleMapController mapController;

  final LatLng _center =
      const LatLng(37.7749, -122.4194); // Coordinates for San Francisco

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map view"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: GoogleMap(
          indoorViewEnabled: false,
          mapType: MapType.hybrid,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
        ),
      ),
    );
  }

  getPermissions() async {
    var status1 = await Permission.location.request();
    var status2 = await Permission.locationAlways.request();

    if (status1 == PermissionStatus.denied ||
        status2 == PermissionStatus.denied) {
      log("Permission denied");
    }
  }
}
