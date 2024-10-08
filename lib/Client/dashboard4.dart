import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/constants.dart';
import 'package:workmanager/workmanager.dart';

class Dashboard4 extends StatefulWidget {
  const Dashboard4({super.key, required this.name, required this.quantity  , required this.cityName , required this.warehousename , required this.customerID});

  final String name;
  final double quantity;
  final String cityName;
  final String warehousename;
  final Map<String, dynamic> customerID;

  @override
  State<Dashboard4> createState() => _Dashboard4State();
}

class _Dashboard4State extends State<Dashboard4> {
  final TextEditingController _quantityController = TextEditingController();

  Future<void> _checkoutRequest() async {
    const url = '${BASE_URL}api/warehouseCheckoutRequested/request';

    // Construct the body for the POST request
    final body = jsonEncode({
      "customerId": widget.customerID["customerID"],
      "name":widget.customerID["name"],
      "email": widget.customerID["email"],
      "mobile": widget.customerID["mobile"],
      "dryFruitName": widget.name, // Use widget name
      "cityName": widget.cityName,
      "warehouseName": widget.warehousename,
      "weight": double.tryParse(_quantityController.text) ?? widget.quantity, // Use the entered quantity or the provided one
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: body,
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Checkout request sent successfully!')),
        );
      } else {
        // If the server does not return a 200 OK response, show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send request: ${response.statusCode}')),
        );
      }
    } catch (error) {
      // Show error message in case of an exception
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color(0xFF4c606b),
        elevation: 0,
        titleSpacing: 0,
        title: const Row(
          children:  [
            SizedBox(width: 10),
            SizedBox(
              height: 80,
              width: 70,
              child: Image(
                image: AssetImage("assets/app_logo.png"),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 5),
            Text(
              'Customer',
              style: TextStyle(
                fontFamily: 'helvetica',
                color: Colors.white,
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the quantity and name of the item
              Container(
                height: 150,
                width: 150,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle, // To make the image circular
                  image: DecorationImage(
                    image: AssetImage("assets/dryfruit_logo.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              LayoutBuilder(builder: (context , Constraints){
                double fontsize = MediaQuery.of(context).size.width * 0.06;
                return Text(
                '${widget.quantity.toStringAsFixed(2)} kg',
                style:  TextStyle(
                  fontSize: fontsize,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4c606b),
                ),
              );
              }),
              const SizedBox(height: 10),
              LayoutBuilder(builder: (context, Constraints){
                return Text(
                widget.name,
                style:  TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4c606b),
                ),
              );
              }),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.grey, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.grey, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(color: Colors.blue, width: 2),
                    ),
                    hintText: 'Enter Quantity here',
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              // Checkout Button
              ElevatedButton(
                onPressed: _checkoutRequest, // Call the checkout function
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF4c606b),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child:LayoutBuilder(builder: (context, Constraints){
                  return Text(
                  'Retrieve Request',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                );
                })
              ),
            ],
          ),
        ),
      ),
    );
  }
}
