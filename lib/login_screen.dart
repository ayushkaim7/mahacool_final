// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:inventory_app/checkin_screen.dart';
// import 'package:inventory_app/client_screen.dart';
// import 'package:inventory_app/constants.dart';
// import 'package:inventory_app/manager_screen.dart';
// import 'package:inventory_app/security_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool _isLoading = false;
//   var errorMsg;
//   bool hideconpass = true;
//   List<String> list = <String>['Client', 'Manager', 'Driver', 'Security'];
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passController = TextEditingController();
//   String _selectedvalue = 'please select';

//   @override

//   void initState() {
//     super.initState();
//     emailController.text = "abc@gmail.com";
//     passController.text = "abcd1234";
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
//       body: SingleChildScrollView(
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           width: double.infinity,
//           color: //const Color(0xFF93bdf8),
//           Colors.white,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 height: 200,
//                 //width: MediaQuery.of(context).size.width - 120,
//                 color: Colors.transparent,
//                 child: Image.asset('assets/Logo.png' , fit: BoxFit.contain,),
//               ),
//               const SizedBox(height: 30,),
//               Container(
//                 margin: const EdgeInsets.all(4),
//                 padding: const EdgeInsets.only(left: 20 , right: 20),
//                 height: 70,
//                 child: TextField(
//                   style: const TextStyle(color: Colors.black , fontFamily: 'helvetica' , fontSize: 18),
//                   controller: emailController,
//                   decoration:  InputDecoration(
//                     hintText: 'Username',
//                     hintStyle: const TextStyle(fontFamily: 'helvetica' , fontSize: 18),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide( width: 2 , color: Color(0xFF1570ef))
//                     ),
//                     //fillColor: const Color(0xFF0c3e83),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide( width: 2 , color: Color(0xFF0c3e83))
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 margin: const EdgeInsets.all(4),
//                 padding: const EdgeInsets.only(left: 20 , right: 20),
//                 height: 70,
//                 child: TextField(
//                   style: const TextStyle(color: Colors.black , fontFamily: 'helvetica' , fontSize: 18),
//                   controller: passController,
//                   decoration:  InputDecoration(
//                     hintText: 'Password',
//                     hintStyle: const TextStyle(fontFamily: 'helvetica' , fontSize: 18),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide( width: 2 , color: Color(0xFF1570ef))
//                     ),
//                     //fillColor: const Color(0xFF0c3e83),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide( width: 2 , color: Color(0xFF0c3e83)),

//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 height: 60,
//                 width: MediaQuery.of(context).size.width -60,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF629ff4),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: CupertinoButton(
//                   child: 
//                   Text( '$_selectedvalue' , style: const TextStyle(fontSize: 18 , fontFamily: 'helvetica' , color: Colors.black , fontWeight: FontWeight.w600),),
//                    onPressed: ()=> showCupertinoModalPopup(
//                     context: context,
//                     builder: (_)=> SizedBox(
//                       height: 250,
//                       width: double.infinity,
//                       child: CupertinoPicker(
//                         backgroundColor: Colors.white,
//                         itemExtent: 48,
//                         scrollController: FixedExtentScrollController(
//                           initialItem: 1
//                         ),
//                          onSelectedItemChanged: (int index){
//                          },
//                           children: list.asMap().entries.map((entry){
//                             int index = entry.key;
//                             String value = entry.value;
//                             return GestureDetector(
//                               onTap: (){
//                                 setState(() {
//                                   _selectedvalue = value;
//                                   print(_selectedvalue);
//                                 });
                                
//                                 Navigator.pop(context);
//                               },
                              
//                               child: Center(child: Text(value , style: const TextStyle(fontFamily: 'helvetica' , fontSize: 22 , fontWeight: FontWeight.w600),),),
//                             );
//                           }).toList()
//                           ),
//                     )
//                    )
                   
//                    ),
//               ),
//               const SizedBox(height: 40,),
//               Container(
//                 height: 50,
//                 width: 200,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF10a760),
//                   borderRadius: BorderRadius.circular(12)
//                 ),
//                 child: Material(
//                   color: Colors.transparent,
//                   child: InkWell(
//                     onTap: () async{
//                       String email = emailController.text.trim();
//                           String pass = passController.text.trim();
//                           SharedPreferences sharedPreferences =
//                               await SharedPreferences.getInstance();
//                           Map data = {
//                             'email': email,
//                             'password': pass,
//                           };

//                           if (_selectedvalue == "Client") {
//                             var jsonResponse;
//                             var url = Uri.parse("${BASE_URL}api/client/login");
//                             var response = await http.post(url, body: data);

//                             if (response.statusCode == 200) {
//                               jsonResponse = json.decode(response.body);
//                               print(jsonResponse);
//                               if (jsonResponse != null) {
//                                 setState(() {
//                                   _isLoading = false;
//                                 });
//                                 Fluttertoast.showToast(
//                                   msg: "Welcome back!",
//                                   toastLength: Toast.LENGTH_SHORT,
//                                 );
//                                 sharedPreferences.setString(
//                                     "uid", jsonResponse['_id']);
//                                 sharedPreferences.setString("type", "client");
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) =>
//                                         const ClientScreen()));

//                                 // Navigator.of(context).pushAndRemoveUntil(
//                                 //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
//                                 //     (Route<dynamic> route) => false);
//                               }
//                             } else {
//                               setState(() {
//                                 _isLoading = false;
//                               });

//                               errorMsg = response.body;
//                               Fluttertoast.showToast(
//                                 msg: "${json.decode(response.body)}",
//                                 toastLength: Toast.LENGTH_SHORT,
//                               );
//                               print("The error message is: ${response.body}");
//                             }
//                           }

//                           if (_selectedvalue == "Manager") {
//                            try{
//                              var jsonResponse;
//                             var url = Uri.parse("${BASE_URL}api/manager/login");
//                             var response = await http.post(url, body: data);
//                             print("response $response");
//                             if (response.statusCode == 200) {
//                               print("manager call hogya");
//                               jsonResponse = json.decode(response.body);
//                               print(jsonResponse);
//                               if (jsonResponse != null) {
//                                 setState(() {
//                                   _isLoading = false;
//                                   print("success hogya");
//                                 });
//                                 Fluttertoast.showToast(
//                                   msg: "Welcome back!",
//                                   toastLength: Toast.LENGTH_SHORT,
//                                 );
//                                 sharedPreferences.setString(
//                                     "uid", jsonResponse['_id']);

//                                 sharedPreferences.setString("type", "manager");
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) =>
//                                          ClientScreen()));

//                                 // Navigator.of(context).pushAndRemoveUntil(
//                                 //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
//                                 //     (Route<dynamic> route) => false);
//                               }
//                             } else {
//                               setState(() {
//                                 _isLoading = false;
//                               });

//                               errorMsg = response.body;
//                               Fluttertoast.showToast(
//                                 msg: "${json.decode(response.body)}",
//                                 toastLength: Toast.LENGTH_SHORT,
//                               );
//                               print("The error message is: ${response.body}");
//                             }
//                            }catch(e){
//                             print('$e');
//                            }
//                           }

//                           if (_selectedvalue == "Driver") {
//                             var jsonResponse;
//                             var url = Uri.parse("${BASE_URL}api/driver/login");
//                             var response = await http.post(url, body: data);

//                             if (response.statusCode == 200) {
//                               jsonResponse = json.decode(response.body);
//                               print(jsonResponse);
//                               if (jsonResponse != null) {
//                                 setState(() {
//                                   _isLoading = false;
//                                 });
//                                 Fluttertoast.showToast(
//                                   msg: "Welcome back!",
//                                   toastLength: Toast.LENGTH_SHORT,
//                                 );
//                                 sharedPreferences.setString(
//                                     "uid", jsonResponse['_id']);
//                                 sharedPreferences.setString("type", "driver");
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) => CheckInScreen()));

//                                 // Navigator.of(context).pushAndRemoveUntil(
//                                 //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
//                                 //     (Route<dynamic> route) => false);
//                               }
//                             } else {
//                               setState(() {
//                                 _isLoading = false;
//                               });

//                               errorMsg = response.body;
//                               Fluttertoast.showToast(
//                                 msg: "${json.decode(response.body)}",
//                                 toastLength: Toast.LENGTH_SHORT,
//                               );
//                               print("The error message is: ${response.body}");
//                             }
//                           }

//                           if (_selectedvalue == "Security") {
//                             var jsonResponse;
//                             var url =
//                                 Uri.parse("${BASE_URL}api/security/login");
//                             var response = await http.post(url, body: data);

//                             if (response.statusCode == 200) {
//                               jsonResponse = json.decode(response.body);
//                               print(jsonResponse);
//                               if (jsonResponse != null) {
//                                 setState(() {
//                                   _isLoading = false;
//                                 });
//                                 Fluttertoast.showToast(
//                                   msg: "Welcome back!",
//                                   toastLength: Toast.LENGTH_SHORT,
//                                 );
//                                 sharedPreferences.setString(
//                                     "uid", jsonResponse['_id']);
//                                 sharedPreferences.setString("type", "security");
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) => SecurityScreen()));

//                                 // Navigator.of(context).pushAndRemoveUntil(
//                                 //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
//                                 //     (Route<dynamic> route) => false);
//                               }
//                             } else {
//                               setState(() {
//                                 _isLoading = false;
//                               });

//                               errorMsg = response.body;
//                               Fluttertoast.showToast(
//                                 msg: "${json.decode(response.body)}",
//                                 toastLength: Toast.LENGTH_SHORT,
//                               );
//                               print("The error message is: ${response.body}");
//                             }
//                           }
//                     },
//                     child: const Center(child: Text('Login' , style: TextStyle(fontFamily: 'helvetica' , fontSize: 20 , fontWeight: FontWeight.w600),)),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }