import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:inventory_app/constants.dart';

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> customerData;

  DetailPage({required this.customerData});

  // Function to handle the checkout and API call
  Future<void> checkout(BuildContext context) async {
    final String url = '${BASE_URL}api/CustomerHistory/checkout';

    // Ensure weight is an integer before passing to the request body
    //int weight = getWeightAsInt(customerData["dryFruits"][0]["weight"]); 
    int getWeightAsInt(dynamic weight) {
  if (weight is String && weight.contains('kg')) {
    // Remove 'kg' and parse the number
    return int.parse(weight.replaceAll('kg', '').trim());
  } else if (weight is int) {
    // If it's already an integer, return it
    return weight;
  }
  // Default case if weight is in an unexpected format
  return 0;
}
int weight = getWeightAsInt(customerData["dryFruits"][0]["weight"]);
String customer_datecheckin = customerData["dateCheckIN"];
// Accessing the first item in the list

    // Request Body
    Map<String, dynamic> requestBody = {
      "customerId": customerData["customerId"],
      "dryFruits": [
        {
          "name": customerData["dryFruits"][0]["name"], // Accessing the first item in the list
          "typeOfSack": customerData["dryFruits"][0]["typeOfSack"],
          "weight": customerData["dryFruits"][0]["weight"], // Weight is now an integer
          "cityName": customerData["dryFruits"][0]["cityName"],
          "warehouseName": customerData["dryFruits"][0]["warehouseName"],
          "rackName": customerData["dryFruits"][0]["rackName"],
          "recordId": customerData["dryFruits"][0]["recordId"],
          "dateCheckIN":customer_datecheckin

        }
      ]
    };

    // Sending the POST request
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(requestBody),
      );
      print(jsonEncode(requestBody));

      // Checking the response status
      if (response.statusCode == 200) {
        print('Checkout successful: ${response.body}');
        Fluttertoast.showToast(
          msg: "Checkout Successful!",
          toastLength: Toast.LENGTH_SHORT,
        );
      } else {
        print('Failed to checkout: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  // Function to convert weight to integer
  int getWeightAsInt(dynamic weight) {
    if (weight is String && weight.contains('kg')) {
      // If weight is a string with 'kg', remove 'kg' and parse to integer
      return int.parse(weight.replaceAll('kg', '').trim());
    } else if (weight is int) {
      // If weight is already an integer, return as is
      return weight;
    }
    // Default case if something unexpected comes in
    return 0;
  }

  // Error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer Data',
          style: TextStyle(fontFamily: 'helvetica', fontSize: 22),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Info
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Customer ID: ${customerData["customerId"]}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'helvetica',
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Dry Fruits Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'helvetica',
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 16),
                    // Dry fruits list
                    ..._buildDryFruitsList(customerData["dryFruits"]),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => checkout(context),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      
                    ),
                    backgroundColor: Color(0xFF4c606b),
                    textStyle:const  TextStyle(
                      fontFamily: 'helvetica',
                      fontSize: 16, 

                    ),
                  ),
                  child: const Text('Checkout' , style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDryFruitsList(List<dynamic> dryFruits) {
    return dryFruits.map((dryFruit) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFF4c606b),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${dryFruit["name"]}',
              style: TextStyle(
                fontFamily: 'helvetica',
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Type: ${dryFruit["typeOfSack"]}',
              style: TextStyle(
                fontFamily: 'helvetica',
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Weight: ${getWeightAsInt(dryFruit["weight"])} kg',
              style: TextStyle(
                fontFamily: 'helvetica',
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'City: ${dryFruit["cityName"]}',
              style: TextStyle(
                fontFamily: 'helvetica',
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Warehouse: ${dryFruit["warehouseName"]}',
              style: TextStyle(
                fontFamily: 'helvetica',
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Rack: ${dryFruit["rackName"]}',
              style: TextStyle(
                fontFamily: 'helvetica',
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'recordId: ${dryFruit["recordId"]}',
              style: TextStyle(
                fontFamily: 'helvetica',
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
