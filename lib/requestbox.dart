import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventory_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestDetails extends StatefulWidget {
  final String pid;

  const RequestDetails({
    Key? key,
    required this.pid,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<RequestDetails> {
  bool _isLoading = false;
  var errorMsg;
  bool hideconpass = true;
  List<String> list = <String>['Client', 'Manager', 'Driver', 'Security'];
  String dropdownValue = 'Client';
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  late SharedPreferences sharedPreferences;
  var productdetails;

  Future getHttp() async {
    print(widget.pid);

    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;

    http.Response presponse;
    presponse = await (http.get(
        Uri.parse('${BASE_URL}api/box/details?id=' + widget.pid),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }));

    setState(() {
      productdetails = json.decode(presponse.body);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHttp();
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.blue.shade200,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Text("Box Details" , style: TextStyle(fontFamily: 'helvetica' , fontSize: 20 , fontWeight: FontWeight.w500),)
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [],
      ),
      body:SingleChildScrollView(
        child: Column(

          children: <Widget>[
            SizedBox(height: 40),
            Container(
              height: 80,
              width: 100,
              color: Colors.transparent,
              child: Image.asset("assets/borafinal.png" , fit: BoxFit.cover,),
              
            ),
            SizedBox(height: 30),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Box IDs \n${widget.pid}",
                style: TextStyle(fontFamily: 'helvetica', fontSize: 16),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              // child: Text(
              //   "Box Details",
              //   style: TextStyle(
              //     fontFamily: 'helvetica',
              //     fontSize: 16,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
            ),
            SizedBox(height: 20,),
            productdetails != null
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text("Box No: ${productdetails['name']}"),
                          subtitle: Text("Box Type: ${productdetails['type']}"),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Warehouse No: ${productdetails['container']}"),
                          subtitle: Text("Rack No: ${productdetails['rack']}"),
                        ),
                        Divider(),
                        ListTile(
                          title: Text("Story No: ${productdetails['story']}"),
                          subtitle: Text("Box Position: ${productdetails['position']}"),
                        ),
                        Divider(),
                      ],
                    ),
                  )
                : Container(),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                width: double.infinity,
                height: 40.0,
                color: Colors.orange,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      String email = emailController.text.trim();
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      var id = sharedPreferences.getString('uid');

                      Map<String, String> data = {
                        'bid': widget.pid,
                        'sid': id!,
                        'time': DateTime.now().toString(),
                        'status': ''
                      };

                      var jsonResponse = null;
                      var url = Uri.parse("${BASE_URL}api/request/add");
                      var response = await http.post(url, body: data);
                      if (response.statusCode == 200) {
                        jsonResponse = json.decode(response.body);
                        print(jsonResponse);
                        if (jsonResponse != null) {
                          Fluttertoast.showToast(
                            msg: "Request Sent!",
                            toastLength: Toast.LENGTH_SHORT,
                          );
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: "${json.decode(response.body)}",
                          toastLength: Toast.LENGTH_SHORT,
                        );
                        print("The error message is: ${response.body}");
                      }
                    },
                    child: Center(
                      child: Text(
                        "Unmount Request",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      );
    
  }
}
