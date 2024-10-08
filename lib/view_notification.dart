import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/constants.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  final String customerID;

  NotificationPage({required this.customerID});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List notifications = [];
  int unreadCount = 0;
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
    connectToSocket();
  }



  Future<void> fetchNotifications() async {
    final url = Uri.parse('${BASE_URL}api/notification/get-notifications?customerID=${widget.customerID}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        notifications = jsonDecode(response.body);
        notifications = notifications.toList();
      });
    } else {
      print('Failed to load notifications: ${response.body}');
    }
  }

  void connectToSocket() {
    socket = IO.io('${BASE_URL}', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('Connected to the server');
    });

    socket.on('new-notification', (data) {
      print('New notification received: $data');
      setState(() {
        notifications.insert(0, data); // Add new notification to the top
        unreadCount += 1; // Increment unread count
      });
    });

    // socket.on('disconnect', (_) {
    //   print('Disconnected from the server');
    // });
  }

  String formatDate(String date) {
    final dateTime = DateTime.parse(date);
    return DateFormat.yMMMd().add_jm().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: Color(0xFF4c606b),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  setState(() {
                    unreadCount = 0; // Reset unread count
                  });
                },
              ),
              if (unreadCount > 0)
                Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Text(
                'No notifications',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    leading: CircleAvatar(
                      backgroundColor: Color(0xFF4c606b),
                      child: Icon(Icons.notifications, color: Colors.white),
                    ),
                    title: Text(
                      notification['message'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.scale, color: Colors.grey),
                              SizedBox(width: 5),
                              Text('Weight: ${notification['weight']} kg'),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.local_offer, color: Colors.grey),
                              SizedBox(width: 5),
                              Text('Dry Fruit: ${notification['dryFruitName']}'),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.grey),
                              SizedBox(width: 5),
                              Text('Date: ${formatDate(notification['date'])}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
