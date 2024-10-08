import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Use only this for Google Maps Flutter

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static final LatLng _pGooglePlex = LatLng(28.658878, 77.220381);
  static final LatLng _storeadd = LatLng(28.658878, 77.220381);

  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(28.658878, 77.220381), // Starting location (GooglePlex)
    zoom: 14.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _pGooglePlex,
          zoom: 15 
          
          ),

          markers: {
            Marker(markerId: MarkerId("Store Location"),
            icon: BitmapDescriptor.defaultMarker,
            position:  _storeadd
            )
          },
       
      ),
    );
  }
}
