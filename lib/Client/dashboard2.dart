import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventory_app/Client/dashboard3.dart';
import 'package:inventory_app/Client/data_model.dart';
import 'package:inventory_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';


class Dashboard2 extends StatefulWidget {
  final String cityName;
  final String customerID;
  final Map<String, dynamic> customer_ID;
  const Dashboard2({super.key , required this.cityName , required this.customerID ,required this.customer_ID });

  @override
  State<Dashboard2> createState() => _Dashboard2State();
}

class _Dashboard2State extends State<Dashboard2> {
  List<Map<String, dynamic>> warehouseList = [];
  String ID ='';



  @override
void initState() {
  super.initState();
  ID = widget.customerID;
  fetchWarehouses(widget.cityName);
}


Future<void> fetchWarehouses(String cityName) async {
  final response = await http.get(
    Uri.parse('${BASE_URL}api/CustomerHistory/customer-details?customerId=$ID'),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);

    // Create a Map to track total weights for each warehouse
    Map<String, double> warehouseWeights = {};

    // Process check-in history
    List<dynamic> checkInHistory = data['checkInHistory'];
    for (var checkIn in checkInHistory) {
      List<dynamic> dryFruits = checkIn['dryFruits'];
      for (var dryFruit in dryFruits) {
        if (dryFruit['cityName'] == cityName) {
          String warehouseName = dryFruit['warehouseName'];
          
          // Ensure weight is treated as a double
          double weight = (dryFruit['weight'] is int)
              ? (dryFruit['weight'] as int).toDouble()
              : (dryFruit['weight'] as double); 

          warehouseWeights[warehouseName] = (warehouseWeights[warehouseName] ?? 0) + weight;
        }

      }
      
    }
    
    // Process check-out history
    List<dynamic> checkOutHistory = data['checkOutHistory'];
    for (var checkOut in checkOutHistory) {
      List<dynamic> dryFruits = checkOut['dryFruits'];
      for (var dryFruit in dryFruits) {
        if (dryFruit['cityName'] == cityName) {
          String warehouseName = dryFruit['warehouseName'];
          
          // Ensure weight is treated as a double
          double weight = (dryFruit['weight'] is int)
              ? (dryFruit['weight'] as int).toDouble()
              : (dryFruit['weight'] as double);

          // Subtract weight for check-outs
          warehouseWeights[warehouseName] = (warehouseWeights[warehouseName] ?? 0) - weight;
        }
      }
    }

    // Convert the map to a list of maps
    List<Map<String, dynamic>> warehouses = warehouseWeights.entries.map((entry) {
      return {
        "warehouseName": entry.key,
        "weight": entry.value,
      };
    }).toList();

    setState(() {
      warehouseList = warehouses;
    });
  } else {
    throw Exception('Failed to load data $ID');
  }
}


Future<List<DryFruit>> _getDryFruitsForWarehouse(String warehouseName) async {
  final response = await http.get(
    Uri.parse('${BASE_URL}api/CustomerHistory/customer-details?customerId=${widget.customer_ID["customerID"]}'),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    List<DryFruit> dryFruits = [];

    // Process check-in history
    List<dynamic> checkInHistory = data['checkInHistory'];
    for (var checkIn in checkInHistory) {
      List<dynamic> dryFruitsData = checkIn['dryFruits'];
      for (var dryFruitData in dryFruitsData) {
        if (dryFruitData['warehouseName'] == warehouseName) {
          String name = dryFruitData['name'];
          
          // Ensure weight is treated as a double
          double quantity = (dryFruitData['weight'] is int)
              ? (dryFruitData['weight'] as int).toDouble()
              : (dryFruitData['weight'] as double);
          
          dryFruits.add(DryFruit(name: name, quantity: quantity));
        }
      }
    }

    // Process check-out history
    List<dynamic> checkOutHistory = data['checkOutHistory'];
    for (var checkOut in checkOutHistory) {
      List<dynamic> dryFruitsData = checkOut['dryFruits'];
      for (var dryFruitData in dryFruitsData) {
        if (dryFruitData['warehouseName'] == warehouseName) {
          String name = dryFruitData['name'];
          
          // Ensure weight is treated as a double
          double quantity = (dryFruitData['weight'] is int)
              ? (dryFruitData['weight'] as int).toDouble()
              : (dryFruitData['weight'] as double);

          dryFruits.add(DryFruit(name: name, quantity: -quantity)); // Subtract weight for check-outs
        }
      }
    }

    // Aggregate quantities
    Map<String, double> aggregatedQuantities = {};
    for (var dryFruit in dryFruits) {
      aggregatedQuantities[dryFruit.name] = (aggregatedQuantities[dryFruit.name] ?? 0) + dryFruit.quantity;
    }

    // Convert to a list of DryFruit
    return aggregatedQuantities.entries.map((entry) {
      return DryFruit(name: entry.key, quantity: entry.value);
    }).toList();
  } else {
    throw Exception('Failed to load data');
  }
}







  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4c606b),
        toolbarHeight: 70,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Container(
              height: 80,
              width: 70,
              child: Image(
                image: AssetImage("assets/app_logo.png"),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 5,),
            LayoutBuilder(builder: (context , Constraints){

              return Text('Customer' , style: TextStyle(fontFamily: 'helvetica' , color: Colors.white , fontSize: MediaQuery.of(context).size.width * 0.04 , fontWeight: FontWeight.bold),);
            })
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color.fromRGBO(151, 163, 170, 1),
      body:Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12 , top: 15 ,),
          child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: warehouseList.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true, // For proper scrolling in a column
                itemCount: warehouseList.length,
                itemBuilder: (context, index) {
                  String warehouseName = warehouseList[index]['warehouseName'];
                  double weight = warehouseList[index]['weight'];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: InkWell(
                      onTap: () async {
                          List<DryFruit> dryFruits = await _getDryFruitsForWarehouse(warehouseName);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard3(dryFruits: dryFruits, warehousename: warehouseName, cityname: widget.cityName, customerID:  widget.customer_ID,)));
                        print(_getDryFruitsForWarehouse(warehouseName));
                      },
                      child: Container(
  width: MediaQuery.of(context).size.width,  // Full width of the screen
  height: MediaQuery.of(context).size.height * 0.25,  // 25% height of the screen
  decoration: BoxDecoration(
    color: Colors.orange,
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 10,
        offset: Offset(5, 5),
      ),
    ],
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.orange.withOpacity(0.9),
        Colors.orange.withOpacity(0.7),
        Colors.orange.withOpacity(0.5),
        Colors.orange.withOpacity(0.3),
      ],
      stops: const [0.1, 0.3, 0.8, 1],
    ),
  ),
  child: LayoutBuilder(
    builder: (context, constraints) {
      double containerWidth = constraints.maxWidth;
      double containerHeight = constraints.maxHeight;

      // Sizes based on the container's width and height
      double circleSize = containerWidth * 0.67;  // Adjust circle size based on container size
      double cityFontSize = containerWidth * 0.08;  // Font size based on container width
      double availabilityFontSize = containerWidth * 0.04;  // Adjust accordingly
      double weightFontSize = containerWidth * 0.04;  // Adjust accordingly

      return Stack(
        children: [
          // Positioned circle
          Positioned(
            top: -30,
            left: -45,
            bottom: -30,
            child: Container(
              width: circleSize,  // Adjusted size
              height: circleSize,  // Adjusted size
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                warehouseName,  // Display the city name dynamically
                  style: TextStyle(
                    fontFamily: 'helvetica',
                    fontSize: cityFontSize,  // Dynamically adjusted font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Text for "Dry Fruits Stock availability"
          Positioned(
            top: containerHeight * 0.25,
            left: containerWidth * 0.60,  // Adjust the left offset to position text within container
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dry Fruits \nStock \navailability",
                  style: TextStyle(
                    fontFamily: 'helvetica',
                    fontSize: availabilityFontSize,  // Dynamically adjusted font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${weight.toStringAsFixed(2)} KG",  // Example text for capacity, can be dynamic
                  style: TextStyle(
                    fontFamily: 'helvetica',
                    fontSize: weightFontSize,  // Dynamically adjusted font size
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // ElevatedButton(onPressed: (){
                //   print(warehouseList);
                // }, child: Text('print'))
              ],
            ),
          ),
        ],
      );
    },
  ),
),
                      // child: Padding(
                      //   padding: const EdgeInsets.only(left: 10, right: 10),
                      //   child: Container(
                      //     width: MediaQuery.of(context).size.width,
                      //     height: 200,
                      //     decoration: BoxDecoration(
                      //       color: Colors.orange,
                      //       borderRadius: BorderRadius.circular(20),
                      //       boxShadow: const [
                      //         BoxShadow(
                      //           color: Colors.black12,
                      //           blurRadius: 10,
                      //           offset: Offset(5, 5),
                      //         ),
                      //       ],
                      //       gradient: LinearGradient(
                      //         begin: Alignment.topLeft,
                      //         end: Alignment.bottomRight,
                      //         colors: [
                      //           Colors.orange.withOpacity(0.9),
                      //           Colors.orange.withOpacity(0.7),
                      //           Colors.orange.withOpacity(0.5),
                      //           Colors.orange.withOpacity(0.3),
                      //         ],
                      //         stops: const [0.1, 0.3, 0.8, 1],
                      //       ),
                      //     ),
                      //     child: Stack(
                      //       children: [
                      //         Positioned(
                      //           top: -30,
                      //           left: -45,
                      //           bottom: -30,
                      //           child: Container(
                      //             width: 230,
                      //             height: 250,
                      //             decoration: BoxDecoration(
                      //               color: Colors.white.withOpacity(0.4),
                      //               shape: BoxShape.circle,
                      //             ),
                      //             child: Center(
                      //               child: Text(
                      //                 warehouseName,
                      //                 style: const TextStyle(fontFamily: 'helvetica', fontSize: 28 , fontWeight: FontWeight.bold),
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.only(top: 40, left: 190),
                      //           child: Column(
                      //             children: [
                      //               const Text(
                      //                 "Dry Fruits \nStock\navailability",
                      //                 style: TextStyle(fontFamily: 'helvetica', fontSize: 15 , fontWeight: FontWeight.bold),
                      //               ),
                      //               const SizedBox(height: 10),
                      //               Text(
                      //                 "${weight.toStringAsFixed(2)} KG",
                      //                 style: const TextStyle(fontFamily: 'helvetica', fontSize: 15, color: Colors.white , fontWeight: FontWeight.bold) ,
                      //               ),
                      //               SizedBox(height: 30,),
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ),
                  );
                },
                
              )
            : const Center(child: Text('No cities to show')), // Loading indicator while fetching data
                  )
        ),

      ],
          ),
    );
    
  }
}