import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventory_app/LoginScreen.dart';
import 'package:inventory_app/constants.dart';
import 'package:inventory_app/history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;


class SecurityScreen extends StatefulWidget {
  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<SecurityScreen> {
  late PageController _myPage;
  late SharedPreferences sharedPreferences;
  List ads = [];

  int currentPage = 0;
  int bcurrentPage = 0;
  var productdetails;
  var superdetails;
  bool tab1 = true;
  bool tab2 = false;
  bool tab3 = false;
  var bannerdetails;
  var catdetails;
  var stringResponse;
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController couponController = TextEditingController();
  List cartsarray = [];
  List cartsqaun = [];
  int subtotal = 0;
  int total = 0;
  int discount = 0;
  String oproduct = "";
  List _ch = ["Check In", "Check Out", "Mumbai"];
  int count = 1;
  var ch;
  int dcharge = 0;
  var enquiryValue = 'Day after tomorrow';
  static final DateTime now = DateTime.now();

  Future getHttp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;
    http.Response sresponse;
    sresponse = await (http.get(
        Uri.parse(
            'https://molten-topic-379204.el.r.appspot.com/api/streams/gettop'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));
    http.Response bresponse;
    bresponse = await (http.get(
        Uri.parse(
            'https://molten-topic-379204.el.r.appspot.com/api/images/getbanners'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));
    http.Response presponse;
    presponse = await (http.get(
        Uri.parse(
            'https://molten-topic-379204.el.r.appspot.com/api/packages/getbanners'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }));

    http.Response caresponse;
    caresponse = await (http.get(
        Uri.parse(
            'https://molten-topic-379204.el.r.appspot.com/api/category/getcategories'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        }));
    setState(() {
      productdetails = json.decode(presponse.body);
      bannerdetails = json.decode(bresponse.body);
      superdetails = json.decode(sresponse.body);
      catdetails = json.decode(caresponse.body);
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
            SizedBox(
              width: 30,
            ),
            Container(
              height: 80,
              width: 70,
              child: Image(
                image: AssetImage("assets/app_logo.png"),
                fit: BoxFit.cover,
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
              Icons.history,
              size: 25,
              color: Colors.black,
            ),
            onPressed: () async {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HistoryScreen()));
            },
          ),
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
      body: SingleChildScrollView(
        child: Container(
  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
  decoration: BoxDecoration(
    color: Colors.blueGrey[100],
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 8,
        offset: Offset(2, 4),
      ),
    ],
  ),
  width: double.infinity,
  child: Column(
    children: <Widget>[
      Container(
        height: MediaQuery.of(context).size.height - 120,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/securityimage.png'),
            fit: BoxFit.contain,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Security",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Text Field with enhanced UI
            Container(
              height: 65,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: TextField(
                style: const TextStyle(color: Colors.black, fontSize: 14),
                controller: emailController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Number of Boxes",
                  hintStyle: TextStyle(
                    color: Colors.teal[700],
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: Icon(
                    Icons.inventory_2_outlined,
                    color: Colors.teal[700],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // "Checked IN" Button with Gradient and Rounded Corners
            GestureDetector(
              onTap: () async {
                // Your logic here
              },
              child: Container(
                height: 50,
                width: 180,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00c6ff), Color(0xFF0072ff)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(2, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Checked IN",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // "Checked OUT" Button with Gradient and Rounded Corners
            GestureDetector(
              onTap: () async {
                // Your logic here
              },
              child: Container(
                height: 50,
                width: 180,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFff416c), Color(0xFFff4b2b)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(2, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  "Checked OUT",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
      ))
  );

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 5),
      height: 6,
      width: bcurrentPage == index ? 20 : 6,
      decoration: BoxDecoration(
        color: bcurrentPage == index ? Colors.pink[300] : Colors.grey,
        borderRadius: BorderRadius.circular(3),
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
                image: AssetImage("assets/martlogo.png"),
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
