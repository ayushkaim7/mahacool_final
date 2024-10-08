// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:inventory_app/LoginScreen.dart';
// import 'package:http/http.dart' as http;
// import 'package:inventory_app/client_screen.dart';
// import 'package:inventory_app/constants.dart';
// import 'package:inventory_app/manager_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SignupForm extends StatefulWidget {
//   const SignupForm({super.key});

//   @override
//   State<SignupForm> createState() => _SignupFormState();
// }

// class _SignupFormState extends State<SignupForm> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _gstController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         color: Colors.blueGrey,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   const SizedBox(height: 60),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         "Already a customer?",
//                         style: TextStyle(
//                             fontFamily: 'helvetica',
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => const login_screen(),
//                             ),
//                           );
//                         },
//                         child: const Text(
//                           "Sign in",
//                           style: TextStyle(
//                             fontFamily: 'helvetica',
//                             fontSize: 16,
//                             fontWeight: FontWeight.w500,
//                             color: Color.fromARGB(255, 160, 45, 45),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),

//                   // Name Field
//                   TextFormField(
//                     controller: _nameController,
//                     decoration: InputDecoration(
//                       hintText: 'Name*',
//                       hintStyle: TextStyle(fontFamily: 'helvetica' , fontSize: 16 , color: Colors.white),
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Colors.red.shade300,
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25), 
//                         borderSide: const BorderSide(
//                           color: Colors.black,
//                           width: 2
//                         ) 
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(25),
//                          borderSide: const BorderSide(
//                           color: Colors.black26,
//                           width: 3
//                         )

//                       )
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your name';
//                       }
//                       return null;
//                     },
                    
//                   ),
//                   const SizedBox(height: 20),

//                   // Email Field
//                   TextFormField(
//                     controller: _emailController,
//                     decoration:  InputDecoration(
//                       hintText: 'Email*',
//                       hintStyle: TextStyle(fontFamily: 'helvetica' , fontSize: 16 , color: Colors.white),
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Colors.red.shade300,
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25), 
//                         borderSide: const BorderSide(
//                           color: Colors.black,
//                           width: 2
//                         ) 
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(25),
//                          borderSide: const BorderSide(
//                           color: Colors.black26,
//                           width: 3
//                         )

//                       )
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                         return 'Please enter a valid email address';
//                       }
//                       return null;
//                     },
//                     keyboardType: TextInputType.emailAddress,
//                   ),
//                   const SizedBox(height: 20),

//                   // Password Field
//                   TextFormField(
//                     controller: _passwordController,
//                     decoration: InputDecoration(
//                       hintText: 'Password*',
//                       hintStyle: TextStyle(fontFamily: 'helvetica' , fontSize: 16 , color: Colors.white),
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Colors.red.shade300,
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25), 
//                         borderSide: const BorderSide(
//                           color: Colors.black,
//                           width: 2
//                         ) 
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(25),
//                          borderSide: const BorderSide(
//                           color: Colors.black26,
//                           width: 3
//                         )

//                       )
//                     ),
//                     obscureText: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter a password';
//                       }
//                       if (value.length < 8) {
//                         return 'Password must be at least 8 characters long';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   // Mobile Field
//                   TextFormField(
//                     controller: _mobileController,
//                     decoration: InputDecoration(
//                       hintText: 'Phone*',
//                       hintStyle: TextStyle(fontFamily: 'helvetica' , fontSize: 16 , color: Colors.white),
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Colors.red.shade300,
//                      focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25), 
//                         borderSide: const BorderSide(
//                           color: Colors.black,
//                           width: 2
//                         ) 
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(25),
//                          borderSide: const BorderSide(
//                           color: Colors.black26,
//                           width: 3
//                         )

//                       )
//                     ),
//                     keyboardType: TextInputType.phone,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your mobile number';
//                       }
//                       if (value.length != 10) {
//                         return 'Mobile number must be 10 digits';
//                       }
//                       if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
//                         return 'Please enter a valid mobile number';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   // Address Field
//                   TextFormField(
//                     controller: _addressController,
//                     decoration: InputDecoration(
//                       hintText: 'Address*',
//                       hintStyle: TextStyle(fontFamily: 'helvetica' , fontSize: 16 , color: Colors.white),
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Colors.red.shade300,
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25), 
//                         borderSide: const BorderSide(
//                           color: Colors.black,
//                           width: 2
//                         ) 
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(25),
//                          borderSide: const BorderSide(
//                           color: Colors.black26,
//                           width: 3
//                         )

//                       )
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your address';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   // GST Number Field
//                   TextFormField(
//                     controller: _gstController,
//                     decoration: InputDecoration(
//                       hintText: 'GST Number',
//                       suffixText: '(Optional)',
//                       suffixStyle: TextStyle(color: Colors.white),
//                       hintStyle: TextStyle(fontFamily: 'helvetica' , fontSize: 16 , color: Colors.white),
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Colors.red.shade300,
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25), 
//                         borderSide: const BorderSide(
//                           color: Colors.black,
//                           width: 2
//                         ) 
//                       ),
//                       enabledBorder: OutlineInputBorder(
                        
//                          borderRadius: BorderRadius.circular(25),
//                          borderSide: const BorderSide(
//                           color: Colors.black26,
//                           width: 3
//                         )

//                       )
//                     ),
//                     // validator: (value) {
//                     //   if (value == null || value.isEmpty) {
//                     //     return 'Please enter your GST number';
//                     //   }
//                     //   return null;
//                     // },
//                   ),
//                   SizedBox(height: 20,),
//                   TextFormField(
//                     controller: _gstController,
//                     decoration: InputDecoration(
//                       hintText: 'Company Name',
//                       hintStyle: TextStyle(fontFamily: 'helvetica' , fontSize: 16 , color: Colors.white),
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Colors.red.shade300,
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25), 
//                         borderSide: const BorderSide(
//                           color: Colors.black,
//                           width: 2
//                         ) 
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.circular(25),
//                          borderSide: const BorderSide(
//                           color: Colors.black26,
//                           width: 3
//                         )

//                       )
//                     ),
//                     // validator: (value) {
//                     //   if (value == null || value.isEmpty) {
//                     //     return 'Please enter your GST number';
//                     //   }
//                     //   return null;
//                     // },
//                   ),
//                   const SizedBox(height: 60),

//                   Container(
//                     width: 200,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         String name = _nameController.text.trim();
//                         String email = _emailController.text.trim();
//                         String password = _passwordController.text.trim();  
//                         String mobile = _mobileController.text.trim();
//                         String address = _addressController.text.trim();
//                         SharedPreferences sharedPreferences =
//                               await SharedPreferences.getInstance();
//                           Map data = {
//                             'name': name, 
//                             'email': email,
//                             'password': password,
//                             'mobile': mobile,
//                             'address': address
//                           };

//                           var jsonResponse;
//                             var url = Uri.parse("${BASE_URL}api/client/register");
//                             var response = await http.post(url, body: data);

//                             if (response.statusCode == 200) {
//                               jsonResponse = json.decode(response.body);
//                               print(jsonResponse);
//                               if (jsonResponse != null) {
//                                 // setState(() {
//                                 //   _isLoading = false;
//                                 // });
//                                 Fluttertoast.showToast(
//                                   msg: "Welcome!",
//                                   toastLength: Toast.LENGTH_SHORT,
//                                 );
//                                 sharedPreferences.setString(
//                                     "uid", jsonResponse['_id']);
//                                 sharedPreferences.setString("type", "client");
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) =>
//                                          Managerscreen()));

//                                 // Navigator.of(context).pushAndRemoveUntil(
//                                 //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
//                                 //     (Route<dynamic> route) => false);
//                               }
//                             } else {
//                               // setState(() {
//                               //   _isLoading = false;
//                               // });

//                               //errorMsg = response.body;
//                               Fluttertoast.showToast(
//                                 msg: "${json.decode(response.body)}",
//                                 toastLength: Toast.LENGTH_SHORT,
//                               );
//                               print("The error message is: ${response.body}");
//                             }
//                      },
//                       child: const Text('Sign Up' , style: TextStyle(fontFamily: 'helvetica' , fontSize: 16 , color: Colors.blue , fontWeight: FontWeight.w500),),

//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
