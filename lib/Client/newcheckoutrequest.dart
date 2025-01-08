import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/Client/data_model.dart';
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

  // Controllers
  final TextEditingController _weightController = TextEditingController();

  // Dropdown values
  List<String> dryFruitList = [];
  List<String> cityList = [];
  List<String> warehouseList = [];
  String? selectedDryFruit;
  String? selectedCity;
  String? selectedWarehouse;

  @override
  void initState() {
    super.initState();
    _fetchResponseData();
  }

  Future<void> _fetchResponseData() async {
    final response = await http.get(
      Uri.parse('${BASE_URL}api/CustomerHistory/customer-details?customerId=${widget.client_Details["customerID"]}'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      ResponseModel responseModel = ResponseModel.fromJson(jsonResponse);

      setState(() {
        dryFruitList = responseModel.dryFruitNames.split(", ");
        cityList = responseModel.cityNames;
        warehouseList = responseModel.warehouseList
            .map((warehouse) => warehouse['warehouseName'] as String)
            .toList();
      });
    } else {
      print("Failed to fetch data");
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> requestBody = {
        'customerId': widget.client_Details["customerID"],
        'name': widget.client_Details["name"],
        'email': widget.client_Details["email"],
        'mobile': widget.client_Details["mobile"],
        'dryFruitName': selectedDryFruit,
        'cityName': selectedCity,
        'warehouseName': selectedWarehouse,
        'weight': int.parse(_weightController.text),
      };

      final response = await http.post(
        Uri.parse('${BASE_URL}api/warehouseCheckoutRequested/request'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Checkout request successful!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send request.')));
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
                  children: [
                    _buildDropdown(
                      value: selectedDryFruit,
                      hint: "Select Dry Fruit",
                      items: dryFruitList,
                      onChanged: (value) {
                        setState(() {
                          selectedDryFruit = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    _buildDropdown(
                      value: selectedCity,
                      hint: "Select City",
                      items: cityList,
                      onChanged: (value) {
                        setState(() {
                          selectedCity = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    _buildDropdown(
                      value: selectedWarehouse,
                      hint: "Select Warehouse",
                      items: warehouseList,
                      onChanged: (value) {
                        setState(() {
                          selectedWarehouse = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      controller: _weightController,
                      label: "Weight (in grams)",
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(hint),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
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
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
