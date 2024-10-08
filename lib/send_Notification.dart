import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:inventory_app/constants.dart';

class NotificationFormPage extends StatefulWidget {
  @override
  _NotificationFormPageState createState() => _NotificationFormPageState();
}

class _NotificationFormPageState extends State<NotificationFormPage> {
  final _formKey = GlobalKey<FormState>();

  String customerID = '';
  String message = '';
  int weight = 0;
  String dryFruitName = '';

  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    connectToSocket();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  void connectToSocket() {
    socket = IO.io('${BASE_URL}', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('Connected to the server');
    });

    socket.on('disconnect', (_) {
      print('Disconnected from the server');
    });
  }

  Future<void> sendNotification() async {
    final url = Uri.parse('${BASE_URL}api/notification/add-notification');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'customerID': customerID,
        'message': message,
        'weight': weight,
        'dryFruitName': dryFruitName,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification sent successfully')),
      );

      // Emit the notification to the server via WebSocket
      socket.emit('new-notification', {
        'customerID': customerID,
        'message': message,
        'weight': weight,
        'dryFruitName': dryFruitName,
        'date': DateTime.now().toIso8601String(), // Add date to notification
      });
    } else {
      print('${response.body}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send notification: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Notification' , style: TextStyle(fontFamily: 'helvetica'),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Customer ID' , hintStyle: TextStyle(fontFamily: 'helvetica')),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || !RegExp(r'^\d{6}$').hasMatch(value)) {
                    return 'Please enter a valid 6-digit Customer ID';
                  }
                  return null;
                },
                onSaved: (value) => customerID = value!,
              ),
              SizedBox(height: 15,),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Message' , hintStyle: TextStyle(fontFamily: 'helvetica')),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
                onSaved: (value) => message = value!,
              ),
              SizedBox(height: 15,),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Weight (kg)' , hintStyle: TextStyle(fontFamily: 'helvetica')),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Please enter a valid weight';
                  }
                  return null;
                },
                onSaved: (value) => weight = int.parse(value!),
              ),
              SizedBox(height: 15,),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Dry Fruit Name' , hintStyle: TextStyle(fontFamily: 'helvetica')),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name of the dry fruit';
                  }
                  return null;
                },
                onSaved: (value) => dryFruitName = value!,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4c606b) 
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    sendNotification();
                  }
                },
                child: Text('Send Notification' , style: TextStyle(fontFamily: 'helvetica' , color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
