import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_app/LoginScreen.dart';
import 'package:inventory_app/billing.dart';
import 'package:inventory_app/client_screen.dart';
import 'package:inventory_app/constants.dart';
import 'package:inventory_app/login_screen.dart';
import 'package:inventory_app/manager_checkout_requestlist.dart';
import 'package:inventory_app/manager_scan.dart';
import 'package:inventory_app/manager_search_box.dart';
import 'package:inventory_app/manager_settings.dart';
import 'package:inventory_app/requestlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {

  final String manageremail;
  final String managername;
  final String managernumber;

  const HomePage({super.key, required this.manageremail , required this.managername , required this.managernumber});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  late PageController _pageController;
  SharedPreferences? sharedPreferences;
  var productdetails;
  int _selectedIndex = 0;
  String? userType;

  @override
  void initState() {
    super.initState();
    //getHttp();
    _pageController = PageController(initialPage: _selectedIndex);
    _initializeSharedPreferences();

  }
  Future<void> _initializeSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userType = sharedPreferences!.getString("type"); // Save the user type
    getHttp();
  }


    Future getHttp() async {
    //if (sharedPreferences == null) return;
    String id = sharedPreferences!.getString("uid")!;
    print(userType);

    http.Response caresponse = await http.get(
      Uri.parse('${BASE_URL}api/city/getall'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    print("response ${caresponse.body}");
    setState(() {
      productdetails = json.decode(caresponse.body);
    });
  }


  // Future<void> _initializeSharedPreferences() async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   getHttp();
  //   //setState(() {}); // Trigger a rebuild after initialization
  // }


  void _onItemTapped(int index) {
 // if (sharedPreferences == null) return;

  // if (index == 3) {  // Assuming 'Logout' is the 4th item in the BottomNavigationBar
  //   // Clear shared preferences
  //   sharedPreferences!.clear();

  //   // Navigate to the login screen and remove everything from the stack
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (context) => ManagerSettings()),
  //     (Route<dynamic> route) => false,
  //   );
  // } else {
    setState(() {
      _selectedIndex = index;
      
    });
    _pageController.jumpToPage(index);  
  
}

  @override
  Widget build(BuildContext context) {
    if (sharedPreferences == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      backgroundColor: _selectedIndex == 0? Color(0xFF4c606b) : Colors.white,
      body:PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
        children: [
          ClientScreen(), // Page 0
         // Billing(),  // Page 1
          WarehouseCheckoutList(), // Page 1
          QRScannerPage(), // Page 2
          SearchPage(),
          ManagerSettings(Memail: widget.manageremail, Mname: widget.managername, Mnumber:  widget.managernumber.toString(),)  // Page 3
        ],
      ),
      bottomNavigationBar: Container(
            height: 80, // Adjust height as needed
        decoration: BoxDecoration(
           color: Colors.transparent, // Background color of the navigation bar
           borderRadius: BorderRadius.vertical(top: Radius.circular(40)), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, -1), // Shadow at the top
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)), // Ensure the clip is also rounded
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[

              if (userType == "manager")
                const BottomNavigationBarItem(
                  icon: Icon(Icons.location_city , size: 30,),
                  label: 'Cities ',
                ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.request_page , size: 30),
                label: 'Requests',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.adf_scanner_outlined , size: 30,),
                label: 'Scan',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.search_outlined , size: 30,),
                label: 'Search',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.settings , size: 30),
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.black,
            onTap: _onItemTapped,
            selectedLabelStyle: TextStyle(fontFamily: 'helvetica' , color: Colors.white),
            unselectedLabelStyle: TextStyle(fontFamily: 'helvetica' , color: Colors.white),
            backgroundColor: Color.fromARGB(255, 139, 154, 161),
          ),
        ),
      ),
      
    );
  }
}
