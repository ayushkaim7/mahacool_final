import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_app/LoginScreen.dart';
import 'package:inventory_app/addwarehouse.dart';
import 'package:inventory_app/constants.dart';
import 'package:inventory_app/package_screen.dart';
import 'package:inventory_app/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;


class ContainerScreeen extends StatefulWidget {
  final String pid;

  const ContainerScreeen({
    Key? key,
    required this.pid,
  });

  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<ContainerScreeen> {
  SharedPreferences? sharedPreferences;

  var productdetails;

  Future getHttp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences!.getString("uid")!;
    http.Response presponse;
    presponse = await (http.get(
        Uri.parse('${BASE_URL}api/container/getid?id=' + widget.pid),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));

    setState(() {
      productdetails = json.decode(presponse.body);
    });
  }

  @override
  void initState() {
    super.initState();
    getHttp();
  }

  @override
  Widget build(BuildContext context) {
    if (sharedPreferences == null || productdetails == null) {
      // Show a loading indicator or a blank screen while sharedPreferences is being initialized
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Loading indicator
        ),
      );
    }
    
    
    
    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: Colors.grey[300],
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              // child: Image(
              //   image: AssetImage("assets/Logo.png"),
              // ),
            )
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [
          sharedPreferences!.getString("type") != "manager"
              ? Container()
              // : GestureDetector(
              //     onTap: () {
              //       // Navigator.of(context).push(MaterialPageRoute(
              //       //     builder: (context) => AddContainer(
              //       //           pid: widget.pid,
              //       //         )));
              //     },
              //     child: Container(
              //         padding: EdgeInsets.only(top: 20, right: 20),
              //         child: Text(
              //           "+ Warehouse",
              //           style: TextStyle(color: Colors.grey),
              //         )),
              //   ),
          : IconButton(
            icon: Icon(
              Icons.refresh,
              size: 25,
              color: Colors.black,
            ),
            onPressed: () async {
              getHttp();
            },
          ),
          // IconButton(
          //   icon: Icon(
          //     Icons.logout,
          //     size: 25,
          //     color: Colors.black,
          //   ),
          //   onPressed: () async {
          //     Navigator.of(context).pushReplacement(
          //       MaterialPageRoute(
          //           builder: (BuildContext context) => login_screen()),
          //     );
          //   },
          // ),
        ],
      ),
      body: Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 15),
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                const Align(
                  alignment: Alignment.center,
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'helvetica'
                    ),
                    child: Text("Warehouse"),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25) , ),  
                  ),
                ),
                productdetails == null
                    ? Container() // Show nothing or some other widget if the list is null
                    : productdetails.isEmpty
                        ? Container() // Show nothing or some other widget if the list is empty
                        : Container(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              
                            ),
                            height: MediaQuery.of(context).size.height - 170,
                            width: double.infinity,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: productdetails.length,
                              itemBuilder: (BuildContext context, int iindex) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => PackageScreen(
                                          pid: productdetails[iindex]["_id"],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10 , right: 10),
                                    child: Container(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      child: Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          side: BorderSide(
                                            color: Colors.brown,
                                            width: 1,
                                          ),
                                          
                                        ),
                                        child: ListTile(
                                          leading: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Icon(Icons.warehouse , size: 32  ,)
                                          ),
                                          title: Text(
                                            "${productdetails[iindex]["name"]}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontFamily: 'helvetica'
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 60,
          right: 30,
          child: FloatingActionButton(
            onPressed: () {
               Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddContainer(
                              pid: widget.pid,
                            )));
            },
            child: Icon(Icons.add , size: 30 , color: Colors.white ,),
            backgroundColor: const Color(0xFF1570ef),
            
          ),
        ),
      ],
    ),
  );
}

  Future<void> _showMyDialog(String data) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 40,
              child: Image(
                image: AssetImage("assets/app_logo.png"),
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(data),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
