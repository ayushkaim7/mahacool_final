import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventory_app/Deliver_Scan.dart';
import 'package:inventory_app/LoginScreen.dart';
import 'package:inventory_app/Pick_Scan.dart';
import 'package:inventory_app/checkin_screen.dart';
import 'package:inventory_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;


class DriverScreen extends StatefulWidget {
  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<DriverScreen> {
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
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController countryController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController pincodeController = new TextEditingController();
  TextEditingController couponController = new TextEditingController();
  List cartsarray = [];
  List cartsqau = [];
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
        backgroundColor: Color(0xFF4c606b),
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
      backgroundColor: Colors.white,
      body:SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/driverimage.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildActionButton(
                context,
                icon: Icons.local_shipping,
                label: 'Picked',
                color: Colors.deepPurple,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => PickScan()));
                },
              ),
              SizedBox(height: 15),
              _buildActionButton(
                context,
                icon: Icons.delivery_dining,
                label: 'Deliver',
                color: Colors.grey,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => DeliverScan()));
                },
              ),
              SizedBox(height: 15),
              _buildActionButton(
                context,
                icon: Icons.exit_to_app,
                label: 'Check Out',
                color: Colors.redAccent,
                onTap: () async {
                  String email = emailController.text.trim();
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        var id = sharedPreferences.getString('uid');

                        Map data = {
                          'cid': id,
                          'box': '',
                          'time': DateTime.now().toString(),
                          'status': 'checkout'
                        };

                        var jsonResponse = null;
                        var url = Uri.parse("${BASE_URL}api/dhistory/add");
                        var response = await http.post(url, body: data);
                        if (response.statusCode == 200) {
                          jsonResponse = json.decode(response.body);
                          print(jsonResponse);
                          if (jsonResponse != null) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CheckInScreen()));

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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
          gradient: LinearGradient(
            colors: [color.withOpacity(0.9), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),);

//   AnimatedContainer buildDot({required int index}) {
//     return AnimatedContainer(
//       duration: Duration(milliseconds: 200),
//       margin: EdgeInsets.only(right: 5),
//       height: 6,
//       width: bcurrentPage == index ? 20 : 6,
//       decoration: BoxDecoration(
//         color: bcurrentPage == index ? Colors.pink[300] : Colors.grey,
//         borderRadius: BorderRadius.circular(3),
//       ),
//     );
//   }

//   Future<void> _showMyDialog(String data) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false, // user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//           title: Align(
//             alignment: Alignment.topLeft,
//             child: Container(
//               height: 40,
//               child: Image(
//                 image: AssetImage("assets/martlogo.png"),
//               ),
//             ),
//           ),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text(data),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Ok'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
  }