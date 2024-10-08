import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inventory_app/Client/finalpay_bargraph.dart';
import 'package:inventory_app/Client/newcheckoutrequest.dart';

import 'package:inventory_app/Client/show_bills_new.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_app/Client/Dashboard.dart';
import 'package:inventory_app/Client/clientsettings.dart';
import 'package:inventory_app/Client/requestbags.dart';
import 'package:inventory_app/Client/transactions.dart';
import 'package:inventory_app/LoginScreen.dart';
import 'package:inventory_app/Client/client_show_warehouse.dart';
import 'package:inventory_app/constants.dart';
import 'package:inventory_app/notification_service.dart';
import 'package:inventory_app/package_screen.dart';
import 'package:inventory_app/login_screen.dart';
import 'package:inventory_app/update_user_details.dart';
import 'package:inventory_app/view_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;
import 'package:provider/provider.dart';

class Managerscreen extends StatefulWidget {
  final String ClientId;
  final Map<String, dynamic> client_Details;

  const Managerscreen({super.key, required this.ClientId , required this.client_Details});
  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<Managerscreen> {

  late IO.Socket socket;
  bool hasNewNotification = false;

  late PageController _myPage;
  SharedPreferences? sharedPreferences;
  List ads = [];
  int currentPage = 0;
  int bcurrentPage = 0;
  var productdetails;
  var superdetails;
  bool tab1 = true;
  bool tab2 = false;
  bool tab3 = false;
  var bannerdetails;
  var catdetails;
  var stringResponse;
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController pincodeController = new TextEditingController();
  TextEditingController couponController = new TextEditingController();
  List cartsarray = [];
  List cartsqaun = [];
  int subtotal = 0;
  int total = 0;
  int discount = 0;
  late List<Widget> _pages;
 // String oproduct = "";
  List _ch = ["Delhi", "Haryana", "Mumbai"];
  int count = 1;
  var ch;
  int dcharge = 0;
  var enquiryValue = 'Day after tomorrow';
  static final DateTime now = DateTime.now();



Future<void> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Loop until location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  while (!serviceEnabled) {
    // Ask the user to enable location services
    await Geolocator.openLocationSettings();
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
  }

  // Check location permissions
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When permissions are granted, get the location
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  // Print the position for testing
  print("Latitude: ${position.latitude}, Longitude: ${position.longitude}");

  // Send the location to the server using POST request
  await sendLocationToServer(
    customerID: widget.client_Details["customerID"],
    latitude: position.latitude.toString(),
    longitude: position.longitude.toString(),
  );
}


  // Function to send the location data via POST request
  Future<void> sendLocationToServer({
    required String customerID,
    required String latitude,
    required String longitude,
  }) async {
    final url = Uri.parse('${BASE_URL}api/client/add-location/');

    final body = {
      "customerID": customerID,
      "latitude": latitude,
      "longitude": longitude,
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        print('Location sent successfully: ${response.body}');
      } else {
        print('Failed to send location: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending location: $e');
    }
  }

  


  Future getHttp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences!.getString("uid")!;
    http.Response sresponse;
    sresponse = await (http.get(
        Uri.parse(
            'https://molten-topic-379204.el.r.appspot.com/api/streams/gettop'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));
    http.Response bresponse;
    bresponse = await (http.get(
        Uri.parse(
            'https://molten-topic-379204.el.r.appspot.com/api/images/getbanners'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));
    http.Response presponse;
    presponse = await (http.get(
        Uri.parse(
            'https://molten-topic-379204.el.r.appspot.com/api/packages/getbanners'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }));

    http.Response caresponse;
    caresponse = await (http.get(
        Uri.parse(
            'https://molten-topic-379204.el.r.appspot.com/api/category/getcategories'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));
    setState(() {
      productdetails = json.decode(presponse.body);
      bannerdetails = json.decode(bresponse.body);
      superdetails = json.decode(sresponse.body);
      catdetails = json.decode(caresponse.body);
    });
  }
   late Future<List<dynamic>> _cities;
  

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
    _pages = <Widget>[
    DashboardPage(client_Details: widget.client_Details,),
    FileListScreen(customerID: widget.client_Details,),
    CheckoutFormPage(client_Details: widget.client_Details),
    SettingsPage(clientDetails: widget.client_Details, Client_id: widget.ClientId,),
  ];
    _cities = fetchCities();

     initializeSocket();
     
     

    getHttp();
    _myPage = PageController(initialPage: 1);
    hasNewNotification = true;
  }



   void initializeSocket() {
  // Initialize socket connection to your backend
  socket = IO.io('${BASE_URL}', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });

  // Listen for successful connection
  socket.on('connect', (_) {
    print('Socket connected');
  });

  // Listen for disconnection
  socket.on('disconnect', (_) {
    print('Socket disconnected');
  });

  // Reconnection logic (optional)
  socket.on('reconnect', (_) {
    print('Socket reconnected');
  });

  // Listen for 'new-notification' event from the backend
  socket.on('new-notification', (data) {
    print('New notification received: $data'); // For debugging
    setState(() {
      hasNewNotification = true; // Set icon to red
    });

    // Show a toast message when notification arrives
    Fluttertoast.showToast(
      msg: "New notification received!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  });
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



  int _selectedIndex = 0;

  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }





  @override
  Widget build(BuildContext context) {
    final notificationService = Provider.of<NotificationService>(context);


    return Scaffold(
    
      appBar: AppBar(
        backgroundColor: Color(0xFF4c606b),
        elevation: 0,
        titleSpacing: 0,
        toolbarHeight: 70,
        title: Row(
          children: [
            Container(
              height: 60,
              width: 70,
              child: Image(
                image: AssetImage("assets/app_logo.png"),
                fit: BoxFit.cover,
              ),
            ),
            //SizedBox(width: 5,),
            LayoutBuilder(builder: (context , Constraints){
              double screenWidth = MediaQuery.of(context).size.width;
    // Calculate font size dynamically based on screen width
    double fontSize = screenWidth * 0.04;
              return Text('Customer' , style: TextStyle(fontFamily: 'helvetica' , color: Colors.white , fontSize: fontSize , fontWeight: FontWeight.bold),);
            })
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          LayoutBuilder(
  builder: (context, constraints) {
    // Get the screen size
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate sizes dynamically
    double iconSize = screenWidth * 0.08; // Adjust the multiplier as needed
    double fontSize = screenWidth * 0.03; // Adjust the multiplier for text

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuarterlyBarGraph(
                  client_Details: widget.client_Details,
                ),
              ),
            );
          },
          icon: Icon(
            Icons.currency_rupee,
            color: Colors.white,
            size: iconSize,  // Dynamic icon size
          ),
          visualDensity: VisualDensity.compact,  // Minimize space inside the IconButton
          padding: EdgeInsets.zero,  // Remove default padding
        ),
        Text(
          'Pay Bills',
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,  // Dynamic font size
          ),
        ),
      ],
    );
  },
),

          IconButton(onPressed: (){
            print(widget.client_Details);
            print(widget.client_Details["customerID"]);
            Navigator.push(context, MaterialPageRoute(builder: (context)=> NotificationPage(customerID: widget.client_Details["customerID"],)));
            setState(() {
              hasNewNotification = false;
            });
           
            
          }, icon: Icon(Icons.notifications, 
          color: hasNewNotification ? Colors.red : Colors.white,)),
  
          IconButton(
            icon: Icon(
              Icons.logout,
              size: 25,
              color: Colors.black,
            ),
            onPressed: () async {
               if (sharedPreferences == null) {
      sharedPreferences = await SharedPreferences.getInstance(); // Lazy initialization
    }
              sharedPreferences!.setBool("isLoggedIn", false);
              Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(
    builder: (BuildContext context) => login_screen(),
  ),
  (Route<dynamic> route) => false,  // This ensures all previous routes are removed
);

            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ClipRRect(
          borderRadius:  BorderRadius.circular(30),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF4c606b),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Color(0xFF4c606b),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              currentIndex: _selectedIndex,
              selectedLabelStyle: const TextStyle(fontFamily: 'helvetica'),
              unselectedLabelStyle:const TextStyle(fontFamily: 'helvetica') ,
              iconSize: 20,
              onTap: _onItemTapped,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                  
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money),
                  label: 'Invoices',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.request_page),
                  label: 'Retrieve',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
          ),
        ),
      ),
  
  
  
  
  
  
  
  
  
  
  //       body: SingleChildScrollView(
  //         child: Container(
  //           padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 15),
  //           decoration: BoxDecoration(
  //             image: DecorationImage(
  //               image: AssetImage('assets/app_logo.png'),
  //               fit: BoxFit.contain,
  //             ),
  //             color: Colors.white,
  //           ),
  //           width: double.infinity,
  //           child: Column(children: <Widget>[
  //             Container(
  //               height: MediaQuery.of(context).size.height - 120,
  //               decoration: BoxDecoration(
  //                 // image: DecorationImage(
  //                 //   image: AssetImage('assets/app_logo.png'),
  //                 //   fit: BoxFit.contain,
  //                 // ),
  //               ),
  //               child: Column(
  //                 children: [
                
  //                   SizedBox(height: 30),
  //                   Align(
  //                       alignment: Alignment.center,
  //                       child: DefaultTextStyle(
  //                           style: TextStyle(
  //                               fontSize: 16,
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.black , fontFamily: 'helvetica'),
  //                           child: Text(
  //                             "Cities  ",
  //                           ))),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   Container(
  //                     height: MediaQuery.of(context).size.height - 270,
  //                     width: MediaQuery.of(context).size.width,
  //                     child: PageView.builder(
  //                       onPageChanged: (value) {
  //                         setState(() {
  //                           currentPage = value;
  //                         });
  //                       },
  //                       itemCount: 1,
  //                       itemBuilder: (context, index) => index == 0
  //                           ? SingleChildScrollView(
  //                               child: Container(
  //                               child: Column(
  //                                 children: [
  //                                   GridView.builder(
  //                                       shrinkWrap: true,
  //                                       gridDelegate:
  //                                           const SliverGridDelegateWithFixedCrossAxisCount(
  //                                         crossAxisCount: 3,
  //                                         mainAxisSpacing: 5,
  //                                         crossAxisSpacing: 5,
  //                                       ),
  //                                       physics: ScrollPhysics(),
  //                                       itemCount: productdetails?.length ?? 0,
  //                                       itemBuilder:
  //                                           (BuildContext context, int iindex) {
  //                                         return GestureDetector(
  //                                           onTap: () {
  //                                             Navigator.of(context).push(
  //                                                 MaterialPageRoute(
  //                                                     builder: (context) =>
  //                                                         PackageScreen(
  //                                                           pid: "pid",
  //                                                         )));
  //                                           },
  //                                           child: Container(
  //                                             height: 50,
  //                                             margin: EdgeInsets.only(
  //                                                 top: 2, left: 5, right: 5),
  //                                             decoration: BoxDecoration(
  //                                               color: Color((math.Random()
  //                                                               .nextDouble() *
  //                                                           0xFFFFFF)
  //                                                       .toInt())
  //                                                   .withOpacity(1.0),
  //                                               borderRadius:
  //                                                   BorderRadius.circular(5),
  //                                             ),
  //                                             child: Container(
  //                                                 width: 150,
  //                                                 height: 50,
  //                                                 padding:
  //                                                     EdgeInsets.only(top: 0),
  //                                                 child: Column(
  //                                                   children: [
  //                                                     Container(
  //                                                       width: 150,
  //                                                       child: Column(
  //                                                         children: <Widget>[
                                                         
  //                                                           SizedBox(
  //                                                             height: 10,
  //                                                           ),
  
  //                                                           Container(
  //                                                           //     child: Image(
  //                                                           //   image: AssetImage(
  //                                                           //       "assets/app_logo.png"),
  //                                                           // )),
  //                                                           ),
  
                                                          
  //                                                           SizedBox(
  //                                                             width: 5,
  //                                                           ),
  //                                                           Container(
  //                                                             padding:
  //                                                                 EdgeInsets.only(
  //                                                                     top: 3),
  //                                                             child:
  //                                                                 DefaultTextStyle(
  //                                                                     style: TextStyle(
  //                                                                         fontSize:
  //                                                                             12,
  //                                                                         fontWeight:
  //                                                                             FontWeight
  //                                                                                 .bold,
  //                                                                         color: Colors
  //                                                                             .white),
  //                                                                     child: Text(
  //                                                                       "${_ch[iindex]}",
  //                                                                     )),
  //                                                           ),
  //                                                           SizedBox(
  //                                                             width: 5,
  //                                                           ),
  //                                                         ],
  //                                                       ),
  //                                                     ),
  //                                                   ],
  //                                                 )),
  //                                           ),
  //                                         );
  //                                       }),
  //                                   SizedBox(
  //                                     height: 15,
  //                                   ),
  //                                 ],
  //                               ),
  //                             ))
  //                           : index == 1
  //                               ? SingleChildScrollView(
  //                                   child: Container(
  //                                   child: Column(
  //                                     children: [
  //                                       GridView.builder(
  //                                           shrinkWrap: true,
  //                                           gridDelegate:
  //                                               const SliverGridDelegateWithFixedCrossAxisCount(
  //                                             crossAxisCount: 2,
  //                                           ),
  //                                           physics: ScrollPhysics(),
  //                                           itemCount: productdetails.length,
  //                                           itemBuilder: (BuildContext context,
  //                                               int iindex) {
  //                                             return GestureDetector(
  //                                               onTap: () {
  //                                                 // Navigator.of(context)
  //                                                 //     .push(MaterialPageRoute(
  //                                                 //   builder: (context) =>
  //                                                 //       ProductDetails(
  //                                                 //         index:
  //                                                 //         "${productdetails[iindex]["h5page"]}",
  //                                                 //         cate:
  //                                                 //         "${productdetails[iindex]["pcat"]}",
  //                                                 //       ),
  //                                                 // ));
  //                                               },
  //                                               child: Container(
  //                                                 margin: EdgeInsets.only(
  //                                                     left: 5, top: 2),
  //                                                 padding: EdgeInsets.all(5),
  //                                                 width: MediaQuery.of(context)
  //                                                         .size
  //                                                         .width /
  //                                                     2,
  //                                                 decoration: BoxDecoration(
  //                                                   color: Colors.black,
  //                                                   // image: DecorationImage(
  //                                                   //     image: NetworkImage(
  //                                                   //         "${productdetails[iindex]["pphoto"]}"),
  //                                                   //     fit: BoxFit.fill),
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(10),
  //                                                   // boxShadow: [
  //                                                   //   BoxShadow(
  //                                                   //       offset: Offset(0, 0),
  //                                                   //       blurRadius: 0.5,
  //                                                   //       spreadRadius: 0.5,
  //                                                   //       color: Colors.deepOrange
  //                                                   //   ),
  //                                                   // ],
  //                                                 ),
  //                                                 child: Column(
  //                                                   children: <Widget>[
  //                                                     // Image(
  //                                                     //   height: 110,
  //                                                     //   width: 125 ,
  //                                                     //   image:
  //                                                     //   NetworkImage("${productdetails[iindex]["pphoto"]}")
  //                                                     //   ,
  //                                                     //   fit: BoxFit.fill,
  //                                                     // ),
  //                                                     Container(
  //                                                         width: 200,
  //                                                         padding:
  //                                                             EdgeInsets.only(
  //                                                                 top: 0),
  //                                                         child: Column(
  //                                                           children: [
  //                                                             Container(
  //                                                               width: 150,
  //                                                               child: Column(
  //                                                                 children: <Widget>[
  //                                                                   Align(
  //                                                                       alignment:
  //                                                                           Alignment
  //                                                                               .bottomLeft,
  //                                                                       child: Text(
  //                                                                           "${productdetails[iindex]["pname"]}",
  //                                                                           style: TextStyle(
  //                                                                               color: Colors.white,
  //                                                                               fontSize: 11,
  //                                                                               fontWeight: FontWeight.bold))),
  //                                                                   Align(
  //                                                                       alignment:
  //                                                                           Alignment
  //                                                                               .bottomLeft,
  //                                                                       child: Text(
  //                                                                           "${productdetails[iindex]["pdes"]}",
  //                                                                           style: TextStyle(
  //                                                                               color: Colors.white,
  //                                                                               fontSize: 8))),
  //                                                                   Row(
  //                                                                     children: [
  //                                                                       Container(
  //                                                                           height:
  //                                                                               30,
  //                                                                           child:
  //                                                                               Icon(
  //                                                                             Icons.remove_red_eye,
  //                                                                             color:
  //                                                                                 Colors.white,
  //                                                                             size:
  //                                                                                 20,
  //                                                                           )),
  //                                                                       Container(
  //                                                                         height:
  //                                                                             30,
  //                                                                         padding:
  //                                                                             EdgeInsets.only(top: 7),
  //                                                                         child: Text(
  //                                                                             " ${productdetails[iindex]["view"].toString()}",
  //                                                                             style: TextStyle(
  //                                                                                 fontWeight: FontWeight.bold,
  //                                                                                 fontSize: 13,
  //                                                                                 color: Colors.white)),
  //                                                                       ),
  //                                                                     ],
  //                                                                   ),
  //                                                                 ],
  //                                                               ),
  //                                                             ),
  //                                                           ],
  //                                                         )),
  //                                                   ],
  //                                                 ),
  //                                               ),
  //                                             );
  //                                           }),
  //                                       SizedBox(
  //                                         height: 15,
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ))
  //                               : index == 2
  //                                   ? SingleChildScrollView(
  //                                       child: Container(
  //                                       child: Column(
  //                                         children: [
  //                                           GridView.builder(
  //                                               shrinkWrap: true,
  //                                               gridDelegate:
  //                                                   const SliverGridDelegateWithFixedCrossAxisCount(
  //                                                 crossAxisCount: 2,
  //                                               ),
  //                                               physics: ScrollPhysics(),
  //                                               itemCount: productdetails.length,
  //                                               itemBuilder:
  //                                                   (BuildContext context,
  //                                                       int iindex) {
  //                                                 return GestureDetector(
  //                                                   onTap: () {},
  //                                                   child: Container(
  //                                                     margin: EdgeInsets.only(
  //                                                         left: 5, top: 5),
  //                                                     padding: EdgeInsets.all(5),
  //                                                     width:
  //                                                         MediaQuery.of(context)
  //                                                                 .size
  //                                                                 .width /
  //                                                             2,
  //                                                     decoration: BoxDecoration(
  //                                                       color: Colors.black,
  //                                                       // image: DecorationImage(
  //                                                       //     image: NetworkImage(
  //                                                       //         "${productdetails[iindex]["pphoto"]}"),
  //                                                       //     fit: BoxFit.fill),
  //                                                       borderRadius:
  //                                                           BorderRadius.circular(
  //                                                               10),
  //                                                       // boxShadow: [
  //                                                       //   BoxShadow(
  //                                                       //       offset: Offset(0, 0),
  //                                                       //       blurRadius: 0.5,
  //                                                       //       spreadRadius: 0.5,
  //                                                       //       color: Colors.deepOrange
  //                                                       //   ),
  //                                                       // ],
  //                                                     ),
  //                                                     child: Column(
  //                                                       children: <Widget>[
  //                                                         // Image(
  //                                                         //   height: 110,
  //                                                         //   width: 125 ,
  //                                                         //   image:
  //                                                         //   NetworkImage("${productdetails[iindex]["pphoto"]}")
  //                                                         //   ,
  //                                                         //   fit: BoxFit.fill,
  //                                                         // ),
  //                                                         Container(
  //                                                             width: 200,
  //                                                             padding:
  //                                                                 EdgeInsets.only(
  //                                                                     top: 0),
  //                                                             child: Column(
  //                                                               children: [
  //                                                                 Container(
  //                                                                   width: 150,
  //                                                                   child: Column(
  //                                                                     children: <Widget>[
  //                                                                       Align(
  //                                                                           alignment: Alignment
  //                                                                               .bottomLeft,
  //                                                                           child: Text(
  //                                                                               "${productdetails[iindex]["pname"]}",
  //                                                                               style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
  //                                                                       Align(
  //                                                                           alignment: Alignment
  //                                                                               .bottomLeft,
  //                                                                           child: Text(
  //                                                                               "${productdetails[iindex]["pdes"]}",
  //                                                                               style: TextStyle(color: Colors.white, fontSize: 8))),
  //                                                                       Row(
  //                                                                         children: [
  //                                                                           Container(
  //                                                                               height: 30,
  //                                                                               child: Icon(
  //                                                                                 Icons.remove_red_eye,
  //                                                                                 color: Colors.white,
  //                                                                                 size: 20,
  //                                                                               )),
  //                                                                           Container(
  //                                                                             height:
  //                                                                                 30,
  //                                                                             padding:
  //                                                                                 EdgeInsets.only(top: 7),
  //                                                                             child:
  //                                                                                 Text(" ${productdetails[iindex]["view"].toString()}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
  //                                                                           ),
  //                                                                         ],
  //                                                                       ),
  //                                                                     ],
  //                                                                   ),
  //                                                                 ),
  //                                                               ],
  //                                                             )),
  //                                                       ],
  //                                                     ),
  //                                                   ),
  //                                                 );
  //                                               }),
  //                                           SizedBox(
  //                                             height: 15,
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     ))
  //                                   : SingleChildScrollView(
  //                                       child: Container(
  //                                       child: Column(
  //                                         children: [
  //                                           Container(),
  //                                           SizedBox(
  //                                             height: 15,
  //                                           ),
  //                                         ],
  //                                       ),
  //                                     )),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ]),
  //         ),
  //       ));
  
  //   AnimatedContainer buildDot({required int index}) {
  //     return AnimatedContainer(
  //       duration: Duration(milliseconds: 200),
  //       margin: EdgeInsets.only(right: 5),
  //       height: 6,
  //       width: bcurrentPage == index ? 20 : 6,
  //       decoration: BoxDecoration(
  //         color: bcurrentPage == index ? Colors.pink[300] : Colors.grey,
  //         borderRadius: BorderRadius.circular(3),
  //       ),
  //     );
  //   }
  
  //   Future<void> _showMyDialog(String data) async {
  //     return showDialog<void>(
  //       context: context,
  //       barrierDismissible: false, // user must tap button!
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(10))),
  //           title: Align(
  //             alignment: Alignment.topLeft,
  //             child: Container(
  //               height: 40,
  //               // child: Image(
  //               //   image: AssetImage("assets/app_logo.png"),
  //               // ),
  //             ),
  //           ),
  //           content: SingleChildScrollView(
  //             child: ListBody(
  //               children: <Widget>[
  //                 Text(data),
  //               ],
  //             ),
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               child: const Text('Ok'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }
  );
  }
}
