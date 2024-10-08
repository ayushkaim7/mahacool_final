import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class FileListScreen extends StatefulWidget {
  final Map<String, dynamic> customerID;

  const FileListScreen({super.key, required this.customerID});

  @override
  _FileListScreenState createState() => _FileListScreenState();
}

class _FileListScreenState extends State<FileListScreen> {
  late Future<List<FileData>> futureFiles;

  @override
  void initState() {
    super.initState();
    futureFiles = fetchFileData(widget.customerID); // Initial fetch
  }

  Future<void> _refreshFiles() async {
    setState(() {
      futureFiles = fetchFileData(widget.customerID); // Update the futureFiles variable
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder<List<FileData>>(
        future: futureFiles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load files'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var reversedFiles = snapshot.data!.reversed.toList();
                return FileTile(file: reversedFiles[index], customerID: widget.customerID);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshFiles, // Call the refresh method
        child: Icon(Icons.refresh_sharp, color: Colors.white),
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }
}

class FileTile extends StatelessWidget {
  final FileData file;
  final Map<String, dynamic> customerID;

  FileTile({required this.file, required this.customerID});

    _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date: ${file.date.day}-${file.date.month}-${file.date.year}',
              style: TextStyle(fontSize: 16.0),
            ),
            if (file.url != null) // Show icon only if URL exists
              IconButton(
                onPressed: () {
                  _launchURL(file.url!);
                },
                icon: Icon(Icons.picture_as_pdf, color: Colors.red.shade500, size: 28),
              )
            else
              Icon(Icons.error, color: Colors.grey, size: 28),
          ],
        ),
      ),
    );
  }
}

class FileData {
  final String? url;
  final DateTime date;
  final String id;

  FileData({this.url, required this.date, required this.id});

  factory FileData.fromJson(Map<String, dynamic> json) {
    return FileData(
      url: json['url'],
      date: DateTime.parse(json['date']),
      id: json['_id'],
    );
  }
}

Future<List<FileData>> fetchFileData(final Map<String, dynamic> customerID) async {
  final url = Uri.parse('${BASE_URL}api/client/files/${customerID["customerID"]}');
  print("Fetching files from: $url"); // Debug print for the URL
  
  final response = await http.get(url);

  // Print status code and body for debugging
  print("Response status: ${response.statusCode}");
  print("Response body: ${response.body}");

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body)['fileUrls'];
    return jsonResponse.map((file) => FileData.fromJson(file)).toList();
  } else {
    // Print the error details for better understanding
    print("Error: ${response.statusCode} - ${response.body}");
    throw Exception('Failed to load files');
  }
}

