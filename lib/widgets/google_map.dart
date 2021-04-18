import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapSample extends StatefulWidget {
  @override
  _GoogleMapSampleState createState() => _GoogleMapSampleState();
}

class _GoogleMapSampleState extends State<GoogleMapSample> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  @override
  Widget build(BuildContext context) {
    final CameraPosition _initPosition = CameraPosition(
        target: LatLng(37.42796133580664, -122.085749655962), zoom: 14.5);
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Google Map"),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _initPosition,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          setState(() {
            _markers.add(Marker(
              markerId: MarkerId('marker_1'),
              position: LatLng(37.42796133580664, -122.085749655962),
            ));
          });
        },
        minMaxZoomPreference: MinMaxZoomPreference(16, 18),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
