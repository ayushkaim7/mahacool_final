import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventory_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class FileDetails extends StatefulWidget {
  final String pid;

  final String rid;
  final String sid;
  final int box;
  final Function() onsuccess;
  final int position;

  const FileDetails({
    Key? key,
    required this.rid,
    required this.position,
    required this.pid,
    required this.onsuccess,
    required this.sid,
    required this.box,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<FileDetails> {
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
    print("rsiddd : ${json.decode(presponse.body)} and sid ${widget.sid}");
    if (json.decode(presponse.body)['rsid'] != widget.sid) {
      Fluttertoast.showToast(
        msg: "Wrong rack Box!",
        toastLength: Toast.LENGTH_SHORT,
      );

      Navigator.of(context).pop();
    } else {
      if (json.decode(presponse.body)['position'] !=
          widget.position.toString()) {
        Fluttertoast.showToast(
          msg: "Wrong  position Box!",
          toastLength: Toast.LENGTH_SHORT,
        );

        Navigator.of(context).pop();
      }
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
                  image: AssetImage("assets/borafinal.png"),
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
                child: Text("Box ID \n${{widget.pid}}"),
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
                          "Box No : ${productdetails['name']} \n Box Type : ${productdetails['type']} \nWarehouse No : ${productdetails['container']}\n Rack No : ${productdetails['rack']}\nStory No : ${productdetails['story']}\n  Box Position : ${productdetails['position']}"),
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              ),

              const SizedBox(
                height: 20,
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 40),
              //   child: Container(
              //     width: 200,
              //     height: 40.0,
              //     color: Color(0xFF007b34),
              //     child: Material(
              //       color: Colors.transparent,
              //       child: InkWell(
              //           onTap: () async {
              //             Navigator.of(context)
              //                 .push(MaterialPageRoute(
              //                 builder: (context) =>
              //                     GenerateQRPage(pid:"file")
              //             ));
              //           },
              //           child: Center(
              //             child: Text(
              //               "Generate QR",
              //               style: TextStyle(
              //                   fontSize: 11,
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.bold),
              //             ),
              //           )),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 40),
              //   child: Container(
              //     width: 200,
              //     height: 40.0,
              //     color: Color(0xFF007b34),
              //     child: Material(
              //       color: Colors.transparent,
              //       child: InkWell(
              //           onTap: () async {
              //             Navigator.of(context)
              //                 .push(MaterialPageRoute(
              //                 builder: (context) =>
              //                     Invoice(pid:"file")
              //             ));
              //           },
              //           child: Center(
              //             child: Text(
              //               "Generate Invoice",
              //               style: TextStyle(
              //                   fontSize: 11,
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.bold),
              //             ),
              //           )),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),  // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 40),
              //   child: Container(
              //     width: 200,
              //     height: 40.0,
              //     color: Color(0xFF007b34),
              //     child: Material(
              //       color: Colors.transparent,
              //       child: InkWell(
              //           onTap: () async {
              //             Navigator.of(context)
              //                 .push(MaterialPageRoute(
              //                 builder: (context) =>
              //                     GenerateQRPage(pid:"file")
              //             ));
              //           },
              //           child: Center(
              //             child: Text(
              //               "Generate QR",
              //               style: TextStyle(
              //                   fontSize: 11,
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.bold),
              //             ),
              //           )),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // Padding(
              //   padding: EdgeInsets.symmetric(horizontal: 40),
              //   child: Container(
              //     width: 200,
              //     height: 40.0,
              //     color: Color(0xFF007b34),
              //     child: Material(
              //       color: Colors.transparent,
              //       child: InkWell(
              //           onTap: () async {
              //             Navigator.of(context)
              //                 .push(MaterialPageRoute(
              //                 builder: (context) =>
              //                     Invoice(pid:"file")
              //             ));
              //           },
              //           child: Center(
              //             child: Text(
              //               "Generate Invoice",
              //               style: TextStyle(
              //                   fontSize: 11,
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.bold),
              //             ),
              //           )),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                  width: 200,
                  height: 40.0,
                  color: Colors.red,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () async {
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          var id = sharedPreferences.getString('uid');

                          Map data1 = {
                            'cid': id,
                            'box': widget.pid,
                            'time': DateTime.now().toString(),
                            'status': 'unmountd'
                          };

                          var jsonResponse = null;
                          var url = Uri.parse("${BASE_URL_LOC}/mhistory/add");
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
                                'unmountid': id,
                                "position": "",
                                "mount": "",
                                "mountid": "",
                                'unmount': DateTime.now().toString(),
                              };

                              var jsonResponse = null;
                              var url = Uri.parse(
                                  // "${BASE_URL}api/box/update?id=" +
                                  "$BASE_URL_LOC/box/update?id=" + widget.pid);

                              var response = await http.post(url, body: {
                                "data": jsonEncode(data),
                                "history": jsonEncode(data1),
                              });
                              if (response.statusCode == 200) {
                                jsonResponse = json.decode(response.body);
                                print(jsonResponse);
                                if (jsonResponse != null) {
                                  Map bdata = {
                                    'id': widget.rid,
                                    'sid': widget.sid,
                                    'box': widget.box - 1,
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
                                    widget.onsuccess();
                                    if (jsonResponse != null) {
                                      Fluttertoast.showToast(
                                        msg: "Unmounted!",
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

                          // String name= emailController.text.trim();
                          //
                          // Map data = {
                          //   'name': name,
                          //   'aid' :'',
                          //   'cid' : widget.pid
                          //
                          // };
                          //
                          // print(data);
                          //
                          // var jsonResponse = null;
                          // var url = Uri.parse(
                          //     "${BASE_URL}api/box/add");
                          // var response = await http.post(url, body: data);
                          //
                          // if (response.statusCode == 200) {
                          //   jsonResponse = json.decode(response.body);
                          //   if (jsonResponse != null) {
                          //
                          //     Map bdata = {
                          //       'id': widget.pid,
                          //       'sid' : widget.pid,
                          //       'box' : widget.pid,
                          //
                          //     };
                          //     print(bdata);
                          //
                          //     var jsonResponse = null;
                          //     var url = Uri.parse(
                          //         "${BASE_URL}api/rack/updatestory");
                          //     var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: json.encode(bdata));
                          //
                          //     if (response.statusCode == 200) {
                          //       jsonResponse = json.decode(response.body);
                          //       print(jsonResponse);
                          //       if (jsonResponse != null) {
                          //
                          //         Fluttertoast.showToast(
                          //           msg: "Box Unmounted!",
                          //           toastLength: Toast.LENGTH_SHORT,
                          //         );
                          //
                          //
                          //
                          //         // Navigator.of(context).pushAndRemoveUntil(
                          //         //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
                          //         //     (Route<dynamic> route) => false);
                          //       }
                          //     } else {
                          //
                          //       Fluttertoast.showToast(
                          //         msg: "${json.decode(response.body)}",
                          //         toastLength: Toast.LENGTH_SHORT,
                          //       );
                          //       print("The error message is: ${response.body}");
                          //     }
                          //
                          //
                          //     // Navigator.of(context).pushAndRemoveUntil(
                          //     //     MaterialPageRoute(builder: (BuildContext context) => Navigation()),
                          //     //     (Route<dynamic> route) => false);
                          //   }
                          // } else {
                          //
                          //   Fluttertoast.showToast(
                          //     msg: "${json.decode(response.body)}",
                          //     toastLength: Toast.LENGTH_SHORT,
                          //   );
                          //   print("The error message is: ${response.body}");
                          // }
                        },
                        child: const Center(
                          child: Text(
                            "Unmount Box",
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
