import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inventory_app/LoginScreen.dart';
import 'package:inventory_app/login_screen.dart';
import 'package:inventory_app/manager_screen.dart';
import 'package:inventory_app/navigation_bar.dart';
import 'package:inventory_app/notification_service.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';



void main() {
  
  runApp(
    // DevicePreview(
    //   enabled: kDebugMode && kIsWeb,
    //   builder: (context)=> ChangeNotifierProvider(create: (_) => NotificationService()..connectToSocket(),
    //   child: method == 1  ? firstMethod.MyApp() : secondMethod.MyApp(),
    //   )
    
    
    
    // )
    ChangeNotifierProvider(
      create: (_) => NotificationService()..connectToSocket(),
      child: const MyApp(),
      )
      
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _isLoggedIn;
  String? clientId;
  Map<String, dynamic>? clientDetails;
  String? type;
  String? managerEmail;
  String? managernumber;
  String? managerName;


  @override
  void initState() {
    super.initState();
    _checkLoginStatus();  // Call this method when the app starts
  }

  // Method to check if the user is logged in
  void _checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isLoggedIn = sharedPreferences.getBool("isLoggedIn");
    type = sharedPreferences.getString("type");

    if (isLoggedIn == true) {
      // User is logged in, retrieve ClientId and client_Details
      if(type == 'client'){
        clientId = sharedPreferences.getString("uid") ?? "";
      String? clientDetailsString = sharedPreferences.getString("clientDetails");

      if (clientDetailsString != null) {
        clientDetails = json.decode(clientDetailsString);
      }

      // Set state to update the UI
      setState(() {
        _isLoggedIn = true;
      });
      }

      if(type == 'manager'){
        managerEmail = sharedPreferences.getString("memail");
        managernumber = sharedPreferences.getString("mnumber");
        managerName = sharedPreferences.getString("mname");

        setState(() {
        _isLoggedIn = true;
      });
        
      }
      
    } else {
      // User is not logged in, remain on the login screen
      setState(() {
        _isLoggedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If still checking login status, show a loading indicator
    if (_isLoggedIn == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: const Color(0xFF1570EF)),
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()), // Show a loading indicator
        ),
      );
    } else if (_isLoggedIn == true && type == 'client') {
      // If logged in, navigate to Managerscreen
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: const Color(0xFF1570EF)),
        home: Managerscreen(
          ClientId: clientId!, 
          client_Details: clientDetails!,
        ),
      );
    }else if(_isLoggedIn == true && type == 'manager'){

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: const Color(0xFF1570EF)),
        home: HomePage(manageremail: managerEmail!, managername: managerName!, managernumber: managernumber!)

      );
    }
    
    
     else {
      // If not logged in, show the login screen
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: const Color(0xFF1570EF)),
        home: const Scaffold(
          body: login_screen(), // Show login screen if not logged in
        ),
      );
    }
  }
}



