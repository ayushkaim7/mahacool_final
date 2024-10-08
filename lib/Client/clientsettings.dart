import 'package:flutter/material.dart';
import 'package:inventory_app/LoginScreen.dart';
import 'package:inventory_app/update_user_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class SettingsPage extends StatefulWidget {
  final Map<String, dynamic> clientDetails;
  final String Client_id;

  const SettingsPage({super.key, required this.clientDetails , required this.Client_id});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final clientDetails = widget.clientDetails;
    SharedPreferences? sharedPreferences;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
        
            // Centered Card
            Padding(
              padding: const EdgeInsets.only(left: 16 , right: 16 , top: 100 , bottom: 20),
              child: Center(
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blueGrey,
                          child: Text(
                            (clientDetails['name'] ?? 'N').toString()[0].toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 40, fontFamily: 'helvetica'),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          clientDetails['name'] ?? 'No Name',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'helvetica'),
                        ),
                        SizedBox(height: 8),
                        Text(
                          clientDetails['bussinessName'] ?? 'No Business Name',
                          style: TextStyle(fontSize: 18, color: Colors.grey[600], fontFamily: 'helvetica'),
                        ),
                        SizedBox(height: 8),
                        Text(clientDetails['customerID'] , style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'helvetica'),),
                        Divider(thickness: 1),
                        //SizedBox(height: 16),
                        _buildDetailTile(Icons.email, clientDetails['email'] ?? 'No Email'),
                        _buildDetailTile(Icons.phone, clientDetails['mobile'] ?? 'No Mobile'),
                        _buildDetailTile(Icons.location_on, clientDetails['address'] ?? 'No Address'),
                       // _buildDetailTile(Icons.password, clientDetails['password']),
                        SizedBox(height: 16),
                        LayoutBuilder(builder: (context, Constraints){
                          return Text(
                          'GST Number: ${clientDetails['gstNumber'] ?? 'No GST Number'}',
                          style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.04, color: Colors.grey[700], fontFamily: 'helvetica'),
                        );
                        }),
                        SizedBox(height: 5,),
                        TextButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateUserDetails(ClientId: widget.Client_id)));
                        }, child: Text('Update Info' , style: TextStyle(fontFamily: 'helvetica'),) , ),
                        TextButton(onPressed: () async{
                           if (sharedPreferences == null) {
      sharedPreferences = await SharedPreferences.getInstance(); // Lazy initialization
    }
                          sharedPreferences!.setBool("isLoggedIn", false);
                          Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(
    builder: (BuildContext context) => login_screen(),
  ),
  (Route<dynamic> route) => false,  // This ensures all previous routes are removed
);

    //                       Navigator.pushAndRemoveUntil(context,
    // MaterialPageRoute(builder: (context) => login_screen()), // Replace with your login screen widget
    // (Route<dynamic> route) => false,);
                        }, child: Text('Logout' , style: TextStyle(fontFamily: 'helvetica' , color: Colors.red),)
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.25),
              child: Container(
                  height: 150,
                  width: 200,
                  child: Image(image: AssetImage('assets/userinfo.png') , fit: BoxFit.cover,)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueGrey),
      title: LayoutBuilder(builder: (context,Constraints){
        return Text(text , style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.03),
        overflow: TextOverflow.ellipsis,
        );
      }),
      titleTextStyle: TextStyle(fontFamily: 'helvetica', color: Colors.black),
    );
  }
}
