import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/addcity.dart';
import 'package:inventory_app/constants.dart';
import 'package:inventory_app/container.dart';
import 'package:inventory_app/login_screen.dart';
import 'package:inventory_app/manager_See_loc.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({super.key});

  @override
  _ShoppingScreentate createState() => _ShoppingScreentate();
}

class _ShoppingScreentate extends State<ClientScreen> {
  late PageController _myPage;
  late SharedPreferences sharedPreferences;
  List ads = [];
  int currentPage = 0;
  int bcurrentPage = 0;
  List productdetails = [];
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
  final List _ch = ["Delhi", "Haryana", "Mumbai"];
  int count = 1;
  var ch;
  int dcharge = 0;
  var enquiryValue = 'Day after tomorrow';
  static final DateTime now = DateTime.now();
  var productlength;


  @override
  void initState() {
    super.initState();

    getHttp();
    _myPage = PageController(initialPage: 1);
  }
  

  Future getHttp() async {
    sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getString("uid")!;
    print(sharedPreferences.getString("type"));

    http.Response caresponse;
    caresponse =
        await (http.get(Uri.parse('${BASE_URL}api/city/getall'), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }));
    print("response is this ## ${caresponse.body}");
    setState(() {
      productdetails = json.decode(caresponse.body);
      productlength = productdetails.length;

      // if (colorsList.length < productdetails.length) {
      //   for (int i = colorsList.length; i < productdetails.length; i++) {
      //     colorsList.add(Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0));
      //   }
      // }
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
       backgroundColor: Color(0xFF4c606b),
        
        body: SingleChildScrollView(
          
  child: Column(
    
    children: <Widget>[
      Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Padding(
                padding: const EdgeInsets.only(left: 10, right: 10 , top: 60 ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                     // Background color for the tiles
                    padding: const EdgeInsets.only(top: 10 , right: 10, left: 10), // Optional padding
                    height: MediaQuery.of(context).size.height - 155 ,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children:[
                        Column(
                        children: [
                           Padding(
                            padding: EdgeInsets.only(left: 10 ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Cities' , style: TextStyle(fontFamily: 'helvetica' , fontSize: 26 , fontWeight: FontWeight.w600 ,),),
                                //SizedBox(width: 200,),
                                IconButton(onPressed: ()async{
                                  print("theek hai");
                                  getHttp();
                                  print("ye rhi aapki $productdetails");
                                  print("this is $productlength");
                                }, icon: Icon(Icons.refresh))
                              ],
                            ),
                          ),
                          
                          Expanded(
                            child: ListView.builder(
                              itemCount: productdetails.length,
                              itemBuilder: (BuildContext context, int iindex) {
                                // Color boxColor =
                                //     specificColors[iindex % specificColors.length];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => ContainerScreeen(
                                              pid: productdetails[iindex]["_id"],
                                            )));
                                  },
                                  child: Container(
                                    height: 80, // Set the desired height here
                                    margin: const EdgeInsets.symmetric(vertical: 5),
                                    
                                    child: Card(
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1,
                                        )
                                      ),
                                      child: ListTile(
                                        leading: Icon(Icons.location_city_rounded , size: 40,),
                                        title: Text(
                                          "${productdetails[iindex]["name"]}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black,
                                            fontFamily: 'helvetica'
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
                      Positioned(
                        //top: 560,
                        bottom: 20,
                        right: 10,
                        child: Column(
                          children: [
                            TextButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> ShowClientLoc()));
                            }, child: Text('Check\nLocation' , style: TextStyle(
                              fontFamily: 'helvetica' , color: Colors.red.shade400 ,
                               decoration: TextDecoration.underline,
                               decorationThickness: 2,
                               decorationColor: Colors.red,
                               ),)),
                            FloatingActionButton(onPressed: (){
                              print('dab gaya');
                              sharedPreferences.getString("type") == "manager";
                              Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AddCity()));
                            },
                            backgroundColor: const Color(0xFF1570ef),
                            child: const Icon(Icons.add , size: 30 , color: Colors.white ,),
                            ),
                          ],
                        )
                        )
                        
                      ] 
                    ),

                  ),
              ),
        ],
      ),
      
    ],
  ),
),
    );
  }
}