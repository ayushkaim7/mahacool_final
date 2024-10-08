
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:inventory_app/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PickedDetails extends StatefulWidget {
  final String pid;

  const PickedDetails({
    Key? key,
    required this.pid,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<PickedDetails> {
  final bool _isLoading = false;
  var errorMsg;
  bool hideconpass = true;
  List<String> list = <String>['Client', 'Manager', 'Driver', 'Security'];
  String dropdownValue = 'Client';
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  late SharedPreferences sharedPreferences;
  var productdetails;

  Future getHttp() async {
    print(widget.pid);

    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;

    http.Response presponse;
    presponse = await (http.get(
        Uri.parse('${BASE_URL}api/box/details?id=${widget.pid}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        }));

    setState(() {
      productdetails = json.decode(presponse.body);
    });

    if (json.decode(presponse.body)['picked'] != null) {
      if (json.decode(presponse.body)['deliver'] == "") {
        Fluttertoast.showToast(
          msg: "Already  Picked!",
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
        title: const Row(
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Image(
                image: AssetImage("assets/martlogo.png"),
              ),
            )
          ],
        ),
        automaticallyImplyLeading: false,
        actions: const [],
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
                  image: AssetImage("assets/box.png"),
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
                child: Text("Box ID \n${widget.pid}"),
              ),

              Container(
                height: 65,
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                padding: const EdgeInsets.all(8.0),
                child: const Text("Box Details"),
              ),

              productdetails != null
                  ? Container(
                      height: 65,
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
                  color: Colors.yellow,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () async {
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          var id = sharedPreferences.getString('uid');

                          Map data = {
                            'cid': id,
                            'box': widget.pid,
                            'time': DateTime.now().toString(),
                            'status': 'picked'
                          };

                          var jsonResponse;
                          var url = Uri.parse("${BASE_URL}api/dhistory/add");
                          var response = await http.post(url, body: data);
                          print("response123: ${response.statusCode}");
                          if (response.statusCode == 200) {
                            jsonResponse = json.decode(response.body);
                            print(jsonResponse);
                            if (jsonResponse != null) {
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              var id = sharedPreferences.getString('uid');

                              Map data = {
                                'pickedid': id,
                                'picked': DateTime.now().toString(),
                                'deliver': ""
                              };

                              var jsonResponse;
                              var url = Uri.parse(
                                  "${BASE_URL}api/box/update?id=${widget.pid}");
                              print("data: $data");
                              var response = await http.post(
                                url,
                                body: data,
                              );
                              print("response: ${response.body}");
                              if (response.statusCode == 200) {
                                jsonResponse = json.decode(response.body);
                                print(jsonResponse);
                                if (jsonResponse != null) {
                                  Fluttertoast.showToast(
                                    msg: "Picked!",
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
                            "Box Picked",
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
