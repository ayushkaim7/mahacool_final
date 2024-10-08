import 'package:flutter/material.dart';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/Client/finalcheckout.dart';
import 'dart:convert';

import 'package:inventory_app/constants.dart';

class WarehousesPage extends StatefulWidget {
  final String cityId;
  final String cityName;

  const WarehousesPage({required this.cityId , required this.cityName});

  @override
  _WarehousesPageState createState() => _WarehousesPageState();
}

class _WarehousesPageState extends State<WarehousesPage> {
  List warehouses = [];

  @override
  void initState() {
    super.initState();
    _fetchWarehouses();
  }

  Future<void> _fetchWarehouses() async {
    final response = await http.get(Uri.parse('${BASE_URL}api/container/getid?id=${widget.cityId}'));
    if (response.statusCode == 200) {
      setState(() {
        warehouses = jsonDecode(response.body);
      });
    } else {
      // Handle error
      print('Failed to load warehouses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Warehouses'),
        titleTextStyle: TextStyle(fontFamily: 'helvetica' , fontSize: 20),
        backgroundColor: Color(0xFF4c606b),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Warehouses',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black , fontFamily: 'helvetica',
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: warehouses.length,
                itemBuilder: (context, index) {
                  final warehouse = warehouses[index];
                  final String wid = warehouses[index]["_id"];
                  final String wname = warehouses[index]['name'];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Finalcheckout(wid: wid, wname: wname, cityname: widget.cityName,)));
                      print(wid);
                    },
                    child: Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(warehouse['name'] , style: TextStyle(fontFamily: 'helvetica' , fontSize: 18 , fontWeight: FontWeight.w600),),
                        //subtitle: Text('Location: ${warehouse['location']}'),
                        trailing: Icon(Icons.store),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
