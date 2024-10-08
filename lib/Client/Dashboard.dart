import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inventory_app/Client/dashboard2.dart';
import 'package:inventory_app/Client/client_show_warehouse.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:workmanager/workmanager.dart';

class DashboardPage extends StatefulWidget {
  final Map<String, dynamic> client_Details;

  const DashboardPage({super.key, required this.client_Details});
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  List<String> cityList = [];
  double? cityTotalWeight;
  Map<String, double> cityWeights = {};
  String customerID='';
  bool _isLoading = true;



  @override
  void initState() {
    super.initState();
    customerID = widget.client_Details["customerID"];
    fetchCustomerHistory();
  }


Future<void> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled, do not continue.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try requesting permissions again.
      return Future.error('Location permissions are denied');
    }
  }
  
  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  } 

  // When permissions are granted, proceed to get the location.
  Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  print(position);
}


Future<void> fetchCustomerHistory() async {
  // setState(() {
  //   _isLoading = true;
  // });
  try {
    final response = await http.get(
      Uri.parse('${BASE_URL}api/CustomerHistory/customer-details?customerId=$customerID'),
    );

    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _isLoading = false;
      });

      Set<String> cities = {};
      List<dynamic> checkInHistory = data['checkInHistory'];

      for (var checkIn in checkInHistory) {
        List<dynamic> dryFruits = checkIn['dryFruits'];

        for (var dryFruit in dryFruits) {
          String cityName = dryFruit['cityName'];
          cities.add(cityName);
        }
      }

      // Ensure the widget is mounted before calling setState
      if (mounted) {
        setState(() {
          cityList = cities.toList();
        });
      }

      // Fetch weights for each city
      for (String city in cityList) {
        await fetchTotalWeight(cityName: city);
      }
    } else {
      print("Failed to load data. Status code: ${response.statusCode}");
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print("Error fetching customer history: $e");
  }
}

Future<void> fetchTotalWeight({required String cityName}) async {
  try {
    final response = await http.get(
      Uri.parse('${BASE_URL}api/CustomerHistory/customer-details?customerId=$customerID'),
    );

    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      double totalWeight = 0;

      List<dynamic> checkInHistory = data['checkInHistory'];

      for (var checkIn in checkInHistory) {
        List<dynamic> dryFruits = checkIn['dryFruits'];
        for (var dryFruit in dryFruits) {
          if (dryFruit['cityName'] == cityName) {
            totalWeight += dryFruit['weight'].toDouble();
          }
        }
      }

      List<dynamic> checkOutHistory = data['checkOutHistory'];
      for (var checkOut in checkOutHistory) {
        List<dynamic> dryFruits = checkOut['dryFruits'];
        for (var dryFruit in dryFruits) {
          if (dryFruit['cityName'] == cityName) {
            totalWeight -= dryFruit['weight'].toDouble();
          }
        }
      }

      // Ensure the widget is mounted before calling setState
      if (mounted) {
        setState(() {
          cityWeights[cityName] = totalWeight;
        });
      }
    } else {
      print("Failed to load data. Status code: ${response.statusCode}");
      throw Exception('Failed to load data');
    }
  } catch (e) {
    print("Error fetching total weight: $e");
  }
}


Future<void> fetchAllCityWeights() async {
  List<Future<void>> weightFetchFutures = [];
  for (String city in cityList) {
    weightFetchFutures.add(fetchTotalWeight(cityName: city));
  }
  await Future.wait(weightFetchFutures);
}




  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ElevatedButton(onPressed: (){
        //   print(widget.client_Details);
        // }, child: Text(('PRINT'))),
        _isLoading ? Center(child: CircularProgressIndicator(),):
        Padding(
          padding: const EdgeInsets.only(left: 12, right: 12 , top: 20),
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: cityList.isNotEmpty ?
            ListView.builder(
              shrinkWrap: true,
                    itemCount: cityList.length,
                    itemBuilder: (context, index) {
                      String cityName = cityList[index];
                      double weight = cityWeights[cityName] ?? 0.0;
                      
                      return Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard2(cityName: cityName , customerID: customerID, customer_ID: widget.client_Details,),
            ),
                      );
              },
              child: Container(
  width: MediaQuery.of(context).size.width,  // Full width of the screen
  height: MediaQuery.of(context).size.height * 0.25,  // 25% height of the screen
  decoration: BoxDecoration(
    color: Colors.blue,
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
        Colors.blue.withOpacity(0.9),
        Colors.blue.withOpacity(0.7),
        Colors.blue.withOpacity(0.5),
        Colors.blue.withOpacity(0.3),
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
      double availabilityFontSize = containerWidth * 0.05;  // Adjust accordingly
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
                  cityList[index],  // Display the city name dynamically
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
              ],
            ),
          ),
        ],
      );
    },
  ),
),

            ),
                      );
                    },
                  ) : Center(child: CircularProgressIndicator()),
          ),
        ),
        // ElevatedButton(onPressed: (){
        //   getCurrentLocation();
        // }, child: Text("loaction")),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(left: 220),
          child: FloatingActionButton(onPressed: ()async{
          await fetchAllCityWeights();
                  } ,
                  child: Icon(Icons.refresh),
                  backgroundColor: Colors.white,
                  ),
        ),
        SizedBox(height: 20,),
      ],
    );
  }
}

