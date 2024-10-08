import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:inventory_app/constants.dart';
import 'package:inventory_app/map_pages.dart';

class CheckoutFormPage extends StatefulWidget {
  final Map<String, dynamic> client_Details;

  const CheckoutFormPage({super.key, required this.client_Details});
  @override
  _CheckoutFormPageState createState() => _CheckoutFormPageState();
}

class _CheckoutFormPageState extends State<CheckoutFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dryFruitNameController = TextEditingController();
  final TextEditingController _cityNameController = TextEditingController();
  final TextEditingController _warehouseNameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final String dryFruitName = _dryFruitNameController.text;
      final String cityName = _cityNameController.text;
      final String warehouseName = _warehouseNameController.text;
      final int weight = int.parse(_weightController.text);

      final Map<String, dynamic> requestBody = {
        'customerId': widget.client_Details["customerID"],
        'name': widget.client_Details["name"],
        'email': widget.client_Details["email"],
        'mobile': widget.client_Details["mobile"],
        'dryFruitName': dryFruitName,
        'cityName': cityName,
        'warehouseName': warehouseName,
        'weight': weight,
      };

      final response = await http.post(
        Uri.parse('${BASE_URL}api/warehouseCheckoutRequested/request'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Checkout request successful!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send request.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            
            children: [
              SizedBox(height: 30),
              TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage()));
                }, child: Text("Get Location" , style: TextStyle(fontFamily: 'helvetica' , color: Colors.red , decoration: TextDecoration.underline , decorationColor: Colors.red , decorationThickness: 2),)),
              SizedBox(height: 30),
              Text(
                "Retrieve DryFruits",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildCustomTextField(
                      controller: _dryFruitNameController,
                      hintText: 'Enter Dry Fruit Name',
                      icon: Icons.local_offer,
                      label: 'Dry Fruit Name',
                    ),
                    SizedBox(height: 20),
                    _buildCustomTextField(
                      controller: _cityNameController,
                      hintText: 'Enter City Name',
                      icon: Icons.location_city,
                      label: 'City Name',
                    ),
                    SizedBox(height: 20),
                    _buildCustomTextField(
                      controller: _warehouseNameController,
                      hintText: 'Enter Warehouse Name',
                      icon: Icons.home_work,
                      label: 'Warehouse Name',
                    ),
                    SizedBox(height: 20),
                    _buildCustomTextField(
                      controller: _weightController,
                      hintText: 'Enter Weight (in grams)',
                      icon: Icons.scale,
                      label: 'Weight',
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _submitForm,
                      child: Text(
                        'Submit',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom Text Field Widget
  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (keyboardType == TextInputType.number && int.tryParse(value) == null) {
          return 'Please enter a valid number';
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _dryFruitNameController.dispose();
    _cityNameController.dispose();
    _warehouseNameController.dispose();
    _weightController.dispose();
    super.dispose();
  }
}
