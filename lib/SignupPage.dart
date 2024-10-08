// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:inventory_app/constants.dart';
// import 'package:inventory_app/manager_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:workmanager/workmanager.dart';

// class UserInfoCollectionPage extends StatefulWidget {
//   @override
//   _UserInfoCollectionPageState createState() => _UserInfoCollectionPageState();
// }

// class _UserInfoCollectionPageState extends State<UserInfoCollectionPage> {
//   // Current selected field
//   String selectedField = '';

//   // Controllers for user inputs
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController lastnameController = TextEditingController();
//    final TextEditingController password= TextEditingController();
//   final TextEditingController businessAddressController = TextEditingController();
//   final TextEditingController businessAddress2Controller = TextEditingController();
//   final TextEditingController businessAddress3Controller = TextEditingController();
//   final TextEditingController contactNumberController = TextEditingController();
//   final TextEditingController emailIdController = TextEditingController();
//   final TextEditingController gstnumber = TextEditingController();
//   final TextEditingController companyname = TextEditingController();


//   bool isFieldFilled(String field) {
//     switch (field) {
//       case 'Name':
//         return nameController.text.isNotEmpty || lastnameController.text.isNotEmpty;
//       case 'Email':
//         return emailIdController.text.isNotEmpty;
//       case 'Password':
//         return password.text.isNotEmpty;
//       case 'Mobile':
//         return contactNumberController.text.isNotEmpty;
//       case 'Address':
//         return businessAddressController.text.isNotEmpty || businessAddress2Controller.text.isNotEmpty || businessAddress3Controller.text.isNotEmpty;
//       case 'GST Number':
//         return gstnumber.text.isNotEmpty;
//       case 'Business Name':
//         return companyname.text.isNotEmpty;
//       default:
//         return false;
//     }
//   }

//   // Function to display form fields based on selection
//   Widget getFormField(String field) {
//     bool filled = isFieldFilled(field);

//     switch (field) {
//       case 'Name':
//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               LayoutBuilder(
//   builder: (context, constraints) {
//     // Get the screen width
//     double screenWidth = MediaQuery.of(context).size.width;
//     // Calculate font size dynamically based on screen width
//     double fontSize = screenWidth * 0.03; // Adjust the multiplier as needed

//     return TextFormField(
//       controller: nameController,
//       decoration: InputDecoration(
//         hintText: 'First Name *',
//         hintStyle: TextStyle(
//           fontFamily: 'helvetica',
//           fontSize: fontSize,  // Adjusted font size
//           color: Colors.white,
//         ),
//         border: const OutlineInputBorder(),
//         filled: true,
//         fillColor: const Color(0xFFb4aa93),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(25),
//           borderSide: const BorderSide(
//             color: Colors.black,
//             width: 2,
//           ),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(25),
//           borderSide: const BorderSide(
//             color: Colors.black26,
//             width: 3,
//           ),
//         ),
//       ),
//       validator: (value) {
//         if (value == null || value.isEmpty) {
//           return 'Please enter your name';
//         }
//         return null;
//       },
//     );
//   },
// ),

//               SizedBox(height: 10,),
//               LayoutBuilder(builder: (context , Constraints){
//                 double screenWidth = MediaQuery.of(context).size.width;
//     // Calculate font size dynamically based on screen width
//     double fontSize = screenWidth * 0.03;
//                 return TextFormField(
//                 controller: lastnameController,
//                 decoration: InputDecoration(
//                         hintText: 'Last Name',
//                         hintStyle: TextStyle(fontFamily: 'helvetica' , fontSize: fontSize , color: Colors.white),
//                         border: OutlineInputBorder(),
//                         filled: true,
//                         fillColor: Color(0xFFb4aa93),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(25), 
//                           borderSide: const BorderSide(
//                             color: Colors.black,
//                             width: 2
//                           ) 
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                            borderRadius: BorderRadius.circular(25),
//                            borderSide: const BorderSide(
//                             color: Colors.black26,
//                             width: 3
//                           )
          
//                         )
//                       ),
//               );
//               })
//             ],
//           ),
//         );
//       case 'Address':
//         return Column(
//           children: [
//             TextFormField(
//               controller: businessAddressController,
//               decoration: InputDecoration(
//                       hintText: 'Line1*',
//                       hintStyle: TextStyle(fontFamily: 'helvetica' , fontSize: 16 , color: Colors.white),
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Color(0xFFb4aa93),
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
//               maxLines: 1,
//             ),
//             SizedBox(height: 10,),            TextFormField(
//               controller: businessAddress2Controller,
//               decoration: InputDecoration(
//                       hintText: 'Line2',
//                       hintStyle: TextStyle(fontFamily: 'helvetica' , fontSize: 16 , color: Colors.white),
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Color(0xFFb4aa93),
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
//               maxLines: 1,
//             ),
//             SizedBox(height: 10,),
//             TextFormField(
//               controller: businessAddress3Controller,
//               decoration: InputDecoration(
//                       hintText: 'Line3',
//                       hintStyle: TextStyle(fontFamily: 'helvetica' , fontSize: 16 , color: Colors.white),
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Color(0xFFb4aa93),
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
//               maxLines: 1,
//             ),
//           ],
//         );
//       case 'Mobile':
//   return LayoutBuilder(
//     builder: (context, constraints) {
//       // Get the screen width
//       double screenWidth = MediaQuery.of(context).size.width;
//       // Calculate font size dynamically based on screen width
//       double fontSize = screenWidth * 0.03; // Adjust the multiplier as needed

//       return TextFormField(
//         controller: contactNumberController,
//         decoration: InputDecoration(
//           hintText: 'Phone Number*',
//           hintStyle: TextStyle(
//             fontFamily: 'helvetica',
//             fontSize: fontSize,  // Adjusted font size
//             color: Colors.white,
//           ),
//           border: const OutlineInputBorder(),
//           filled: true,
//           fillColor: const Color(0xFFb4aa93),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(25),
//             borderSide: const BorderSide(
//               color: Colors.black,
//               width: 2,
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(25),
//             borderSide: const BorderSide(
//               color: Colors.black26,
//               width: 3,
//             ),
//           ),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter your mobile number';
//           }
//           if (value.length != 10) {
//             return 'Mobile number must be 10 digits';
//           }
//           if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
//             return 'Please enter a valid mobile number';
//           }
//           return null;
//         },
//         keyboardType: TextInputType.phone,
//       );
//     },
//   );

//       case 'Email':
//         return TextFormField(
//           controller: emailIdController,
//           decoration: InputDecoration(
//                       hintText: 'Email*',
//                       hintStyle: TextStyle(fontFamily: 'helvetica' , fontSize: 16 , color: Colors.white),
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Color(0xFFb4aa93),
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
//           keyboardType: TextInputType.emailAddress,
//         );
//         case 'Password':
//   return LayoutBuilder(
//     builder: (context, constraints) {
//       // Get the screen width
//       double screenWidth = MediaQuery.of(context).size.width;
//       // Calculate font size dynamically based on screen width
//       double fontSize = screenWidth * 0.03; // Adjust the multiplier as needed

//       return TextFormField(
//         controller: password,
//         decoration: InputDecoration(
//           hintText: 'Password*',
//           hintStyle: TextStyle(
//             fontFamily: 'helvetica',
//             fontSize: fontSize,  // Adjusted font size
//             color: Colors.white,
//           ),
//           border: const OutlineInputBorder(),
//           filled: true,
//           fillColor: const Color(0xFFb4aa93),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(25),
//             borderSide: const BorderSide(
//               color: Colors.black,
//               width: 2,
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(25),
//             borderSide: const BorderSide(
//               color: Colors.black26,
//               width: 3,
//             ),
//           ),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter a password';
//           }
//           if (value.length < 8) {
//             return 'Password must be at least 8 characters long';
//           }
//           return null;
//         },
//       );
//     },
//   );

//         case 'GST \nNumber':
//         return LayoutBuilder(builder: (context , Constraints){
//           double screenWidth = MediaQuery.of(context).size.width;
//       // Calculate font size dynamically based on screen width
//       double fontSize = screenWidth * 0.03; 
//           return TextFormField(
//           controller: gstnumber,
//           decoration: InputDecoration(
//                       hintText: 'GST Number*',
//                       hintStyle: TextStyle(fontFamily: 'helvetica' , fontSize: fontSize , color: Colors.white),
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Color(0xFFb4aa93),
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
//           keyboardType: TextInputType.emailAddress,
//         );
//         });
//         case 'Organisation\n Name':
//         return LayoutBuilder(builder: (context , Constraints){
//           double screenWidth = MediaQuery.of(context).size.width;
//       // Calculate font size dynamically based on screen width
//       double fontSize = screenWidth * 0.03; 
//           return TextFormField(
//           controller: companyname,
//           decoration: InputDecoration(
//                       hintText: 'Organisation Name',
//                       hintStyle: TextStyle(fontFamily: 'helvetica' , fontSize: fontSize , color: Colors.white),
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Color(0xFFb4aa93),
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
//           keyboardType: TextInputType.emailAddress,
//         );
//         });
        
//       default:
//         return Center(child: Text('Select a field to edit' , style: TextStyle(fontFamily: 'helvetica'),));
//     }
//   }

//   String collectAndFormatAddress() {
//   // Get the text from each controller
//   String addressLine1 = businessAddressController.text.trim();
//   String addressLine2 = businessAddress2Controller.text.trim();
//   String addressLine3 = businessAddress3Controller.text.trim();

//   // Remove all spaces
//   String formattedAddress = addressLine1.replaceAll(' ', '') +
//                             addressLine2.replaceAll(' ', '') +
//                             addressLine3.replaceAll(' ', '');

//   return formattedAddress;
// }

// String finalname() {
//   // Get the text from each controller
//   String addressLine1 = nameController.text.trim();
//   String addressLine2 = lastnameController.text.trim();
//   // Remove all spaces
//   String formattedname = addressLine1.replaceAll(' ', '') +
//                             addressLine2.replaceAll(' ', '') ;
                            
//   return formattedname;
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFFe3d2b4),
//         //titleTextStyle: TextStyle(fontFamily: 'helvetica' , fontWeight: FontWeight.w600),
//       ),
//       backgroundColor: Color(0xFFe3d2b4),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 0,right: 0),
//           child: Container(
//             height: MediaQuery.of(context).size.height ,
//             width: MediaQuery.of(context).size.width ,
//             decoration: BoxDecoration(
//               color: Color(0xFFe3d2b4),
//               borderRadius: BorderRadius.circular(25)
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 //const SizedBox(height: 10,),
//                 const Padding(
//                   padding:EdgeInsets.only(left: 15),
//                   child: Text("Customer " , style: TextStyle(fontFamily: 'helvetica' , fontSize: 25 , fontWeight: FontWeight.w900),),
//                 ),
//                 const Padding(
//                   padding:  EdgeInsets.only(left: 15),
//                   child: Text("Information" , style: TextStyle(fontFamily: 'helvetica' , fontSize: 25 , fontWeight: FontWeight.w900),),
//                 ),
//                // SizedBox(height: 30,),
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Left side with options
//                     Expanded(
//                       flex: 2,
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 10 ),
//                         child: Container(
//                           height: MediaQuery.of(context).size.height * 0.6,
//                           decoration: const BoxDecoration(
//                             color: Color(0xFFc3beaf),
//                             borderRadius: BorderRadius.only(topLeft: Radius.circular(10) , bottomLeft: Radius.circular(10)),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black12,
//                                 blurRadius: 10,
//                                 offset: Offset(0, 5),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(height: 30,),
//                               buildListTile('Name', Icons.person),
//                               buildListTile('Email', Icons.email),
//                               buildListTile('Password', Icons.password),
//                               buildListTile('Mobile', Icons.phone),
//                               buildListTile('Address', Icons.home),
//                               buildListTile('GST \nNumber', Icons.numbers),
//                               buildListTile('Organisation\n Name', Icons.warehouse),
                              
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                     // Right side with corresponding form fields
//                     Expanded(
//                       flex: 2,
//                       child: Padding(
//                         padding: const EdgeInsets.only(right: 10),
//                         child: Container(
//                           height: MediaQuery.of(context).size.height * 0.6,
//                           padding: EdgeInsets.all(16),
//                           decoration: const BoxDecoration(
//                             color: Color(0xFFc3beaf),
//                             borderRadius: BorderRadius.only(topRight: Radius.circular(10) , bottomRight: Radius.circular(10)),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black12,
//                                 blurRadius: 10,
//                                 offset: Offset(0, 5),
//                               ),
//                             ],
//                           ),
//                           child: getFormField(selectedField),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 15,),
//                 Center(
//                   child: Container(
//                     height: 45,
//                     width: 180,
//                     child: ElevatedButton(onPressed: () async {
//                         String name = finalname();
//                         String email = emailIdController.text.trim();
//                         String passwordText = password.text.trim();  
//                         String mobile = contactNumberController.text.trim();
//                         String address = collectAndFormatAddress();
//                         String businessname = companyname.text.trim();
//                         String GST = gstnumber.text.trim();
//                         SharedPreferences sharedPreferences =
//                               await SharedPreferences.getInstance();
//                           Map data = {
//                             'name': name,
//                             'bussinessName': businessname,
//                             'email': email,
//                             'password': passwordText,
//                             'mobile': mobile,
//                             'address': address,
//                             'gstNumber': GST,
                            
//                           };
//                           print(data);
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
//                                 // String client_id = jsonResponse('_id');                                Fluttertoast.showToast(
//                                 //   msg: "Welcome!",
//                                 //   toastLength: Toast.LENGTH_SHORT,
//                                 // );
//                                 // sharedPreferences.setString(
//                                 //     "uid", jsonResponse['_id']);
//                                 // sharedPreferences.setString("type", "client");

//                                 Fluttertoast.showToast(
//                                 msg: "Profile Created , Please Log in",
//                                 toastLength: Toast.LENGTH_LONG,
//                               );
//                                 // Navigator.of(context).push(MaterialPageRoute(
//                                 //     builder: (context) =>
//                                 //          Managerscreen(ClientId: client_id,  client_Details: jsonResponse,)));

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
                    
//                     }, child: Text("Sign up" , style: TextStyle(fontFamily: 'helvetica' , fontSize: 18 , fontWeight: FontWeight.w900 , color:Colors.black),)),
//                   ),
//                 )
//               ],
        
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper method to build list tiles
//   Widget buildListTile(String field, IconData icon) {
//     bool filled = isFieldFilled(field);
//     return LayoutBuilder(builder: (context , Constraints){
//       double screenWidth = MediaQuery.of(context).size.width;
//       // Calculate font size dynamically based on screen width
//       double fontSize = screenWidth * 0.04;
//       return ListTile(
//       horizontalTitleGap: 7,
//       leading: Container(
//         height: 30,
//         width: 30,
//         decoration: BoxDecoration(
//           color: filled? Colors.blueGrey : Color(0xFF47555b),
//           borderRadius: BorderRadius.circular(20)
//         ),
//         child: Icon(icon, color: Color(0xFF0e1823))),
//       title: Text(
//         field,
//         style:TextStyle(
//           fontSize: fontSize,
//           fontWeight: FontWeight.w900,
//           color: filled? Colors.blueGrey : Color(0xFF47555b),
//           fontFamily: 'helvetica'
//         ),
//         overflow: TextOverflow.ellipsis, // Ensures text truncates instead of overflowing
//           softWrap: false,
//       ),
//       onTap: () {
//         setState(() {
//           selectedField = field;
//         });
//       },
//       trailing: Icon(Icons.arrow_forward_ios, size: 16, color: filled? Colors.blueGrey : Color(0xFF47555b),),
//     );
//     });
//   }
// }

