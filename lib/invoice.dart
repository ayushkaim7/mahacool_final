import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:inventory_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
//import 'package:simple_animations/stateless_animation/mirror_animation.dart';

class InvoiceView extends StatefulWidget {
  final int oid;
  const InvoiceView({Key? key, required this.oid}) : super(key: key);
  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<InvoiceView> {
  late PageController _myPage;
  late SharedPreferences sharedPreferences;
  List ads = [];
  int? selectedValue1;
  int currentPage = 0;
  var productdetails;

  Future getHttp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("email")!;

    http.Response bresponse;
    bresponse = await (http
        .get(Uri.parse('${BASE_URL}api/invoices/getid?id=' + id), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }));

    setState(() {
      productdetails = json.decode(bresponse.body)[widget.oid];
    });
    print('${productdetails}');
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
        backgroundColor: Colors.yellow[50],
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              child: Image(
                image: AssetImage("assets/martlogo.png"),
              ),
            )
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              productdetails == null
                  ? Container(
                      alignment: Alignment.center,
                      child: Image(
                        image: AssetImage("assets/loadgif.gif"),
                        height: 100,
                        width: 100,
                      ))
                  : Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
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
                            width: MediaQuery.of(context).size.width - 50,
                            padding: EdgeInsets.only(top: 10),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: [
                                    Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                            "${productdetails["creationDate"]}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold))),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    // Align(
                                    //     alignment: Alignment.bottomLeft,
                                    //     child: Text(
                                    //         "₹ ${productdetails["oprice"]}",
                                    //         style: TextStyle(
                                    //             color: Colors.black,
                                    //             fontSize: 15,
                                    //             fontWeight: FontWeight.bold))),
                                  ],
                                ),
                                Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                        "Invoice #${productdetails["invoiceId"]}",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold))),

                                // Align(
                                //     alignment: Alignment.bottomLeft,
                                //     child: Text(
                                //         "${productdetails["ostatus"]}",
                                //         style: TextStyle(
                                //             color: Colors.blue, fontSize: 15))),
                                Divider(color: Colors.black),

                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: ScrollPhysics(),
                                    itemCount:
                                        productdetails["products"].length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
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
                                                  child: Row(
                                                    children: <Widget>[
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            60,
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                        child: Column(
                                                          children: [
                                                            Align(
                                                                alignment: Alignment
                                                                    .bottomLeft,
                                                                child: Text(
                                                                    "Items #${(index + 1).toString()}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold))),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                        "Quantity:",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 15))),
                                                                Expanded(
                                                                    child:
                                                                        SizedBox(
                                                                  width: 10,
                                                                )),
                                                                Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                        "${productdetails["products"][index]['qty'].toString()}",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 15))),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                        "Description:",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 15))),
                                                                Expanded(
                                                                    child:
                                                                        SizedBox(
                                                                  width: 10,
                                                                )),
                                                                Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                        " ${productdetails["products"][index]['description'].toString()}",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 15))),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                        "Unit Price: ",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 15))),
                                                                Expanded(
                                                                    child:
                                                                        SizedBox(
                                                                  width: 10,
                                                                )),
                                                                Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                        " ${productdetails["products"][index]['uprice'].toString()}",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 15))),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                        "Partial Payment(%Done):",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 15))),
                                                                Expanded(
                                                                    child:
                                                                        SizedBox(
                                                                  width: 10,
                                                                )),
                                                                Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                        "${productdetails["products"][index]['ppayment'].toString()}",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 15))),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Divider(
                                                              height: 3,
                                                            ),
                                                            Divider(
                                                              height: 3,
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                        "Total Price:",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 15))),
                                                                Expanded(
                                                                    child:
                                                                        SizedBox(
                                                                  width: 10,
                                                                )),
                                                                Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                        "  ${productdetails["products"][index]['total'].toString()}",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 15))),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                        "Remaining Amount:",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 15))),
                                                                Expanded(
                                                                    child:
                                                                        SizedBox(
                                                                  width: 10,
                                                                )),
                                                                Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topLeft,
                                                                    child: Text(
                                                                        "  ${productdetails["products"][index]['remain'].toString()}",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize: 15))),
                                                              ],
                                                            ),
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
                                  height: 50,
                                ),
                                Divider(color: Colors.black),
                                SizedBox(
                                  height: 50,
                                ),
                                Align(
                                    alignment: Alignment.center,
                                    child: Text("Thank You for your business!",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15))),
                                SizedBox(height: 50),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ));

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: currentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: currentPage == index ? Colors.pink : Colors.grey,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  void onChange1(int value) {
    setState(() {
      selectedValue1 = value;
    });
  }
}
