import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/constants.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  TextEditingController email = TextEditingController();
  TextEditingController newpass = TextEditingController();
  TextEditingController otp = TextEditingController();
   bool isotpsent = false;
     bool isLoading = false; // Add this variable



  Future<void> sendPasswordResetRequest(String email) async {

    setState(() {
      isLoading = true;
    });
  // Define the API endpoint
  final url = '${BASE_URL}api/client/password-reset-request';

  // Create the JSON body
  final Map<String, String> body = {
    'email': email,
  };

  try {
    // Make the POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',  // Set content type to JSON
      },
      body: jsonEncode(body),  // Convert the map to a JSON string
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      ///print('Password reset request sent successfully!');
      Fluttertoast.showToast(msg: "Otp sent successfully" , toastLength: Toast.LENGTH_SHORT , gravity: ToastGravity.BOTTOM);
      setState(() {
        isotpsent = true;
      });
    } else {
      //print('Failed to send password reset request: ${response.statusCode}');
      Fluttertoast.showToast(msg: "Please put a valid email" , toastLength: Toast.LENGTH_SHORT , gravity: ToastGravity.BOTTOM);
    }
  } catch (e) {
    print('Error sending password reset request: $e');
  }finally{
    setState(() {
      isLoading = false;
    });
  }
}



Future<void> resetPassword(String email, String otp, String newPassword) async {

  setState(() {
    isLoading = true;
  });
  // Define the API endpoint
  final url = '${BASE_URL}api/client/password-reset';

  // Create the JSON body
  final Map<String, String> body = {
    'email': email,
    'otp': otp,
    'newPassword': newPassword,
  };

  try {
    // Make the POST request
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',  // Set content type to JSON
      },
      body: jsonEncode(body),  // Convert the map to a JSON string
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Show toast on success
      Fluttertoast.showToast(
        msg: "Password reset successful!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      // Show toast on failure
      Fluttertoast.showToast(
        msg: "Failed to reset password: ${response.statusCode}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  } catch (e) {
    // Show toast on error
    Fluttertoast.showToast(
      msg: "Error resetting password: $e",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }finally{
    isLoading = false;
  }
}



 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password' , style: TextStyle(fontFamily: 'helvetica' , fontSize: 22),),
        toolbarHeight: 70,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20 , right: 20),
              child: TextFormField(
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Email' ,
                  hintStyle: TextStyle(fontFamily: 'helvetica' , color: Colors.grey.shade600 , fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder:OutlineInputBorder(borderSide: BorderSide(
                    color: Colors.blue.shade700,
                    width: 2
                  ),
                  borderRadius: BorderRadius.circular(25)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2
                    ),
                    borderRadius: BorderRadius.circular(25)
                  )
                ),
                
              ),
            ),
            const SizedBox(height: 20,),
            if(isotpsent == true)
             Padding(
              padding: const EdgeInsets.only(left: 20 , right: 20),
              child: TextFormField(
                controller: otp,
                decoration: InputDecoration(
                  hintText: 'Otp' ,
                  hintStyle: TextStyle(fontFamily: 'helvetica' , color: Colors.grey.shade600 , fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder:OutlineInputBorder(borderSide: BorderSide(
                    color: Colors.blue.shade700,
                    width: 2
                  ),
                  borderRadius: BorderRadius.circular(25)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2
                    ),
                    borderRadius: BorderRadius.circular(25)
                  )
                ),
                
              ),
            ),
            SizedBox(height: 20,),
            if(isotpsent == true)
             Padding(
              padding: const EdgeInsets.only(left: 20 , right: 20),
              child: TextFormField(
                controller: newpass,
                decoration: InputDecoration(
                  hintText: 'New Password' ,
                  hintStyle: TextStyle(fontFamily: 'helvetica' , color: Colors.grey.shade600 , fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder:OutlineInputBorder(borderSide: BorderSide(
                    color: Colors.blue.shade700,
                    width: 2
                  ),
                  borderRadius: BorderRadius.circular(25)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 2
                    ),
                    borderRadius: BorderRadius.circular(25)
                  )
                ),
                
              ),
             ),

            SizedBox(height: 30,),
            if(isLoading)
              Center(child: CircularProgressIndicator(),)
            else
            InkWell(onTap: (){
              isotpsent ? resetPassword(email.text, otp.text, newpass.text) : sendPasswordResetRequest(email.text);
            }, child:Container(
              height: 60,
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(15)
              ),
              child:  isotpsent ? Center(child: Text("ChangePassword" , style: TextStyle(color: Colors.white , fontFamily: 'helvetica' , fontSize: 22),)) : Center(child: Text("Send OTP" , style: TextStyle(color: Colors.white , fontFamily: 'helvetica' , fontSize: 22),)),
            ))
          ],
        ),
      ),
    );
  }
}