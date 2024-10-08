import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';
import 'package:inventory_app/constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class MonthlyInvoice {
  final Map<String, double> unpaidMonthly;
  final Map<String, double> paidMonthlyTotals;

  // Map for handling month name variations
  static const Map<String, String> monthMap = {
    // 'jan': 'Jan',
    // 'feb': 'Feb',
    // 'mar': 'Mar',
    // 'apr': 'Apr',
    // 'may': 'May',
    // 'jun': 'Jun',
    // 'jul': 'Jul',
    // 'aug': 'Aug',
    // 'sep': 'Sep',
    // 'sept': 'Sep', // Handling different representations of September
    // 'oct': 'Oct',
    // 'nov': 'Nov',
    // 'dec': 'Dec',
  };

  MonthlyInvoice({
    required this.unpaidMonthly,
    required this.paidMonthlyTotals,
  });

  factory MonthlyInvoice.fromJson(Map<String, dynamic> json) {
    Map<String, double> unpaidMonthly = {};
    Map<String, double> paidMonthlyTotals = {};

    // Standardizing the month names in both unpaidMonthly and paidMonthlyTotals
    (json['unpaidMonthly'] as Map<String, dynamic>).forEach((key, value) {
      String standardizedKey = monthMap[key.trim().toLowerCase()] ?? key.trim();
      unpaidMonthly[standardizedKey] = value.toDouble();
    });

    (json['paidMonthlyTotals'] as Map<String, dynamic>).forEach((key, value) {
      String standardizedKey = monthMap[key.trim().toLowerCase()] ?? key.trim();
      paidMonthlyTotals[standardizedKey] = value.toDouble();
    });

    return MonthlyInvoice(
      unpaidMonthly: unpaidMonthly,
      paidMonthlyTotals: paidMonthlyTotals,
    );
  }
}


class QuarterlyBarGraph extends StatefulWidget {
  final Map<String, dynamic> client_Details;

  const QuarterlyBarGraph({super.key, required this.client_Details});
  @override
  _QuarterlyBarGraphState createState() => _QuarterlyBarGraphState();
}

class _QuarterlyBarGraphState extends State<QuarterlyBarGraph> {
  late Razorpay _razorpay;
  MonthlyInvoice? monthlyInvoice;
  bool isLoading = true;
  late PageController _pageController;
  int currentQuarter = 0;
  dynamic responseapi;
  //bool _isloading = false;

  TextEditingController _amountController = TextEditingController();
  String enteredAmount = "0";
  double topay = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
        initialPage:
            getCurrentQuarter()); // Set initial page to current quarter
    fetchInvoiceData();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _amountController.dispose();
    super.dispose();
    super.dispose();
    _razorpay.clear();
  }

  // Function to get the current quarter based on the current month
  int getCurrentQuarter() {
    int currentMonth = DateTime.now().month;
    if (currentMonth <= 3) {
      return 0; // Q1
    } else if (currentMonth <= 6) {
      return 1; // Q2
    } else if (currentMonth <= 9) {
      return 2; // Q3
    } else {
      return 3; // Q4
    }
  }

  Future<void> fetchInvoiceData() async {
    final url =
        Uri.parse('${BASE_URL}api/MonthlyInvoice/getByCustomerId/${widget.client_Details["customerID"]}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('call hogya');
        setState(() {
          monthlyInvoice = MonthlyInvoice.fromJson(jsonResponse);
          isLoading = false;
          responseapi = jsonResponse;
          isLoading = false;
        });
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      // setState(() {
      //   isLoading = false;
      // });
    }
  }

  Future<void> updatePaidTotals(
      int invoiceId, double paidGrandTotalAmounts) async {
    final url = '${BASE_URL}api/MonthlyInvoice/updatePaidTotals/$invoiceId';

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'paidGrandTotalAmounts': paidGrandTotalAmounts,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        print('Update successful: ${response.body}');
        fetchInvoiceData();
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  void openCheckout(double amount) async {
    amount = amount * 100;
    var options = {
      'key': 'rzp_live_Q31d2RntvTYC7v',
      'amount': amount,
      'name': 'Mahacool',
      'image': 'https://ibb.co/nMQSFgN',
      'prefill': {'contact': '9999222233', 'email': 'test@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error : e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    int customerId = int.tryParse(widget.client_Details["customerID"].toString()) ?? 0;
   if (customerId > 0) {
    updatePaidTotals(customerId, topay);
    Fluttertoast.showToast(
        msg: "Payment Successful: ",
        toastLength: Toast.LENGTH_SHORT);
  } else {
    Fluttertoast.showToast(
        msg: "Invalid customer ID",
        toastLength: Toast.LENGTH_SHORT);
        
    }
  }

  void handlePaymentError(PaymentFailureResponse response) {
    int customerId = int.tryParse(widget.client_Details["customerID"].toString()) ?? 0;
    updatePaidTotals(customerId, topay);
    Fluttertoast.showToast(
        msg: "Payment Fail" + response.message!,
        toastLength: Toast.LENGTH_SHORT);
    // _handleTapToPay();
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "External Wallet " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  List<BarChartGroupData> createBarData(Map<String, double> unpaid,
      Map<String, double> paid, List<String> months) {
    return months.asMap().entries.map((entry) {
      int index = entry.key;
      String month = entry.value;

      double unpaidValue = unpaid[month] ?? 0;
      double paidValue = paid[month] ?? 0;
      double difference = unpaidValue - paidValue;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: difference,
            color: difference > 0 ? Colors.red : Colors.green,
            width: 22,
            borderRadius: BorderRadius.circular(5),
            rodStackItems: [
              BarChartRodStackItem(
                  0, difference, difference > 0 ? Colors.red : Colors.green),
            ],
          ),
        ],
        showingTooltipIndicators: [0],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<List<String>> quarters = [
      ['Jan-2024', 'Feb-2024', 'Mar-2024'], // Q1
      ['Apr-2024', 'May-2024', 'Jun-2024'], // Q2
      ['Jul-2024', 'Aug-2024', 'Sep-2024'], // Q3
      ['Oct-2024', 'Nov-2024', 'Dec-2024'], // Q4
    ];
    final List<List<String>> quarters2 = [
      ['Jan-2024', 'Feb-2024', 'Mar-2024'], // Q1
      ['Apr-2024', 'May-2024', 'Jun-2024'], // Q2
      ['Jul-2024', 'Aug-2024', 'Sept-2024'], // Q3
      ['Oct-2024', 'Nov-2024', 'Dec-2024'], // Q4
    ];
    

    return Scaffold(
      appBar: AppBar(
        title: Text('Quarterly Bar Graph',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      // This makes sure the UI can scroll when the keyboard opens
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child:Column(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Container(
      height: MediaQuery.of(context).size.height * 0.60, // Adjust the height as necessary
      child: PageView.builder(
        controller: _pageController,
        itemCount: quarters.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.03), // Adjusted vertical padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Adding quarter labels at the top (Q3, Q2, Q1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 30), // Adjusted bottom padding
                  child: Center(
                    child: Text(
                      'Quarter ${index + 1}',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.045, // Responsive font size
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                // Wrapping the chart in a box with borders
                Container(
                  margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04), // Responsive margins
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: AspectRatio(
                    aspectRatio: 1.5,
                    child: BarChart(
                      BarChartData(
                        barGroups: createBarData(
                          monthlyInvoice!.unpaidMonthly,
                          monthlyInvoice!.paidMonthlyTotals,
                          quarters[index] == 'sept' ? quarters2[index] : quarters[index],
                          
                        ),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  quarters[index] == 'sept' ? quarters2[index][value.toInt()] : quarters[index][value.toInt()],
                                  //quarters[index][value.toInt()],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: MediaQuery.of(context).size.width * 0.028, // Responsive font size
                                    color: Colors.black54,
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                rod.toY.toStringAsFixed(2),
                                TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MediaQuery.of(context).size.width * 0.035, // Responsive font size
                                ),
                              );
                            },
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Total Amount: Rs. ${(responseapi["grandTotalAmount"] - responseapi["totalPaidAmount"]).toDouble().toStringAsFixed(2)}",
                    style: TextStyle(
                      fontFamily: 'helvetica',
                      fontSize: MediaQuery.of(context).size.width * 0.045, // Responsive font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20), // Make padding symmetric
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Amount to Pay',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.blue.shade700),
              ),
            ),
            onChanged: (value) {
              setState(() {
                enteredAmount = value;
                topay = double.tryParse(enteredAmount) ?? 0;
              });
            },
          ),
          SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                fixedSize: Size(MediaQuery.of(context).size.width * 0.7, 50), // Responsive button width
              ),
              onPressed: () {
                // Handle the button press logic here
                if (enteredAmount.isNotEmpty) {
                  openCheckout(topay);
                  print("Amount to pay: $topay");
                } else {
                  Fluttertoast.showToast(msg: "Please enter a valid amount");
                }
              },
              child: Text(
                'Pay Rs. $enteredAmount',
                style: TextStyle(
                  fontFamily: 'helvetica',
                  fontSize: MediaQuery.of(context).size.width * 0.045, // Responsive font size
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  ],
)

            ),
    );
  }
}
