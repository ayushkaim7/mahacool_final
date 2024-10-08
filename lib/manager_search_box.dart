import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:inventory_app/constants.dart';
import 'package:inventory_app/navigation_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<CustomerHistory> customerHistoryList = [];
  String searchQuery = '';
  List<CheckInHistory> filteredCheckIns = [];

  @override
  void initState() {
    super.initState();
    fetchCustomerHistory();
  }

  Future<void> fetchCustomerHistory() async {
    final response = await http.get(Uri.parse('${BASE_URL}api/CustomerHistory/getAll-history'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      print(data);
      setState(() {
        customerHistoryList = data.map((item) => CustomerHistory.fromJson(item)).toList();
      });
      print(customerHistoryList);
    } else {
      throw Exception('Failed to load data');
    }
  }

  void searchCustomer(String query) {
    setState(() {
      filteredCheckIns = customerHistoryList
          .where((history) => history.customerId == query)
          .expand((history) => history.checkInHistory)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Search Check-in Products' , style: TextStyle(fontFamily: 'casablanca'),)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10 , left: 18, right: 18),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Enter Customer ID',
                hintStyle: TextStyle(fontFamily: 'casablanca'),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                searchQuery = value;
                searchCustomer(searchQuery);
              },
            ),
          ),
          Expanded(
            child: filteredCheckIns.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredCheckIns.length,
                    itemBuilder: (context, index) {
                      var dryFruits = filteredCheckIns[index].dryFruits;
                      return Column(
                        children: dryFruits.map((fruit) => DryFruitCard(fruit)).toList(),
                      );
                    },
                  )
                : const Center(child: Text('No Check-ins Found')),
          ),
        ],
      ),
    );
  }
}

class DryFruitCard extends StatelessWidget {
  final DryFruits dryFruit;
  const DryFruitCard(this.dryFruit, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/dryfruit_logo.png', // Placeholder for fruit image
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dryFruit.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold , fontFamily: 'casablanca')),
                  const SizedBox(height: 4),
                  Text('Type: ${dryFruit.typeOfSack}'),
                  Text('Weight: ${dryFruit.weight} kg'),
                  Text('City: ${dryFruit.cityName}'),
                  Text('Warehouse: ${dryFruit.warehouseName}'),
                  Text('Rack: ${dryFruit.rackName}'),
                  Text('Record ID: ${dryFruit.recordId}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CustomerHistory {
  final String customerId;
  final List<CheckInHistory> checkInHistory;

  CustomerHistory({required this.customerId, required this.checkInHistory});

  factory CustomerHistory.fromJson(Map<String, dynamic> json) {
    return CustomerHistory(
      customerId: json['customerId'],
      checkInHistory: (json['checkInHistory'] as List)
          .map((data) => CheckInHistory.fromJson(data))
          .toList(),
    );
  }
}

class CheckInHistory {
  final List<DryFruits> dryFruits;

  CheckInHistory({required this.dryFruits});

  factory CheckInHistory.fromJson(Map<String, dynamic> json) {
    return CheckInHistory(
      dryFruits: (json['dryFruits'] as List)
          .map((data) => DryFruits.fromJson(data))
          .toList(),
    );
  }
}

class DryFruits {
  final String name, typeOfSack, cityName, warehouseName, rackName, recordId;
  final double weight;

  DryFruits({
    required this.name,
    required this.typeOfSack,
    required this.weight,
    required this.cityName,
    required this.warehouseName,
    required this.rackName,
    required this.recordId,
  });

  factory DryFruits.fromJson(Map<String, dynamic> json) {
    return DryFruits(
      name: json['name'],
      typeOfSack: json['typeOfSack'],
      weight: (json['weight'] as num).toDouble(),
      cityName: json['cityName'],
      warehouseName: json['warehouseName'],
      rackName: json['rackName'],
      recordId: json['recordId'],
    );
  }
}
