import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_app/constants.dart';

class Finalcheckout extends StatefulWidget {
  final String wid;
  final String wname;
  final String cityname;
  const Finalcheckout({super.key , required this.wid , required this.wname , required this.cityname});

  @override
  State<Finalcheckout> createState() => _FinalcheckoutState();
}

class _FinalcheckoutState extends State<Finalcheckout> {
  final _fruitNameController = TextEditingController();
  final _capacityController = TextEditingController();

  @override
  void dispose() {
    _fruitNameController.dispose();
    _capacityController.dispose();
    super.dispose();
  }


  Future<void> sendWarehouseRequest() async {
    // API URL
    final String url = '${BASE_URL}api/WarehouseRequested/warehouse-request/';

    // The body of the request
    Map<String, dynamic> requestBody = {
      "selectedData": {
        "details": [
          {
            "warehouseId": widget.wid, // Mapping warehouseId from widget
            "totalweight": int.parse(_capacityController.text), // Mapping weight from TextField
            "dryFruitName": _fruitNameController.text, // Mapping dryFruitName from TextField
            "warehouseName":widget.wname,
            "cityName":widget.cityname
          }
        ]
      }
    };

    // Headers for the request
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      // Send POST request
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        // Request was successful
        print('Request successful!');
        print('Response: ${response.body}');
        Fluttertoast.showToast(
          msg: "Request successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        // Request failed
        print('Request failed with status: ${response.statusCode}.');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Ensure UI adjusts when the keyboard is shown
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color(0xFF4c606b),
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            SizedBox(width: 10),
            Container(
              height: 80,
              width: 70,
              child: Image(
                image: AssetImage("assets/app_logo.png"),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 5),
            Text('Customer', style: TextStyle(fontFamily: 'helvetica', color: Colors.white)),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      Text(
                        'Request Details',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4c606b),
                          fontFamily: 'helvetica',
                        ),
                      ),
                      SizedBox(height: 20),
                      
                      // Fruit Name TextFormField
                      TextFormField(
                        controller: _fruitNameController,
                        decoration: InputDecoration(
                          labelText: 'Fruit Name',
                          labelStyle: TextStyle(fontFamily: 'helvetica'),
                          hintText: 'Enter the fruit name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15), // Rounded border
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        style: TextStyle(fontSize: 16, fontFamily: 'helvetica'),
                      ),
                      SizedBox(height: 20),
                      
                      // Capacity TextFormField
                      TextFormField(
                        controller: _capacityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Capacity (kg)',
                          labelStyle: TextStyle(fontFamily: 'helvetica'),
                          hintText: 'Enter the capacity',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15), // Rounded border
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        style: TextStyle(fontSize: 16, fontFamily: 'helvetica'),
                      ),
                      SizedBox(height: 30),
                      
                      // Request Button
                      Spacer(), // Pushes button to the bottom
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            sendWarehouseRequest();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Color(0xFF4c606b),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            'Request',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20), // Adds padding at the bottom
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
