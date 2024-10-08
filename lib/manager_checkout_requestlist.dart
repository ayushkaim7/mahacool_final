import 'dart:convert'; // For decoding JSON data
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For making API calls
import 'package:intl/intl.dart';
import 'package:inventory_app/constants.dart';
import 'package:workmanager/workmanager.dart'; // For date formatting

class WarehouseCheckoutList extends StatefulWidget {
  @override
  _WarehouseCheckoutListState createState() =>
      _WarehouseCheckoutListState();
}

class _WarehouseCheckoutListState extends State<WarehouseCheckoutList> {
  List<dynamic> checkoutData = []; // List to store fetched data
  bool isLoading = true;

  // API call function
  Future<void> fetchCheckoutData() async {
    final url = '${BASE_URL}api/warehouseCheckoutRequested/active';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // If server returns a valid response, decode the JSON
        setState(() {
          checkoutData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        // If the server did not return a 200 OK response, throw an error
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle errors here
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCheckoutData(); // Fetch data when the screen is initialzed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        

        title: Text("Warehouse Checkout" , style: TextStyle(fontFamily: 'helvetica'),),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : ListView.builder(
              itemCount: checkoutData.length,
              itemBuilder: (context, index) {
                var customer = checkoutData[index];
                return WarehouseCheckoutCard(data: customer);
              },
            ),
    );
  }
}

// Card widget for displaying data
class WarehouseCheckoutCard extends StatelessWidget {
  final Map<String, dynamic> data;

  WarehouseCheckoutCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Info Section
              Text(
                data['name'] ?? 'N/A',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  fontFamily: 'helvetica'
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Customer ID: ${data['customerId'] ?? 'N/A'}",
                style: TextStyle(fontSize: 16, color: Colors.grey[700],
                fontFamily: 'helvetica'
                ),
              ),
              SizedBox(height: 4),
              LayoutBuilder(builder: (context , Constraints){
                return Text(
                "Email: ${data['email'] ?? 'N/A'}",
                style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04, color: Colors.grey[700],
                fontFamily: 'helvetica'
                ),
              );
              }),
              SizedBox(height: 4),
              Text(
                "Mobile: ${data['mobile'] ?? 'N/A'}",
                style: TextStyle(fontSize: 16, color: Colors.grey[700],
                fontFamily: 'helvetica'
                ),
              ),
              Divider(height: 30, thickness: 2),
              
              // Dry Fruit Details Section
              Text(
                "Dry Fruit Details",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: 'helvetica'
                ),
              ),
              SizedBox(height: 8),
              Column(
                children: List.generate(
                  data['dryFruitDetails'].length,
                  (index) {
                    var dryFruitDetail = data['dryFruitDetails'][index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Card(
                        color: Colors.grey[100],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.request_quote_sharp,
                                      color: Colors.brown, size: 24),
                                  SizedBox(width: 8),
                                  Text(
                                    dryFruitDetail['dryFruitName'] ??
                                        'Dry Fruit Name',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.brown,
                                        fontFamily: 'helvetica'
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                "City: ${dryFruitDetail['cityName'] ?? 'N/A'}",
                                style: TextStyle(fontSize: 14,
                                fontFamily: 'helvetica'
                                )
                                
                                ,
                              ),
                              Text(
                                "Warehouse: ${dryFruitDetail['warehouseName'] ?? 'N/A'}",
                                style: TextStyle(fontSize: 14,
                                fontFamily: 'helvetica'
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Weight: ${dryFruitDetail['weight'] ?? 0} Kgs",
                                style: TextStyle(fontSize: 14 , fontFamily: 'helvetica'),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Status: ${dryFruitDetail['status'] ? 'Active' : 'Inactive'}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: dryFruitDetail['status']
                                      ? Colors.green
                                      : Colors.red,
                                      fontFamily: 'helvetica'
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Date Added: ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(dryFruitDetail['dateAdded']))}",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

