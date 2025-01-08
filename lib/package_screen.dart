import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:inventory_app/addrack.dart';
import 'package:inventory_app/addslab.dart';
import 'package:inventory_app/constants.dart';
import 'package:inventory_app/manager_search_box.dart';
import 'package:inventory_app/rackscreen.dart';
import 'package:inventory_app/search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class PackageScreen extends StatefulWidget {
  final String pid;

  const PackageScreen({
    Key? key,
    required this.pid,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<PackageScreen> {
  SharedPreferences? sharedPreferences;
  
  List productdetails = [];
  
  var storedetails;
  
  var boxdetails;


  @override
  void initState() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    // ]);
    super.initState();
    getHttp();
    productdetails.length;
  }

  Future<void> initializePreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    getHttp();
    getStory(pid);
    getBox(pid);
  }

  Future getHttp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences!.getString("uid")!;
    http.Response sresponse;
    sresponse = await (http
        .get(Uri.parse('${BASE_URL}api/rack/getid?id=${widget.pid}'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }));

    print("hone : ${json.decode(sresponse.body)}");

    setState(() {
      productdetails = json.decode(sresponse.body);
    });
  }

  Future getStory(id) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences!.getString("uid")!;
    http.Response sresponse;
    sresponse = await (http
        .get(Uri.parse('${BASE_URL}api/store/getid?id=$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }));

    setState(() {
      storedetails = json.decode(sresponse.body);
    });
  }

  Future getBox(id) async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences!.getString("uid")!;
    http.Response sresponse;
    sresponse = await (http
        .get(Uri.parse('${BASE_URL}api/box/getid?id=$id'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }));

    setState(() {
      boxdetails = json.decode(sresponse.body);
    });
  }

  

  @override
  void dispose() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          toolbarHeight: 70,
          elevation: 0,
          titleSpacing: 0,
          leading: Builder(
            builder: (context) => // Ensure Scaffold is in context
                IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          automaticallyImplyLeading: false,
          actions: [
             GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddRack(
                                pid: widget.pid,
                              )));
                    },
                    child: Container(
                        padding: const EdgeInsets.only(top: 20, right: 20),
                        child:  LayoutBuilder(builder: (context , Constraints){
                          return Text(
                          "+ Rack",
                          style: TextStyle(color: Colors.black , fontSize: MediaQuery.of(context).size.width * 0.04),
                        );
                        })),
                  ),

            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => SearchPage()));
              },
              child: Container(
                  padding: const EdgeInsets.only(top: 20, right: 20),
                  // ignore: prefer_const_constructors
                  child: LayoutBuilder(builder: (context , Constraints){
                          return Text(
                          "Search Bag",
                          style: TextStyle(color: Colors.black , fontSize: MediaQuery.of(context).size.width * 0.04),
                        );
                        })),
            ),
            IconButton(
              icon: const Icon(
                Icons.refresh,
                size: 25,
                color: Colors.black,
              ),
              onPressed: () async {
                getHttp();
              },
            ),

            //
            // GestureDetector(
            //   onTap: (){
            //     Navigator.of(context)
            //         .push(MaterialPageRoute(
            //         builder: (context) =>
            //             UploadRack(pid: widget.pid,)
            //     ));
            //   },
            //   child:  Container(
            //       padding: EdgeInsets.only(top: 20, right: 20),
            //       child: Text(
            //         "+ Upload Rack",
            //         style: TextStyle(color: Colors.grey),
            //       )) ,)
            // ,
          ],
        ),
        body:Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20,),
                 SizedBox(
                          
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: productdetails.length,
                                itemBuilder:
                                    (BuildContext context, int iindex) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      children: [
                                        Text('Rack Name'),
                                        SizedBox(height: 20,),
                                        Row(
                                          children: [
                                            Align(
                                                alignment: Alignment.topLeft,
                                                child: DefaultTextStyle(
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                    child: Text(
                                                      productdetails[iindex]["name"].toString(),
                                                    ))),
                                            // GestureDetector(
                                            //   onTap: () {
                                            //     Navigator.of(context).push(
                                            //         MaterialPageRoute(
                                            //             builder: (context) =>
                                            //                 AddSlab(
                                            //                   pid: productdetails[
                                            //                       iindex]["_id"],
                                            //                 )));
                                            //   },
                                            //   child: Container(
                                            //       child: const Text(
                                            //     " + Story",
                                            //     style: TextStyle(
                                            //         color: Colors.black45,
                                            //         fontSize: 12),
                                            //   )),
                                            // ),
                                            
                                          ],
                                        ),
                                        const SizedBox(height: 15,),
                                        Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    150,
                                                width: 100,
                                                margin: const EdgeInsets.all(5),
                                                child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const ScrollPhysics(),
                                                    itemCount:
                                                        productdetails[iindex]
                                                                ["story"]
                                                            .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return SingleChildScrollView(
                                                          child: Column(
                                                              children: [
                                                            Container(
                                                                height: 80,
                                                                width: 100,
                                                                // decoration:
                                                                //     BoxDecoration(
                                                                //       color: productdetails[iindex]["story"][index]['box']>10 ?productdetails[iindex]["story"][index]['box'] >20 ?Colors.red.withOpacity(0.5):Colors.yellow.withOpacity(0.5) :Colors.green.withOpacity(0.5) ,
                                                                //   border: Border(
                                                                //     top: const BorderSide(
                                                                //         color: Color.fromRGBO(0, 0, 0, 0.451),
                                                                //         width: 2),
                                                                //     bottom: const BorderSide(
                                                                //             color: Colors
                                                                //                 .black45,
                                                                //             width:
                                                                //                 2),
                                                                //     left: const BorderSide(
                                                                //         color: Colors
                                                                //             .black45,
                                                                //         width: 2),
                                                                //     right: const BorderSide(
                                                                //         color: Colors
                                                                //             .black45,
                                                                //         width: 2),
                                                                //   ),
                                                                // ),
                                                                child: Column(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Text(
                                                                                "  ${productdetails[iindex]["story"][index]['box']}",
                                                                               // style: TextStyle(color: productdetails[iindex]["story"][index]['box'] < productdetails[iindex]["story"][index]['cap'] ? Colors.green : Colors.red, fontSize: 14 , fontWeight: FontWeight.bold),
                                                                              ),
                                                                              Text(
                                                                                "/${productdetails[iindex]["story"][index]['cap']}",
                                                                                style: const TextStyle(color: Colors.red, fontSize: 14 , fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          GestureDetector(
                                                                              onTap:
                                                                                  () async {
                                                                              // Navigator.of(context).push(MaterialPageRoute(builder: (context) => RackScreen(story: index.toString(), sid: productdetails[iindex]["story"][index]["sid"].toString(), storyName: productdetails[iindex]["story"][index]["name"].toString(), rack: productdetails[iindex]["name"].toString(), pid: productdetails[iindex]["_id"])));
                                                                              },
                                                                              child:
                                                                                  Container(
                                                                                height: 50,
                                                                                margin: const EdgeInsets.only(top: 2),
                                                                                // margin: EdgeInsets.only(
                                                                                //     top: 2, left: 5, right: 5),
                                                                                decoration: const BoxDecoration(
                                                                                  image: DecorationImage(
                                                                                    image: AssetImage('assets/finalbag.png'),
                                                                                    fit: BoxFit.contain,
                                                                                  ),
                                                                                  color: Colors.transparent,
                                                                                ),
                                    
                                                                                // decoration: BoxDecoration(
                                                                                //   color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                                                                                //   borderRadius: BorderRadius.circular(1.0),
                                                                                // ),
                                                                                child: const SizedBox(
                                                                                    width: 150,
                                                                                    height: 30,
                                                                                    child: Column(
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          width: 150,
                                                                                          height: 30,
                                                                                          child: Column(
                                                                                            children: <Widget>[],
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    )),
                                                                              )),
                                                                        ],
                                                                      )
                                                                // ListView.builder(
                                                                //     scrollDirection: Axis.vertical,
                                                                //     shrinkWrap: true,
                                                                //     physics: ScrollPhysics(),
                                                                //     itemCount: productdetails[iindex]["story"][index]['box'],
                                                                //     itemBuilder:
                                                                //         (BuildContext context, int ndex) {
                                                                //
                                                                //       return
                                                                //         GestureDetector(
                                                                //             onTap: () async {
                                                                //               Navigator.of(context)
                                                                //                   .push(MaterialPageRoute(
                                                                //                   builder: (context) =>
                                                                //                       Files(pid: productdetails[iindex]["_id"], sid: productdetails[iindex]["story"][index]['sid'], box:  productdetails[iindex]["story"][index]['box'],)
                                                                //               ));
                                                                //             },
                                                                //             child:
                                                                //             Container(
                                                                //               height: 70,
                                                                //               margin: EdgeInsets.only(top: 2),
                                                                //               // margin: EdgeInsets.only(
                                                                //               //     top: 2, left: 5, right: 5),
                                                                //               decoration: BoxDecoration(
                                                                //                 image: DecorationImage(
                                                                //                   image: AssetImage(
                                                                //                       'assets/boxy.png'),
                                                                //                   fit: BoxFit.cover,
                                                                //                 ),
                                                                //
                                                                //                 color: Colors.transparent,
                                                                //
                                                                //               ),
                                                                //
                                                                //               // decoration: BoxDecoration(
                                                                //               //   color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
                                                                //               //   borderRadius: BorderRadius.circular(1.0),
                                                                //               // ),
                                                                //               child:   Container(
                                                                //                   width: 150,
                                                                //                   height: 30,
                                                                //
                                                                //                   child: Column(
                                                                //                     children: [
                                                                //                       Container(
                                                                //                         width: 150,
                                                                //                         height: 30,
                                                                //                         child: Column(
                                                                //                           children: <Widget>[
                                                                //
                                                                //
                                                                //                           ],
                                                                //                         ),
                                                                //                       ),
                                                                //                     ],
                                                                //                   )),
                                                                //             ));
                                                                //     })
                                    
                                                                ),
                                                                const SizedBox(height: 5,),
                                                          ]
                                                          
                                                          )
                                                          );
                                                    }), 
                                              )
                                      ],
                                    ),
                                  );
                                }),
                          ),
              ],
            ),
          ),
        ),
      );
}
