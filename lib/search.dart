import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_app/api.dart';
import 'package:inventory_app/model/book.dart';
import 'package:inventory_app/requestbox.dart';
import 'package:inventory_app/search_widget.dart';

class Search extends StatefulWidget {
  @override
  FilterNetworkListPageState createState() => FilterNetworkListPageState();
}

class FilterNetworkListPageState extends State<Search> {
  List<Book> books = [];
  String query = '';
  Timer? debouncer;

  @override
  void initState() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    super.initState();
    init();
  }

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  Future init() async {
    final books = await BooksApi.getBooks(query);
    setState(() => this.books = books);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF4c606b),
          elevation: 0,
          titleSpacing: 0,
          title: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Container(
                height: 80,
                width: 70,
                child: Image(
                  image: AssetImage("assets/app_logo.png"),
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
          automaticallyImplyLeading: false,
          actions: [
            //
            // GestureDetector(
            //   onTap: (){
            //     Navigator.of(context)
            //         .push(MaterialPageRoute(
            //         builder: (context) =>
            //             UploadRack(pid: widget.pid,)
            //     ));
            //   },
            //   child:  Container(
            //       padding: EdgeInsets.only(top: 20, right: 20),
            //       child: Text(
            //         "+ Upload Rack",
            //         style: TextStyle(color: Colors.grey),
            //       )) ,)
            // ,
          ],
        ),
        backgroundColor: Colors.white,
        body: 
        Column(
          
          children: <Widget>[
            buildSearch(),
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return buildBook(book);
                },
              ),
            ),
          ],
        ),
      );

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search Products',
        onChanged: searchBook,

      );

  Future searchBook(String query) async => debounce(() async {
        final books = await BooksApi.getBooks(query);
        if (!mounted) return;
        setState(() {
          this.query = query;
          this.books = books;
        });
      });

  Widget buildBook(Book book) => GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RequestDetails(
            pid: book.id!,
            // cate: book.pcat,
          ),
        ));
      },
      child: ListTile(
        leading: Image.asset(
          'assets/finalbag.png',
          fit: BoxFit.cover,
          width: 50,
          height: 50,
        ),
        title: Text(book.name!),
        subtitle: Text(book.type!),
      ));
}
