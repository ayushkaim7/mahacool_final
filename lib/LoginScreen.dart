import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventory_app/SigninPage.dart';
import 'package:inventory_app/SignupPage.dart';
import 'package:inventory_app/checkin_screen.dart';
import 'package:inventory_app/client_screen.dart';
import 'package:inventory_app/constants.dart';
import 'package:inventory_app/login_logic.dart';
import 'package:inventory_app/manager_screen.dart';
import 'package:inventory_app/newsignuppage.dart';
import 'package:inventory_app/security_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class login_screen extends StatefulWidget {
  const login_screen({super.key});

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
 
   bool isLogin = true;

  void toggleForm() {
    setState(() {
      isLogin = !isLogin;
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
  alignment: Alignment.bottomCenter,
  children: [
    Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topCenter,
      decoration: const BoxDecoration(
        color: Color(0xFF4c606b)
      ),
      child: const Padding(
        padding:  EdgeInsets.only(bottom: 420),
        child: Image(image: AssetImage('assets/app_logo.jpg') ,),
      ),
    ),
    
    Container(
      height: MediaQuery.of(context).size.height * 0.60,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 15,
            offset: Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Container(
              height: 50,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.orange.shade200,
                borderRadius: BorderRadius.circular(40),
                
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!isLogin) toggleForm();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 130,
                      decoration: BoxDecoration(
                        color: isLogin ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: isLogin
                            ? [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: isLogin ? Colors.blue : Colors.black,
                          fontWeight:
                              isLogin ? FontWeight.w600 : FontWeight.w500,
                          fontFamily: 'helvetica',
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (isLogin){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUpPage()));
                      }

                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40,
                      width: 130,
                      decoration: BoxDecoration(
                        color: !isLogin ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: !isLogin
                            ? [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        'Signup',
                        style: TextStyle(
                          fontSize: 18,
                          color: !isLogin ? Colors.blue : Colors.black,
                          fontWeight:
                              !isLogin ? FontWeight.w600 : FontWeight.w500,
                          fontFamily: 'helvetica',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //const SizedBox(height: 20),
          isLogin ? LoginForm() : SignUpPage(),
        ],
      ),
    ),
  ],
),
    );
  }
}



