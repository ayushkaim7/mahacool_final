import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventory_app/Client/client_show_warehouse.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/constants.dart';
import 'package:inventory_app/map_pages.dart';



class RequestsPage extends StatefulWidget {
  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  late PageController _myPage;
  late Future<List<dynamic>> _cities;

  @override
  void initState() {
    super.initState();
    _cities = fetchCities();

   // getHttp();
    _myPage = PageController(initialPage: 1);
  }


  Future<List<dynamic>> fetchCities() async {
    final response = await http.get(Uri.parse('${BASE_URL}api/city/getall'));
    //var jsonResponse;
    if (response.statusCode == 200) {
      List<dynamic> cities = json.decode(response.body);
     // jsonResponse = json.decode(response.body);
      //final int cityId = jsonResponse['_id'];
      return cities;
    } else {
      throw Exception('Failed to load cities');
    }
  }


   void _onCityTap(String cityId , String cityName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WarehousesPage(cityId: cityId , cityName: cityName,),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:20, top: 20 , bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Cities" , style: TextStyle(fontFamily: 'helvetica' , fontSize: 25 , fontWeight: FontWeight.w700),),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MapPage()));
                }, child: Text("Get Location" , style: TextStyle(fontFamily: 'helvetica' , color: Colors.red , decoration: TextDecoration.underline , decorationColor: Colors.red , decorationThickness: 2),))
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _cities,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No cities found'));
                } else {
                  List<dynamic> cities = snapshot.data!;
                  return ListView.builder(
                    itemCount: cities.length,
                    
                    itemBuilder: (context, index) {

                      final city = cities[index];
                      return Card(
                        margin: EdgeInsets.all(10),
                        elevation: 5,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(15),
                          onTap: ()=> _onCityTap(city['_id'] , city['name']),
                          title: Text(
                            city['name'], // Adjust key based on actual data structure
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold , fontFamily: 'helvetica'),
                          ),
                          // subtitle: Text(
                          //   'Population: ${city['population']}', // Adjust key based on actual data structure
                          //   style: TextStyle(fontSize: 16),
                          // ),
                          leading: Icon(Icons.location_city, size: 40, color: Color(0xFF4c606b)),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      );
  }
}