import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_app/LoginScreen.dart';
import 'package:inventory_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HistoryScreen extends StatefulWidget {
  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<HistoryScreen> {
  late PageController _myPage;
  late SharedPreferences sharedPreferences;
  List ads = [];
  int currentPage = 0;
  var aproductdetails;
  var productdetails;

  Future getHttp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;
    http.Response aresponse;
    aresponse = await (http
        .get(Uri.parse('${BASE_URL}api/shistory/getid?id=' + id), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }));

    setState(() {
      aproductdetails = json.decode(aresponse.body);
    });
  }

  @override
  void initState() {
    super.initState();
    getHttp();
    _myPage = PageController(initialPage: 1);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade200,
          elevation: 0,
          titleSpacing: 0,
          title: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  size: 25,
                  color: Colors.black,
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              Container(
                height: 50,
                width: 50,
                child: Image(
                  image: AssetImage("assets/Logo.png"),
                ),
              )
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

            IconButton(
              icon: Icon(
                Icons.logout,
                size: 25,
                color: Colors.black,
              ),
              onPressed: () async {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (BuildContext context) => login_screen()),
                );
              },
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height - 100,
          child: Column(
            children: [
              Container(
                height: 50,
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.green[300],
                  borderRadius: BorderRadius.circular(3),
                ),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  GestureDetector(
                    onTap: () {},
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      margin: EdgeInsets.all(5),
                      height: 40,
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "History",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                height: MediaQuery.of(context).size.height - 170,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    child: Container(
                  child: Column(
                    children: [
                      aproductdetails == null
                          ? Container(
                              alignment: Alignment.center,
                              child: Image(
                                image: AssetImage("assets/loadgif.gif"),
                                height: 100,
                                width: 100,
                              ))
                          : aproductdetails.length == 0
                              ? Container(
                                  child: Text(
                                    "Empty",
                                    style: TextStyle(color: Color(0xFF00b207)),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: aproductdetails.length,
                                  itemBuilder:
                                      (BuildContext context, int iindex) {
                                    return GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 20),
                                                padding: EdgeInsets.all(5),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      offset: Offset(0, 5),
                                                      blurRadius: 23,
                                                      spreadRadius: -13,
                                                      color: Colors.grey,
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    SizedBox(width: 30),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width -
                                                              50,
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Row(
                                                            children: [
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomLeft,
                                                                  child: Text(
                                                                      "${aproductdetails[iindex]["status"]}",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .blue,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.bold))),
                                                              SizedBox(
                                                                width: 15,
                                                              ),
                                                            ],
                                                          ),
                                                          Align(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: Text(
                                                                  "Boxes : ${aproductdetails[iindex]["box"]}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold))),
                                                          Align(
                                                              alignment: Alignment
                                                                  .bottomLeft,
                                                              child: Text(
                                                                  "${aproductdetails[iindex]["time"]}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15))),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ));
                                  }),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                )),
              ),
            ],
          ),
        ),
      );

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
      height: 40,
      width: MediaQuery.of(context).size.width / 2 - 10,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.pink : Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
      child: currentPage == index ? Text("Da") : Text("Ad"),
    );
  }
}
