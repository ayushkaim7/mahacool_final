import 'package:flutter/material.dart';
import 'package:inventory_app/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class NotificationService with ChangeNotifier {
  late IO.Socket socket;
  List<Map<String, dynamic>> _notifications = [];

  List<Map<String, dynamic>> get notifications => _notifications;

  void connectToSocket() {
    socket = IO.io('${BASE_URL}', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('Connected to the server');
    });

    socket.on('new-notification', (data) {
      print('New notification received: $data');
      _notifications.add(data);
      notifyListeners(); // Notify listeners to update the UI
    });

    socket.on('disconnect', (_) {
      print('Disconnected from the server');
    });
  }

  void disconnectFromSocket() {
    socket.disconnect();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}
