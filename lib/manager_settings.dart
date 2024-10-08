import 'package:flutter/material.dart';
import 'package:inventory_app/LoginScreen.dart';
import 'package:inventory_app/SignupPage.dart';
import 'package:inventory_app/newsignuppage.dart';
import 'package:inventory_app/send_Notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManagerSettings extends StatefulWidget {
  final String Mname;
  final String Memail;
  final String Mnumber;

  const ManagerSettings({super.key, required this.Mname, required this.Memail, required this.Mnumber});

  @override
  State<ManagerSettings> createState() => _ManagerSettingsState();
}

class _ManagerSettingsState extends State<ManagerSettings> {

  SharedPreferences? sharedPreferences;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        titleTextStyle: TextStyle(fontFamily: 'helvetica', fontSize: 20),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView( // Make body scrollable
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Add padding to the whole body
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Manager Info Card
                Container(
                  constraints: BoxConstraints(
                    maxWidth: 600, // Set a max width for larger screens
                  ),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildInfoRow("Manager Name:", widget.Mname),
                          _buildInfoRow("Manager Email:", widget.Memail),
                          _buildInfoRow("Manager Mobile:", widget.Mnumber.toString()),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Create Customer Button
                SizedBox(
                  width: double.infinity, // Full-width button
                  height: 50, // Fixed height
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                    },
                    icon: const Icon(Icons.person_add, color: Colors.white),
                    label: const Text(
                      "Create Customer",
                      style: TextStyle(fontSize: 18, fontFamily: 'helvetica', color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.blueAccent,
                      elevation: 5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationFormPage()));
                  },
                  child: const Text(
                    'Send Notification',
                    style: TextStyle(
                      fontFamily: 'helvetica',
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Logout Button
                TextButton.icon(
                  onPressed: () async{
                     if (sharedPreferences == null) {
      sharedPreferences = await SharedPreferences.getInstance(); // Lazy initialization
    }
                    sharedPreferences?.setBool("isLoggedIn", false);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => login_screen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.redAccent, fontSize: 18, fontFamily: 'helvetica'),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
            fontFamily: 'helvetica',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontFamily: 'helvetica',
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
