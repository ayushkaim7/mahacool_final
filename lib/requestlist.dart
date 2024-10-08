import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:inventory_app/constants.dart';
import 'package:inventory_app/manager_checkout_requestlist.dart';

class WarehouseRequestfromclient extends StatefulWidget {
  @override
  _WarehouseRequestfromclientState createState() => _WarehouseRequestfromclientState();
}

class _WarehouseRequestfromclientState extends State<WarehouseRequestfromclient> {
  List<dynamic> requests = [];

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  // Function to fetch requests from the API
  Future<void> fetchRequests() async {
    final String url = '${BASE_URL}api/WarehouseRequested/getall/';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          requests = json.decode(response.body);
          requests = requests.reversed.toList(); // Reversing the order of the list
        });
      } else {
        print('Failed to load requests');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Image.asset("assets/app_logo.png", fit: BoxFit.cover),
            ),
            SizedBox(width: 5),
            Text(
              'Warehouse Requests',
              style: TextStyle(fontFamily: 'helvetica', color: Colors.white),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:Stack(
              children: [
                ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    final details = request['selectedData']['details'][0];
                    print("###");
                    print(details);
              
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Warehouse Name: ${details['warehouseName'] ?? 'N/A'}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4c606b),
                                fontFamily: 'helvetica',
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Dry Fruit: ${details['dryFruitName'] ?? 'N/A'}",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'helvetica',
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Total Weight: ${details['totalweight']} kg",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'helvetica',
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "City: ${details['cityName'] ?? 'N/A'}",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'helvetica',
                              ),
                            ),
                            SizedBox(height: 20),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "Status: ${request['requestedWarehouseStatus'] ? 'Approved' : 'Pending'}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: request['requestedWarehouseStatus']
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> WarehouseCheckoutList()));
                }, child:const  Text("View checkout\nrequests"  , style: 
                TextStyle(
                  fontFamily: 'helvetica',
                  color: Colors.red,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.red,
                  decorationThickness: 2
                ),)))
                
              ]
            ),
      ),
    );
  }
}
