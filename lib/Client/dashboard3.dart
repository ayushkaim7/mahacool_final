import 'package:flutter/material.dart';
import 'package:inventory_app/Client/dashboard4.dart';
import 'package:workmanager/workmanager.dart';

class Dashboard3 extends StatefulWidget {
  final List<DryFruit> dryFruits;
  final String warehousename;
  final String cityname;
  final Map<String, dynamic> customerID;

  const Dashboard3({
    super.key,
    required this.dryFruits,
    required this.warehousename,
    required this.cityname,
    required this.customerID,
  });

  @override
  State<Dashboard3> createState() => _Dashboard3State();
}

class _Dashboard3State extends State<Dashboard3> {
  late Future<void> _imageLoadFuture;

  @override
  void initState() {
    super.initState();
    _imageLoadFuture = _loadImages();
  }

  Future<void> _loadImages() async {
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF4c606b),
        toolbarHeight: 70,
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            SizedBox(width: 10),
            Container(
              height: 80,
              width: 70,
              child: Image(
                image: AssetImage("assets/app_logo.png"),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 5),
            Text(
              'Customer',
              style: TextStyle(fontFamily: 'helvetica', color: Colors.white),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: widget.dryFruits.where((dryFruit) => dryFruit.quantity > 0).length,
        itemBuilder: (context, index) {
          final filteredDryFruits = widget.dryFruits.where((dryFruit) => dryFruit.quantity > 0).toList();
          return _buildDryFruitCard(filteredDryFruits[index]);
        },
      ),
    );
  }

  Widget _buildDryFruitCard(DryFruit dryFruit) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard4(
              name: dryFruit.name,
              quantity: dryFruit.quantity,
              cityName: widget.cityname,
              warehousename: widget.warehousename,
              customerID: widget.customerID,
            ),
          ),
        );
      },
      child: Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15),
  ),
  elevation: 5,
  margin: EdgeInsets.only(bottom: 20),
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15),
      gradient: LinearGradient(
        colors: [Color(0xFFf7f7f7), Color(0xFFe4e4e4)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    padding: EdgeInsets.all(16),
    child: Row(
      children: [
        if (dryFruit.quantity != 0)
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: const DecorationImage(
                image: AssetImage("assets/dryfruit_logo.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        const SizedBox(width: 20),
        // Use Expanded to make sure text fits within the available space
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(builder: (context , Constraints){
                return Text(
                dryFruit.name,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
                maxLines: 1,  // Limit to 1 line
                overflow: TextOverflow.ellipsis,  // Show ellipsis if overflowed
              );
              }),
              SizedBox(height: 10),
              LayoutBuilder(builder: (context , Constraints){
                return Text(
                '${dryFruit.quantity.toStringAsFixed(2)} kg',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  color: Colors.grey[700],
                ),
              );
              })
            ],
          ),
        ),
      ],
    ),
  ),
),

    );
  }
}

class DryFruit {
  final String name;
  final double quantity; // in kg

  DryFruit({required this.name, required this.quantity});
}
