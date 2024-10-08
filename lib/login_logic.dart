import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventory_app/LoginScreen.dart';
import 'package:inventory_app/checkin_screen.dart';
import 'package:inventory_app/client_screen.dart';
import 'package:inventory_app/constants.dart';
import 'package:inventory_app/forgotpassword.dart';
import 'package:inventory_app/manager_screen.dart';
import 'package:inventory_app/navigation_bar.dart';
import 'package:inventory_app/security_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}


class _LoginFormState extends State<LoginForm> {
   bool _isLoading = false;
  var errorMsg;
  bool hideconpass = true;
  List<String> list = <String>['Client', 'Manager', 'Driver', 'Security'];
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController customerid = TextEditingController();
  



  String _selectedvalue = 'Client';



  @override


  void initState() {
    super.initState();
    // emailController.text = "abc@gmail.com";
    // passController.text = "abcd1234";
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20,),
              Container(
  margin: const EdgeInsets.all(4),
  padding: const EdgeInsets.only(left: 20, right: 20),
  height: 70,
  child: LayoutBuilder(
    builder: (context, constraints) {
      // Get the screen width
      double screenWidth = MediaQuery.of(context).size.width;
      // Calculate font size dynamically based on screen width
      double fontSize = screenWidth * 0.045; // Adjust the multiplier as needed

      return TextField(
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'helvetica',
          fontSize: fontSize,  // Adjusted font size
        ),
        controller: emailController,
        decoration: InputDecoration(
          hintText: 'Email / Number / Id',
          hintStyle: TextStyle(
            fontFamily: 'helvetica',
            fontSize: fontSize,  // Adjusted font size
          ),
          prefixIcon: const Icon(Icons.mail),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 2, color: Colors.black26),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 2, color: Color(0xFF0c3e83)),
          ),
        ),
      );
    },
  ),
),
              Container(
  margin: const EdgeInsets.all(4),
  padding: const EdgeInsets.only(left: 20, right: 20),
  height: 70,
  child: LayoutBuilder(
    builder: (context, constraints) {
      // Get the screen width
      double screenWidth = MediaQuery.of(context).size.width;
      // Calculate font size dynamically based on screen width
      double fontSize = screenWidth * 0.045; // Adjust the multiplier as needed

      return TextField(
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'helvetica',
          fontSize: fontSize,  // Adjusted font size
        ),
        controller: passController,
        obscureText: hideconpass,
        decoration: InputDecoration(
          hintText: 'Password',
          suffixIcon: InkWell(
                      onTap: (){
                        if(hideconpass == true){
                          hideconpass = false;
                        }else{
                          hideconpass = true;
                        }
                        setState(() {
                          
                        });
                      },
                      child: const Icon(Icons.visibility),
                    ),
          hintStyle: TextStyle(
            fontFamily: 'helvetica',
            fontSize: fontSize,  // Adjusted font size
          ),
          prefixIcon: const Icon(Icons.mail),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 2, color: Colors.black26),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(width: 2, color: Color(0xFF0c3e83)),
          ),
        ),
      );
    },
  ),
),
              // Container(
              //   margin: const EdgeInsets.all(4),
              //   padding: const EdgeInsets.only(left: 20 , right: 20),
              //   height: 70,
              //   child: TextField(
              //     style: const TextStyle(color: Colors.black , fontFamily: 'helvetica' , fontSize: 18),
              //     controller: passController,
              //     obscureText: hideconpass,
              //     decoration:  InputDecoration(
              //       hintText: 'Password',
                    
              //       suffixIcon: InkWell(
              //         onTap: (){
              //           if(hideconpass == true){
              //             hideconpass = false;
              //           }else{
              //             hideconpass = true;
              //           }
              //           setState(() {
                          
              //           });
              //         },
              //         child: const Icon(Icons.visibility),
              //       ),
              //       hintStyle: const TextStyle(fontFamily: 'helvetica' , fontSize: 18),
              //       prefixIcon: const Icon(Icons.password),
              //       enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         borderSide: const BorderSide( width: 2 , color: Colors.black26)
              //       ),
              //       //fillColor: const Color(0xFF0c3e83),
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         borderSide: const BorderSide( width: 2 , color: Color(0xFF0c3e83)),
                      

              //       ),
                    
              //     ),
              //   ),
              // ),
              
              Padding(
                padding: const EdgeInsets.only(),
                child: InkWell(
                  onTap:() {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Forgotpassword()));
                  },
                  child: const Text("Forgot Password" , style: TextStyle(fontFamily: 'helvetica' , color: Colors.red , decoration: TextDecoration.underline , decorationColor: Colors.red , decorationThickness: 2  ),)),
              ),
              const SizedBox(height: 10,),
              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width -140,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(
                    color: Colors.black26
                  )
                ),
                child: CupertinoButton(
                  child: 
                  LayoutBuilder(
  builder: (context, constraints) {
    // Get the screen width
    double screenWidth = MediaQuery.of(context).size.width;
    // Calculate font size dynamically based on screen width
    double fontSize = screenWidth * 0.048; // Adjust the multiplier as needed

    return Text(
      '$_selectedvalue',
      style: TextStyle(
        fontSize: fontSize,  // Adjusted font size
        fontFamily: 'helvetica',
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  },
),
                   onPressed: ()=> showCupertinoModalPopup(
                    context: context,
                    builder: (_)=> SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: double.infinity,
                      child: CupertinoPicker(
                        backgroundColor: Colors.white,
                        itemExtent: 60,
                        scrollController: FixedExtentScrollController(
                          initialItem: 1
                        ),
                         onSelectedItemChanged: (int index){
                         },
                          children: list.asMap().entries.map((entry){
                            int index = entry.key;
                            String value = entry.value;
                            return GestureDetector(
                              onTap: (){
                                setState(() {
                                  _selectedvalue = value;
                                  print(_selectedvalue);
                                });
                                
                                Navigator.pop(context);
                              },
                              
                              child: Center(child: Text(value , style: const TextStyle(fontFamily: 'helvetica' , fontSize: 20 , fontWeight: FontWeight.w600),),),
                            );
                          }).toList()
                          ),
                    )
                   )
                   
                   ),
              ),
              const  SizedBox(height: 30,),
              Container(
                height: 50,
                width: MediaQuery.of(context).size.width-50 ,
                decoration: BoxDecoration(
                  color: Color(0xFF1366D9),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async{
                      String input = emailController.text.trim();
                      String phone = phoneController.text.trim();
    String pass = passController.text.trim();
    SharedPreferences   sharedPreferences = await SharedPreferences.getInstance();
     const String KEYLOGIN = "login";

    // Determine if the input is an email or phone number
    bool isEmail = RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(input);
  bool isPhoneNumber = RegExp(r'^\d{10}$').hasMatch(input); // Assuming phone numbers are 10 digits
  bool isCustomerID = RegExp(r'^\d{6}$').hasMatch(input);
    
    // Prepare the request URL and data based on the input type
    var url = Uri.parse("${BASE_URL}api/client/login");
    Map<String, String> data = {
      'password': pass,
    };

    if (isEmail) {
    data['email'] = input;
  } else if (isPhoneNumber) {
    data['mobile'] = input;
  } else if (isCustomerID) {
    data['customerID'] = input;
  }
    setState(() {
      _isLoading = true;
    }); 


                          if(_selectedvalue == "Client"){
                            try {
      var response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        
        var jsonResponse = json.decode(response.body);
        if (jsonResponse != null) {
          setState(() {
            _isLoading = false;
          });
          String clientId = jsonResponse['_id'];
          Fluttertoast.showToast(
            msg: "Welcome back!",
            toastLength: Toast.LENGTH_SHORT,
          );
          sharedPreferences.setString("uid", clientId);
          sharedPreferences.setString("type", "client");
          sharedPreferences.setString("clientDetails", json.encode(jsonResponse));

          sharedPreferences.setBool("isLoggedIn", true);

          Navigator.pushReplacement(context, 
                MaterialPageRoute(builder: (context)=> Managerscreen
                (ClientId: clientId, client_Details: jsonResponse)));

        }
      } else {
        // Handle non-200 response status
        Fluttertoast.showToast(
          msg: "Login failed: ${response.reasonPhrase}",
          toastLength: Toast.LENGTH_SHORT,
          
        );
        setState(() {
            _isLoading = false;
          });
      }
    } catch (e) {
      // Handle any errors during the request
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        toastLength: Toast.LENGTH_SHORT,
      );
    }
                          }


                          if (_selectedvalue == "Manager") {
                           try{
                             var jsonResponse;
                            var url = Uri.parse("${BASE_URL}api/manager/login");
                            var response = await http.post(url, body: data);
                            print("response $response");
                            if (response.statusCode == 200) {
                              sharedPreferences.setBool("isLoggedIn", true);
                              print("manager call hogya");
                              jsonResponse = json.decode(response.body);
                              print(jsonResponse);
                              if (jsonResponse != null) {
                                setState(() {
                                  _isLoading = false;
                                  print("success hogya");
                                });
                                Fluttertoast.showToast(
                                  msg: "Welcome back!",
                                  toastLength: Toast.LENGTH_SHORT,
                                );
                                sharedPreferences.setString(
                                    "uid", jsonResponse['_id']);

                                sharedPreferences.setString("type", "manager");
                                

                                String managerEmail = jsonResponse['email'];
                                String managernumber = jsonResponse['mobile'];
                                String managerName = jsonResponse['name'];
                                sharedPreferences.setString("memail", managerEmail);
                                sharedPreferences.setString("mnumber", managernumber);
                                sharedPreferences.setString("mname", managerName);
                                Navigator.pushReplacement(context,
                                 MaterialPageRoute(builder: (context)=>HomePage(
                                  manageremail: managerEmail
                                  , managername: managerName,
                                   managernumber: managernumber)));
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) =>
                                //          HomePage(manageremail: managerEmail, managername: managerName, managernumber: managernumber.toString(),)));

                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
                                //     (Route<dynamic> route) => false);
                              }
                            } else {
                              setState(() {
                                _isLoading = false;
                                Fluttertoast.showToast(
          msg: "Login failed: ${response.reasonPhrase}",
          toastLength: Toast.LENGTH_SHORT,
        );
                              });

                              errorMsg = response.body;
                              Fluttertoast.showToast(
                                msg: "${json.decode(response.body)}",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                              print("The error message is: ${response.body}");
                            }
                           }catch(e){
                            print(' ye hai error ${e.toString()}');
                           }
                          }

                          if (_selectedvalue == "Driver") {
                            var jsonResponse;
                            var url = Uri.parse("${BASE_URL}api/driver/login");
                            var response = await http.post(url, body: data);

                            if (response.statusCode == 200) {
                              jsonResponse = json.decode(response.body);
                              print(jsonResponse);
                              if (jsonResponse != null) {
                                setState(() {
                                  _isLoading = false;
                                });
                                Fluttertoast.showToast(
                                  msg: "Welcome back!",
                                  toastLength: Toast.LENGTH_SHORT,
                                );
                                sharedPreferences.setString(
                                    "uid", jsonResponse['_id']);
                                sharedPreferences.setString("type", "driver");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CheckInScreen()));

                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
                                //     (Route<dynamic> route) => false);
                              }
                            } else {
                              setState(() {
                                _isLoading = false;
                                Fluttertoast.showToast(
          msg: "Login failed: ${response.reasonPhrase}",
          toastLength: Toast.LENGTH_SHORT,
        );
                              });

                              errorMsg = response.body;
                              Fluttertoast.showToast(
                                msg: "${json.decode(response.body)}",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                              print("The error message is: ${response.body}");
                            }
                          }

                          if (_selectedvalue == "Security") {
                            var jsonResponse;
                            var url =
                                Uri.parse("${BASE_URL}api/security/login");
                            var response = await http.post(url, body: data);

                            if (response.statusCode == 200) {
                              jsonResponse = json.decode(response.body);
                              print(jsonResponse);
                              if (jsonResponse != null) {
                                setState(() {
                                  _isLoading = false;
                                });
                                Fluttertoast.showToast(
                                  msg: "Welcome back!",
                                  toastLength: Toast.LENGTH_SHORT,
                                );
                                sharedPreferences.setString(
                                    "uid", jsonResponse['_id']);
                                sharedPreferences.setString("type", "security");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SecurityScreen()));

                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
                                //     (Route<dynamic> route) => false);
                              }
                            } else {
                              setState(() {
                                _isLoading = false;
                                Fluttertoast.showToast(
          msg: "Login failed: ${response.reasonPhrase}",
          toastLength: Toast.LENGTH_SHORT,
        );
                              });

                              errorMsg = response.body;
                              Fluttertoast.showToast(
                                msg: "${json.decode(response.body)}",
                                toastLength: Toast.LENGTH_SHORT,
                              );
                              print("The error message is: ${response.body}");
                            }
                          }
                    },
                    child: _isLoading? CircularProgressIndicator() : Center(child: Text('Login' , style: TextStyle(fontFamily: 'helvetica' , fontSize: 20 , fontWeight: FontWeight.w600,color: Colors.white),)),
                  ),
                ),
              )
        ],
      ),
    );
  }
}