
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventory_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MountDetails extends StatefulWidget {
  final String? pid;
  final String? rname;

  final String? rid;
  final String? sid;
  final int? box;

  final Function() onsuccess;

  final int? position;

  const MountDetails({
    Key? key,
    this.rid,
    this.pid,
    required this.onsuccess,
    this.sid,
    this.rname,
    this.position,
    this.box,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<MountDetails> {
  bool _isLoading = false;
  var errorMsg;
  bool hideconpass = true;
  List<String> list = <String>['Client', 'Manager', 'Driver', 'Security'];
  String dropdownValue = 'Client';
  TextEditingController rackController = new TextEditingController();
  TextEditingController shelfController = new TextEditingController();
  late SharedPreferences sharedPreferences;
  var productdetails;

  Future getHttp() async {
    print(widget.pid);

    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;

    http.Response presponse;
    presponse = await (http.get(
        Uri.parse('${BASE_URL}api/box/details?id=' + widget.pid!),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }));

    print(
        "data come after scan uncolored pdi ${widget.pid!} : ${jsonDecode(presponse.body)}");

    setState(() {
      productdetails = json.decode(presponse.body);
      rackController.text = json.decode(presponse.body)['rack'];
      shelfController.text = json.decode(presponse.body)['story'];
    });

    if (json.decode(presponse.body)['mount'] != null) {
      if (json.decode(presponse.body)['unmount'] == "") {
        Fluttertoast.showToast(
          msg: "Already  Mount!",
          toastLength: Toast.LENGTH_SHORT,
        );

        Navigator.of(context).pop();
      }
    }
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
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        backgroundColor: Colors.green[50],
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              child: const Image(
                image: AssetImage("assets/martlogo.png"),
              ),
            )
          ],
        ),
        automaticallyImplyLeading: false,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.blue[50],
          width: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 200,
              ),
              Container(
                color: Colors.blue[50],
                height: 60,
                child: const Image(
                  image: AssetImage("assets/finalbag.png"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 65,
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(),
                child: Text("Box ID \n ${widget.pid}"),
              ),
              Container(
                height: 65,
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(),
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: rackController,
                  decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      hintText: "Rack No ",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        //   shadows: [
                        //   Shadow(
                        //     blurRadius: 2.0,
                        //     color: Colors.teal,
                        //     offset: Offset(1.0, 1.0),
                        //   ),
                        // ],
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              Container(
                height: 65,
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(),
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: shelfController,
                  decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      hintText: "Shelf No ",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        //   shadows: [
                        //   Shadow(
                        //     blurRadius: 2.0,
                        //     color: Colors.teal,
                        //     offset: Offset(1.0, 1.0),
                        //   ),
                        // ],
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              Container(
                height: 65,
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                padding: const EdgeInsets.all(8.0),
                child: const Text("Box Details"),
              ),
              productdetails != null
                  ? Container(
                      margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "Box No : ${productdetails['name']}\n Box Type : ${productdetails['type']} \nWarehouse No : ${productdetails['container']}\n Rack No : ${productdetails['rack']}\nStory No : ${productdetails['story']}\n "),
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  width: 200,
                  height: 40.0,
                  color: Colors.green,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () async {
                          String rack = rackController.text.trim();
                          String shelf = shelfController.text.trim();

                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          var id = sharedPreferences.getString('uid');

                          Map data1 = {
                            'cid': id,
                            'box': widget.pid,
                            'time': DateTime.now().toString(),
                            'status': 'mountd'
                          };

                          var jsonResponse = null;
                          var url = Uri.parse("$BASE_URL_LOC/mhistory/add");
                          // "${BASE_URL}api/mhistory/add");
                          var response = await http.post(url, body: data1);
                          if (response.statusCode == 200) {
                            jsonResponse = json.decode(response.body);
                            print(jsonResponse);
                            if (jsonResponse != null) {
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              var id = sharedPreferences.getString('uid');
                              Map data = {
                                'mountid': id,
                                'rsid': widget.sid,
                                'rack': rack,
                                'story': shelf,
                                'position': widget.position.toString(),
                                'mount': DateTime.now().toString(),
                                'unmount': "",
                                "unmountid": "",
                              };

                              var jsonResponse = null;
                              var url = Uri.parse(
                                  "$BASE_URL_LOC/box/update?id=" + widget.pid!);
                              // "${BASE_URL}api/box/update?id=" +
                              //     widget.pid!);
                              var response = await http.post(url, body: {
                                "data": jsonEncode(data),
                                "history": jsonEncode(data1),
                              });

                              print("response : data : ${response.body}");
                              if (response.statusCode == 200) {
                                jsonResponse = json.decode(response.body);
                                print(jsonResponse);
                                if (jsonResponse != null) {
                                  Map bdata = {
                                    'id': widget.rid,
                                    'sid': widget.sid,
                                    'box': widget.box! + 1,
                                    'mount': widget.position,
                                  };
                                  print(bdata);

                                  var jsonResponse = null;
                                  var url = Uri.parse(
                                      "${BASE_URL}api/rack/updatestory");
                                  var response = await http.post(url,
                                      headers: {
                                        "Content-Type": "application/json"
                                      },
                                      body: json.encode(bdata));

                                  if (response.statusCode == 200) {
                                    jsonResponse = json.decode(response.body);
                                    print(jsonResponse);
                                    if (jsonResponse != null) {
                                      widget.onsuccess();
                                      Fluttertoast.showToast(
                                        msg: "Mounted!",
                                        toastLength: Toast.LENGTH_SHORT,
                                      );
                                      Navigator.of(context).pop();

                                      // Navigator.of(context).pushAndRemoveUntil(
                                      //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
                                      //     (Route<dynamic> route) => false);
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "${json.decode(response.body)}",
                                      toastLength: Toast.LENGTH_SHORT,
                                    );
                                    print(
                                        "The error message is: ${response.body}");
                                  }

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
                        child: const Center(
                          child: Text(
                            "Mount Box",
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                  ),
                ),
              ),
              const SizedBox(
                height: 400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
