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
  Set<Marker> markers = {};
  List<LatLng> locations = [];
  late LatLng selectedLocation;

  late GoogleMapController mapController;
  @override
  void initState() {
    getPermissions();
    super.initState();
    intialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map view"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              clipBehavior: Clip.hardEdge,
              margin:
                  const EdgeInsets.only(bottom: 20, left: 5, right: 5, top: 10),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: GoogleMap(
                markers: markers,
                indoorViewEnabled: false,
                mapType: MapType.hybrid,
                initialCameraPosition: CameraPosition(
                  target: selectedLocation,
                  zoom: 11.0,
                ),
                onMapCreated: _onMapCreated,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _resetMap();
        },
        child: const Icon(Icons.refresh),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

////////
  //////////////////////////////////////////////////////////////////////
//initialize
  intialize({bool isReset = false}) {
    locations =
        widget.locations.map((e) => LatLng(e.latitude, e.longitude)).toList();
    if (!isReset) {
      selectedLocation = locations[0];
    }

    for (int i = 0; i < locations.length; i++) {
      markers.add(
        Marker(
            markerId: MarkerId('marker-$i'),
            position: locations[i],
            infoWindow: InfoWindow(
              title: 'Location ${i + 1}',
              snippet:
                  'Lat: ${locations[i].latitude}, Lng: ${locations[i].longitude}',
            ),
            onTap: () {
              _onMarkerTapped(locations[i], i);
            }),
      );
    }
  }

//-------------
  void _onMarkerTapped(LatLng position, int index) {
    setState(() {
      markers = {
        Marker(
            markerId: MarkerId('marker-$index'),
            position: position,
            infoWindow: InfoWindow(
              title: 'Location ${index + 1}',
              snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
            ),
            onTap: () {
              selectedLocation = position;
              mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: position,
                    zoom: 50.0,
                  ),
                ),
              );
            }),
      };
    });
    selectedLocation = position;
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 50.0,
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////

  _resetMap() {
    setState(() {
      intialize();
    });

    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: selectedLocation,
          zoom: 0,
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////////

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  //////////////////////////////////////////////////////////////////////

  getPermissions() async {
    var status1 = await Permission.location.request();
    var status2 = await Permission.locationAlways.request();

    if (status1 == PermissionStatus.denied ||
        status2 == PermissionStatus.denied) {
      log("Permission denied");
    }
  }
}
