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

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(2.6799, -54.199),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map view"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
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
