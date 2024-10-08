import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:inventory_app/constants.dart';
import 'package:inventory_app/manager_screen.dart';

class UpdateUserDetails extends StatefulWidget {
  final String ClientId;

  const UpdateUserDetails({super.key , required this.ClientId});

  @override
  State<UpdateUserDetails> createState() => _UpdateUserDetailsState();
}

class _UpdateUserDetailsState extends State<UpdateUserDetails> {


  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailIdController = TextEditingController();
  final TextEditingController gstnumber = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Container(
              height: 450,
              width: MediaQuery.of(context).size.width - 20,
              decoration: BoxDecoration(
                color: Color(0xFFe3d2b4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10 , top: 8),
                    child: Text("Update Info" , style: TextStyle(fontFamily: 'helvetica' , fontSize: 25),),
                  ),
                  Divider(color:Color(0xFFb4aa93) , endIndent: 180, ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                          hintText: 'New Name',
                          hintStyle: TextStyle(fontFamily: 'helvetica' , fontSize: 16 , color: Colors.white),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color(0xFFb4aa93),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25), 
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2
                            ) 
                          ),
                          enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25),
                             borderSide: const BorderSide(
                              color: Colors.black26,
                              width: 3
                            )
                              
                          )
                        ),
                                  ),
                    
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                                    controller: emailIdController,
                                    decoration: InputDecoration(
                          hintText: 'New Email',
                          hintStyle: TextStyle(fontFamily: 'helvetica' , fontSize: 16 , color: Colors.white),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color(0xFFb4aa93),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25), 
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2
                            ) 
                          ),
                          enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25),
                             borderSide: const BorderSide(
                              color: Colors.black26,
                              width: 3
                            )
                              
                          )
                        ),
                                  ),
                    
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                                    controller: contactNumberController,
                                    decoration: InputDecoration(
                          hintText: 'New Mobile Number',
                          hintStyle: TextStyle(fontFamily: 'helvetica' , fontSize: 16 , color: Colors.white),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color(0xFFb4aa93),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25), 
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2
                            ) 
                          ),
                          enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25),
                             borderSide: const BorderSide(
                              color: Colors.black26,
                              width: 3
                            )
                              
                          )
                        ),
                                  ),
                    
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                                    controller: gstnumber,
                                    decoration: InputDecoration(
                          hintText: 'GST Nummber',
                          hintStyle: TextStyle(fontFamily: 'helvetica' , fontSize: 16 , color: Colors.white),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Color(0xFFb4aa93),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25), 
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2
                            ) 
                          ),
                          enabledBorder: OutlineInputBorder(
                             borderRadius: BorderRadius.circular(25),
                             borderSide: const BorderSide(
                              color: Colors.black26,
                              width: 3
                            )
                              
                          )
                        ),
                                  ),
                    
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child: Container(
                      height: 50,
                      width: 180,
                      child: ElevatedButton(onPressed: () async {
                        Map<String, String> body = {};
    if (nameController.text.isNotEmpty) body['name'] = nameController.text;
    if (emailIdController.text.isNotEmpty) body['email'] = emailIdController.text;
    if (contactNumberController.text.isNotEmpty) body['mobile'] = contactNumberController.text;
    if (gstnumber.text.isNotEmpty) body['gstNumber'] = gstnumber.text;

    try {
      final response = await http.post(
        Uri.parse('${BASE_URL}api/client/update?id=${widget.ClientId}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        // Successfully updated
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update successful')));
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Managerscreen(ClientId: widget.ClientId , clientDetails: ,)));
      } else {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update')));
      }
    } catch (e) {
      // Handle exceptions
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }



                      },
                       child: Text("Continue" , style: TextStyle(fontFamily: 'helvetica' , fontSize: 18 , fontWeight: FontWeight.w800 , color: Colors.black),)
                       
                       ),
                    ),
                  ) 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}