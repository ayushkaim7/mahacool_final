import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/constants.dart';

class ShowClientLoc extends StatefulWidget {
  const ShowClientLoc({super.key});

  @override
  State<ShowClientLoc> createState() => _ShowClientLocState();
}

class _ShowClientLocState extends State<ShowClientLoc> {
  TextEditingController clientid = TextEditingController();
  LatLng? _latestLocation;
  GoogleMapController? _mapController;

  // Method to fetch the latest location
  Future<void> getLocation(String clientID) async {
    final url = Uri.parse('${BASE_URL}api/client/latest-location?customerID=$clientID');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final latitude = data['latestLocation']['latitude'];
        final longitude = data['latestLocation']['longitude'];

        // Set the latest location and move the map
        setState(() {
          _latestLocation = LatLng(latitude, longitude);
          _mapController?.animateCamera(
            CameraUpdate.newLatLng(_latestLocation!),
          );
        });

      } else {
        print('Failed to fetch location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Get Customer Location',
          style: TextStyle(fontFamily: 'helvetica'),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
              controller: clientid,
              decoration: InputDecoration(
                hintText: 'Enter Customer Id',
                hintStyle: const TextStyle(
                  fontFamily: 'helvetica',
                  color: Colors.grey, // Hint text color
                ),
                filled: true, // Background color when not focused
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Padding inside the field
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Round corners
                  borderSide: BorderSide(
                    color: Colors.grey.shade400, // Unfocused border color
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30), // Round corners
                  borderSide: const BorderSide(
                    color: Colors.blue, // Focused border color
                    width: 2, // Focused border width
                  ),
                ),
              ),
              style: const TextStyle(fontFamily: 'helvetica'), // Input text style
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              getLocation(clientid.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              fixedSize: Size(150, 50)
            ),
            child: const Text('Search' , style: TextStyle(fontFamily: 'helvetica' , color: Colors.white),),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _latestLocation == null
                ? const Center(child: Text('No location available'))
                : GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _latestLocation ?? LatLng(28.658878, 77.220381), // Default location (GooglePlex)
                      zoom: 14.0,
                    ),
                    markers: _latestLocation != null
                        ? {
                            Marker(
                              markerId: const MarkerId("Client Location"),
                              position: _latestLocation!,
                            ),
                          }
                        : {},
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
