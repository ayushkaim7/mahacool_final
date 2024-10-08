import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:inventory_app/constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';




class InvoiceService {
  // Fetch invoice data from the API
  static Future<Map<String, dynamic>> fetchInvoiceData(String customerId) async {
    final response = await http.get(
      Uri.parse('${BASE_URL}api/MonthlyInvoice/getByCustomerId/$customerId'),
    );
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load invoice data');
    }
  }


  // Function to update paid totals
  static Future<void> updatePaidTotals(String customerId, double amount) async {
    final response = await http.post(
      Uri.parse('${BASE_URL}api/MonthlyInvoice/updatePaidTotals/$customerId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "paidGrandTotalAmounts": [amount]
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update paid totals');
    }
  }

  // Function to calculate unpaid amount
  static double calculateUnpaidAmount(Map<String, dynamic> invoiceData) {
    // Extract grandTotalAmount
    double grandTotalAmount = invoiceData['grandTotalAmount'].toDouble();

    // Extract paidGrandTotalAmounts and calculate the sum
    List<dynamic> paidAmountsJson = invoiceData['paidGrandTotalAmounts'];
    double totalPaidAmount = paidAmountsJson.fold(0.0, (sum, item) => sum + item.toDouble());
    print(totalPaidAmount);

    // Return the unpaid amount (grandTotalAmount - sum of paidGrandTotalAmounts)
    return grandTotalAmount - totalPaidAmount;
  }
}


class QuarterlyInvoiceChartPage extends StatefulWidget {
  final Map<String, dynamic> customerID;

  const QuarterlyInvoiceChartPage({super.key, required this.customerID});
  @override
  _QuarterlyInvoiceChartPageState createState() => _QuarterlyInvoiceChartPageState();
}

class _QuarterlyInvoiceChartPageState extends State<QuarterlyInvoiceChartPage> {
  late Future<Map<String, dynamic>> futureInvoiceData;
  late PageController _pageController;
  int initialPage = 0;
  double? finalamount;
  late Razorpay _razorpay;
  String finalID ='';

  Future<void> fetchAndCalculateUnpaidAmount() async {
    try {
      Map<String, dynamic> invoiceData = await InvoiceService.fetchInvoiceData(finalID);
      double amount = InvoiceService.calculateUnpaidAmount(invoiceData);

      setState(() {
        finalamount = amount;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _handleTapToPay() async {
    try {
      if (finalamount != null && finalamount! > 0) {
        await InvoiceService.updatePaidTotals(finalID, finalamount!);
        await fetchAndCalculateUnpaidAmount(); // Refresh data
      }
    } catch (e) {
      print('Error updating payment: $e');
    }
  }


   Future<void> _refreshData() async {
  // Refresh the data
  setState(() {
    futureInvoiceData = InvoiceService.fetchInvoiceData(finalID);
  });

  // Optionally, reset the page controller to the initial page
  _pageController.jumpToPage(initialPage);
}



void openCheckout(amount)async{
  amount = amount *100;
  var options = {
    'key': 'rzp_live_Q31d2RntvTYC7v',
    'amount' : amount,
    'name':'Mahacool',
    'image':'https://ibb.co/nMQSFgN',
    'prefill':{'contact' : '9999222233' , 'email' : 'test@gmail.com'},
    'external': {
    'wallets' : ['paytm']
    } 

  };
  try{
    _razorpay.open(options);

  }catch(e){
    debugPrint('Error : e');

  }

}



void handlePaymentSuccess(PaymentSuccessResponse response ){
  Fluttertoast.showToast(msg: "Payment Sucessful" + response.paymentId! , toastLength: Toast.LENGTH_SHORT);

}


void handlePaymentError(PaymentFailureResponse response ){
  Fluttertoast.showToast(msg: "Payment Fail" + response.message! , toastLength: Toast.LENGTH_SHORT);
  _handleTapToPay();
  
  

}

void handleExternalWallet(ExternalWalletResponse response ){
  Fluttertoast.showToast(msg: "External Wallet " + response.walletName! , toastLength: Toast.LENGTH_SHORT);
}


@override
  void dispose() {

    super.dispose();
    _razorpay.clear();
  }


  @override
  void initState() {
    super.initState();
    finalID = widget.customerID["customerID"];
    futureInvoiceData = InvoiceService.fetchInvoiceData(finalID);

    DateTime now = DateTime.now();
    int currentMonth = now.month;
    initialPage = (currentMonth - 1) ~/ 3; // Determine initial quarter page
    _pageController = PageController(initialPage: initialPage);
    fetchAndCalculateUnpaidAmount();
     _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text('Invoice Summary', style: TextStyle(fontFamily: 'helvetica' , color: Colors.white , fontSize: 15)),
      actions: [
        // ElevatedButton(onPressed: (){
        //   //InvoiceService.calculateUnpaidAmount('')
        // }, child: Text('print')),
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: IconButton(
            icon: Icon(Icons.refresh_rounded, size: 30 , color: Colors.white,),
            onPressed: _refreshData, // Call the refresh method
          ),
        ),
      ],
      backgroundColor: Color(0xFF4c606b),
      leading: IconButton(onPressed: (){
        Navigator.pop(context);
      }, icon: Icon(Icons.arrow_back_ios_new ), color: Colors.white,),),
    body: Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        FutureBuilder<Map<String, dynamic>>(
          future: futureInvoiceData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('No data available.'));
            } else {
              final data = snapshot.data!;

              // Safeguard for null or unexpected data
              final unpaidMonthly = (data['unpaidMonthly'] as Map<String, dynamic>? ?? {})
                  .map((key, value) => MapEntry(key, (value as num).toDouble()));

              final paidMonthlyTotals = (data['paidMonthlyTotals'] as Map<String, dynamic>? ?? {})
                  .map((key, value) => MapEntry(key, (value as num).toDouble()));

              final grandTotalAmount = (data['grandTotalAmount'] as num).toDouble();

              List<List<MapEntry<String, double>>> quarterlyData = _groupMonthsIntoQuarters(unpaidMonthly, paidMonthlyTotals);

              return PageView.builder(
                controller: _pageController,
                itemCount: quarterlyData.length,
                itemBuilder: (context, index) {
                  return QuarterlyInvoiceChart(
                    quarterData: quarterlyData[index],
                    grandTotalAmount: finalamount ?? 0.0,
                    paidMonthlyTotals: paidMonthlyTotals,
                  );
                },
              );
            }
          },
        ),
        GestureDetector(
          onTap:() {

            if (finalamount != null && finalamount! > 0) {
      openCheckout(finalamount!);
    } else {
      Fluttertoast.showToast(msg: "Amount is not available yet.");
    }
          },
          child: Padding(
            //_handleTapToPay
            padding: const EdgeInsets.only(bottom: 20),
            child: Container(
              height: 90,
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Tap to Pay', style: TextStyle(fontFamily: 'helvetica', color: Colors.white60, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text('$finalamount', style: const TextStyle(fontFamily: 'helvetica', color: Colors.white, fontSize: 15,)),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 30),
                      child: Icon(Icons.arrow_forward_ios_sharp, color: Colors.white, size: 30),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
  }

  List<List<MapEntry<String, double>>> _groupMonthsIntoQuarters(
    Map<String, double> unpaidMonthly,
    Map<String, double> paidMonthlyTotals,
  ) {
    const List<String> allMonths = [
      'Jan-2024', 'Feb-2024', 'Mar-2024',
      'Apr-2024', 'May-2024', 'Jun-2024',
      'Jul-2024', 'Aug-2024', 'Sept-2024',
      'Oct-2024', 'Nov-2024', 'Dec-2024',
    ];

    List<MapEntry<String, double>> filledMonths = allMonths.map((month) {
      double unpaid = unpaidMonthly[month] ?? 0.0;
      double paid = paidMonthlyTotals[month] ?? 0.0;
      return MapEntry(month, unpaid - paid);
    }).toList();

    List<List<MapEntry<String, double>>> quarterlyData = [];
    for (int i = 0; i < filledMonths.length; i += 3) {
      quarterlyData.add(filledMonths.sublist(i, i + 3));
    }

    return quarterlyData;
  }
}

class QuarterlyInvoiceChart extends StatelessWidget {
  final List<MapEntry<String, double>> quarterData;
  final double grandTotalAmount;
  final Map<String, double> paidMonthlyTotals; // Add this line

  const QuarterlyInvoiceChart({
    required this.quarterData,
    required this.grandTotalAmount,
    required this.paidMonthlyTotals, // Add this line
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20,),
          // ElevatedButton(onPressed: (){
          //   print(quarterData);
          // }, child: Text('prinr')),
          const Text(
            'Quarterwise Invoice \nSummary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontFamily: 'helvetica'
            ),
          ),
          const SizedBox(height: 80),
          AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(
                  show: false,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false
                    )
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      getTitlesWidget: _bottomTitles,
                    ),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                ),
                gridData: const FlGridData(
                  show: false, // Hide grid lines
                ),
                barGroups: _buildBarGroups(),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'Total \Rs. ${grandTotalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade900,
              fontFamily: 'helvetica'
              
            ),
          ),
          // ElevatedButton(onPressed: (){
          //   print(quarterData);
          // }, child: Text('print'))
        ],
      ),
    );
  }

  Widget _bottomTitles(double value, TitleMeta meta) {
    List<String> months = quarterData.map((e) => e.key).toList();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        months[value.toInt()],
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold , fontFamily: 'helvetica' ,fontSize: 13),
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(quarterData.length, (index) {
      final entry = quarterData[index];
      final month = entry.key;
      final unpaidValue = entry.value ?? 0.0;


      // Determine the color of the bar
      Color barColor = unpaidValue > 0 ? Colors.red : Colors.green;

      // Find if the month has been paid or not
      double paidAmount = paidMonthlyTotals[month] ?? 0.0;
      if (paidAmount > 0) {
        // If there is a paid amount, display it as green
        barColor = Colors.green;
      }

      return BarChartGroupData(
        x: index,
        barRods: [

          BarChartRodData(
            toY: unpaidValue > 0 ? unpaidValue : paidAmount,
            color: barColor,
            width: 18,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            backDrawRodData: BackgroundBarChartRodData(
              toY: grandTotalAmount,
              color: Colors.grey.shade300,
              show: true,
            ),
          ),
        ],
        showingTooltipIndicators: [0],
      );
    });
  }
}
