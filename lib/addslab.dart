import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventory_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class AddSlab extends StatefulWidget {
  final String pid;

  const AddSlab({
    Key? key,
    required this.pid,
  }) : super(key: key);
  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<AddSlab> {
  late SharedPreferences sharedPreferences;

  TextEditingController emailController = new TextEditingController();
  TextEditingController capController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        elevation: 0,
        leading: Builder(
          builder: (context) => // Ensure Scaffold is in context
              IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        titleSpacing: 0,
        title: Row(
          children: [


            Text("Add Slab" , style: TextStyle(fontSize: 20 , fontFamily: 'helvetica' , fontWeight: FontWeight.w500),)
            // Container(
            //   height: 50,
            //   width: 50,
            //   child: Image(
            //     image: AssetImage("assets/Logo.png"),
            //   ),
            // )
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          // Container(
          //     padding: EdgeInsets.only(top: 20, right: 20),
          //     child: Text(
          //       "+ Cities",
          //       style: TextStyle(color: Colors.grey),
          //     )),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 5, left: 10, right: 10, bottom: 15),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          width: double.infinity,
          child: Column(children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height - 120,
              decoration: BoxDecoration(
                // image: DecorationImage(
                //   image: AssetImage('assets/slab.png'),
                //   fit: BoxFit.contain,
                // ),
              ),
              child: Column(
                children: [
                  // Container(
                  //   height: 50,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(13),
                  //   ),
                  //   child: Row(
                  //       children: [
                  //         GestureDetector(
                  //           onTap: () {
                  //             setState(() {
                  //               currentPage = 0;
                  //             });
                  //           },
                  //           child: AnimatedContainer(
                  //             duration: Duration(milliseconds: 200),
                  //             margin: EdgeInsets.only(right: 5),
                  //             height: 30,
                  //             width: MediaQuery.of(context).size.width / 4 - 20,
                  //             decoration: BoxDecoration(
                  //               color: currentPage == 0
                  //                   ? Colors.pink[200]
                  //                   : Colors.black,
                  //               borderRadius: BorderRadius.circular(13),
                  //             ),
                  //             child: Align(
                  //                 alignment: Alignment.center,
                  //                 child: Text(
                  //                   "Coins",
                  //                   style:
                  //                   TextStyle(fontSize: 10, color: Colors.black, fontWeight:FontWeight.bold),
                  //                 )),
                  //           ),
                  //         ),
                  //
                  //       ]),
                  // ),
                  SizedBox(height: 60),
                  

                  Container(
                    height: 65,
                    margin: EdgeInsets.only(left: 8.0, right: 8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: emailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            
                          ),
                          hintText: "Name ",
                          hintStyle: TextStyle(
                            color: Colors.grey[400] ,
                            //   shadows: [
                            //   Shadow(
                            //     blurRadius: 2.0,
                            //     color: Colors.teal,
                            //     offset: Offset(1.0, 1.0),
                            //   ),
                            // ],
                            fontFamily: 'helvetica',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),

                  Container(
                    height: 65,
                    margin: EdgeInsets.only(left: 8.0, right: 8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: capController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)
                          ),
                          hintText: "Capacity ",
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            //   shadows: [
                            //   Shadow(
                            //     blurRadius: 2.0,
                            //     color: Colors.teal,
                            //     offset: Offset(1.0, 1.0),
                            //   ),
                            // ],
                            fontFamily: 'helvetica',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),



                  SizedBox(height: 20,),
                  GestureDetector(
                      onTap: () async {
                        String name = emailController.text.trim();
                        String cap = capController.text.trim();

                        print(widget.pid);
                        Map data = {
                          'name': name,
                          'tid': widget.pid,
                          'cap': int.parse(cap),
                          'box': 0
                        };
                        var jsonResponse = null;
                        var url = Uri.parse(
                          "${BASE_URL}api/rack/addstory?id=" + widget.pid,
                        );
                        var response = await http.post(url,
                            headers: {"Content-Type": "application/json"},
                            body: json.encode(data));

                        if (response.statusCode == 200) {
                          jsonResponse = json.decode(response.body);
                          print(jsonResponse);
                          if (jsonResponse != null) {
                            Fluttertoast.showToast(
                              msg: "Added!",
                              toastLength: Toast.LENGTH_SHORT,
                            );

                            // Navigator.of(context).pushAndRemoveUntil(
                            //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
                            //     (Route<dynamic> route) => false);
                          }
                        } else {
                          Fluttertoast.showToast(
                            msg: "${json.decode(response.body)}",
                            toastLength: Toast.LENGTH_SHORT,
                          );
                          print("The error message is: ${response.body}");
                        }
                      },
                      
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.only(top: 2, left: 5, right: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                            width: 150,
                            height: 50,
                            padding: EdgeInsets.only(top: 0),
                            child: Column(
                              children: [
                                
                                Container(
                                  width: 150,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        
                                        padding: const EdgeInsets.only(top: 3),
                                        child: const DefaultTextStyle(
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            child: Text(
                                              "Add ",
                                            )),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),  
                                ),
                              ],
                            )),
                      ))
                ],
              ),
            ),
          ]),
        ),
      ));
}


class SliderButton extends StatefulWidget {
  final Function onSubmit;

  const SliderButton({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _SliderButtonState createState() => _SliderButtonState();
}

class _SliderButtonState extends State<SliderButton> {
  double _sliderValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          _sliderValue += details.primaryDelta! / MediaQuery.of(context).size.width;
          if (_sliderValue < 0) _sliderValue = 0;
          if (_sliderValue > 1) _sliderValue = 1;
        });
      },
      onHorizontalDragEnd: (details) {
        if (_sliderValue >= 0.8) {
          widget.onSubmit(); // Call the provided onSubmit function when the slider is moved sufficiently to the right
        }
        setState(() {
          _sliderValue = 0; // Reset slider position
        });
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                _sliderValue >= 0.8 ? "Release to Submit" : "Slide to Submit",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            Align(
              alignment: Alignment.lerp(Alignment.centerLeft, Alignment.centerRight, _sliderValue)!,
              child: Container(
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
