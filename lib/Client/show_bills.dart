import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:inventory_app/constants.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class QuarterlyBarChart extends StatefulWidget {
  final Map<String, dynamic> customerID;

  const QuarterlyBarChart({super.key, required this.customerID});
  @override
  _QuarterlyBarChartState createState() => _QuarterlyBarChartState();
}

class _QuarterlyBarChartState extends State<QuarterlyBarChart> {
  late Razorpay _razorpay;
  List<Map<String, dynamic>> quarterlyData = [];
  double totalunpaid = 0;
  bool isLoading = true;
  double maxBarValue = 0;
  String finalID ='';
  String? selectedMonth;
  List<String> unpaidMonths = ["June", "July", "August"]; // Example list
  double selectedMonthUnpaidAmount = 0;
  String? checkMonthpay;
  double? checkmonthtotal;
  late PageController _pageController;
  int initialPage = 0; // Default initial page



 Future<void> fetchInvoiceData() async {
  final response = await http.get(
    Uri.parse('${BASE_URL}api/MonthlyInvoice/getByCustomerId/$finalID'),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    
    print('API Response: $data'); // Add this to check the API response

    Map<String, dynamic> paidMonthlyTotals = data['paidMonthlyTotals'] ?? {};
    Map<String, dynamic> unpaidMonthlyTotals = data['unpaidMonthlyTotals'] ?? {};

    if (paidMonthlyTotals.isNotEmpty || unpaidMonthlyTotals.isNotEmpty) {
      setState(() {
        quarterlyData = [
          getQuarterData(paidMonthlyTotals, unpaidMonthlyTotals, ['January', 'February', 'March']),
          getQuarterData(paidMonthlyTotals, unpaidMonthlyTotals, ['April', 'May', 'June']),
          getQuarterData(paidMonthlyTotals, unpaidMonthlyTotals, ['July', 'August', 'September']),
          getQuarterData(paidMonthlyTotals, unpaidMonthlyTotals, ['October', 'November', 'December']),
        ];

        maxBarValue = getMaxBarValue(quarterlyData);
        isLoading = false;

        sumUnpaidValues(quarterlyData);
        _checkSelectedMonth();
      });
    } else {
      setState(() {
        isLoading = false; // No data available, stop loading
      });
    }
  } else {
    throw Exception('Failed to load invoice data');
  }
}



Map<String, dynamic> getQuarterData(
    Map<String, dynamic> paidTotals,
    Map<String, dynamic> unpaidTotals,
    List<String> months) {

  List<double> paid = [];
  List<double> unpaid = [];

  for (String month in months) {
    double paidAmount = paidTotals.containsKey('$month-2024')
    ? (paidTotals['$month-2024'] is int 
        ? (paidTotals['$month-2024'] as int).toDouble() 
        : paidTotals['$month-2024'])
    : 0.0;
    double unpaidAmount = unpaidTotals.containsKey('$month-2024')
    ? (unpaidTotals['$month-2024'] is int 
        ? (unpaidTotals['$month-2024'] as int).toDouble() 
        : unpaidTotals['$month-2024'])
    : 0.0;

    paid.add(paidAmount);
    unpaid.add(unpaidAmount);
  }

  return {
    'quarter': 'Q${(months.first == 'January') ? 1 : (months.first == 'April') ? 2 : (months.first == 'July') ? 3 : 4}',
    'months': months,
    'paid': paid,
    'unpaid': unpaid,
  };
}


  // Helper function to get the maximum value for bar heights
  double getMaxBarValue(List<Map<String, dynamic>> data) {
    double maxValue = 0;

    for (var quarter in data) {
      List<double> paid = quarter['paid'];
      List<double> unpaid = quarter['unpaid'];

      for (int i = 0; i < paid.length; i++) {
        if (paid[i] > maxValue) {
          maxValue = paid[i].toDouble();
        }
        if (unpaid[i] > maxValue) {
          maxValue = unpaid[i].toDouble();
        }
      }
    }

    return maxValue;
  }


  void sumUnpaidValues(List<Map<String, dynamic>> quarterlyData) {
  double totalUnpaid = 0;

  // Iterate through each quarter in the list
  for (var quarter in quarterlyData) {
    // Access the 'unpaid' list and sum the values
    List<double> unpaidValues = List<double>.from(quarter['unpaid']);
    totalUnpaid += unpaidValues.reduce((a, b) => a + b);
  }
  setState(() {
    totalunpaid = totalUnpaid;
  });

  //return totalUnpaid;
}



Future<void> updatePaidTotals(String invoiceId, Map<String, double> paidMonthlyTotal) async {
  // API endpodouble
  final url = Uri.parse('${BASE_URL}api/MonthlyInvoice/updatePaidTotals/$invoiceId');

  // JSON body
  final Map<String, dynamic> requestBody = {
    "paidMonthlyTotal": paidMonthlyTotal,
  };

  try {
    // Sending POST request
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    // Handling the response
    if (response.statusCode == 200) {
      print('Update successful!');
      print(response.body);
    } else {
      print('Failed to update. Status code: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print('Error: $e');
  }
}


String getMonth(String currentmonth){
  setState(() {
    checkMonthpay = currentmonth;
  });
  print(checkMonthpay);
  return currentmonth;
}

double getMonthtotal(double totalamt){
  setState(() {
    checkmonthtotal = totalamt;
  });
  print(checkmonthtotal);
  return totalamt;
}

void _checkSelectedMonth() {
  // Check if selectedMonth is in the updated unpaidMonths list
  if (selectedMonth != null && !unpaidMonths.contains(selectedMonth)) {
    setState(() {
      // If the selected month is no longer in the list, reset it to the first unpaid month, if available
      selectedMonth = unpaidMonths.isNotEmpty ? unpaidMonths.first : null;
      
      // If a valid month is selected, find the unpaid amount from the correct quarter
      if (selectedMonth != null) {
        for (var quarter in quarterlyData) {
          if (quarter['months'].contains(selectedMonth)) {
            double monthIndex = quarter['months'].indexOf(selectedMonth!);
            selectedMonthUnpaidAmount = quarter['unpaid'][monthIndex];
            break;
          }
        }
      } else {
        // If no valid month is found, reset the unpaid amount
        selectedMonthUnpaidAmount = 0;
      }
    });
  }
}







/////payment gateway //////
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
  updatePaidTotals(finalID, {"$checkMonthpay": checkmonthtotal!});
  setState(() {
    selectedMonth = null;
    selectedMonthUnpaidAmount = 0;
  });
  fetchInvoiceData();
  Fluttertoast.showToast(msg: "Payment Fail" + response.message! , toastLength: Toast.LENGTH_SHORT);
  

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
    super.initState(
    );
    finalID = widget.customerID["customerID"];
    fetchInvoiceData();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    //sumUnpaidValues(quarterlyData);
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    if (currentMonth <= 3) {
    initialPage = 0; // Q1
  } else if (currentMonth <= 6) {
    initialPage = 1; // Q2
  } else if (currentMonth <= 9) {
    initialPage = 2; // Q3
  } else {
    initialPage = 3; // Q4
  }

  // Initialize PageController with the initial page
  _pageController = PageController(initialPage: initialPage);

  }















  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Quarterly Invoice" , style: TextStyle(fontFamily: 'helvetica'),),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(onPressed: (){
              setState(() {
    selectedMonth = null;
    selectedMonthUnpaidAmount = 0;
  });
            fetchInvoiceData();
            }, icon: Icon(Icons.refresh_rounded , size: 28,)),
          )
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: Text("No Bills found"))
          : Stack(
            children: [PageView.builder(
              controller: _pageController,
                itemCount: quarterlyData.length,
                itemBuilder: (context, index) {
                  final quarter = quarterlyData[index];
                  List<String> unpaidMonths = [];
                  quarter['months'].asMap().forEach((i, month) {
                    if (quarter['unpaid'][i] > 0) {
                      unpaidMonths.add(month);
                    }
                  });
                  return Padding(
                    padding: const EdgeInsets.only(top: 40, right: 15, left: 15),
                    child: ListView(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisSize: MainAxisSize.min,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // Header Text
                        Center(
                          child: Text(
                            '${quarter['quarter']} Bills Summary',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              fontFamily: 'helvetica',
                            ),
                          ),
                        ),
                        const SizedBox(height: 60), // Reduced gap
                    
                        // Chart Container with reduced height
                        Container(
                          height: 250, // Reduced chart height
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: maxBarValue + 10, // Adjust the maxY dynamically
                              titlesData: const FlTitlesData(
                                show: false, // Hide side and bottom axes
                              ),
                              gridData: const FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              barGroups: [
                                for (int i = 0; i < quarter['months'].length; i++)
                                  BarChartGroupData(
                                    x: i,
                                    barRods: [
                                      BarChartRodData(
                                        toY: quarter['paid'][i] > 0
                                            ? quarter['paid'][i].toDouble()
                                            : quarter['unpaid'][i].toDouble(),
                                        color: quarter['paid'][i] > 0
                                            ? Colors.green
                                            : Colors.red,
                                        width: 15,
                                        backDrawRodData: BackgroundBarChartRodData(
                                          show: true,
                                          toY: maxBarValue + 10, // Set the same dynamic maxY
                                          color: (quarter['paid'][i] > 0
                                                  ? Colors.green
                                                  : Colors.red)
                                              .withOpacity(0.2),
                                        ),
                                      ),
                                    ],
                                    showingTooltipIndicators: [0],
                                  ),
                              ],
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                                    String type = rod.color == Colors.green ? "Paid" : "Unpaid";
                                    return BarTooltipItem(
                                      '₹${rod.toY.toStringAsFixed(2)}',
                                      const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'helvetica',
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10), // Reduced gap
                    
                        // Displaying values above bars
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(quarter['months'].length, (i) {
                              return Column(
                                children: [
                                  Text(
                                    quarter['paid'][i] > 0
                                        ? '₹${quarter['paid'][i].toString()}'
                                        : '₹${quarter['unpaid'][i].toString()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: quarter['paid'][i] > 0 ? Colors.green : Colors.red,
                                      fontFamily: 'helvetica',
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    quarter['months'][i],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                      fontFamily: 'helvetica',
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        // ElevatedButton(onPressed: (){
                        //   prdouble(quarterlyData[2]['unpaid']);
                        //   prdouble(quarterlyData[2]['paid']);
                        // }, child: Text('prdouble')),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            unpaidMonths.isNotEmpty
                            ? DropdownButton<String>(
                                value: selectedMonth,
                                hint: const Text("Select Unpaid Month" , style: TextStyle(fontFamily: 'helvetica'),),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedMonth = newValue;
                                    int monthIndex = quarter['months'].indexOf(newValue!);
                                    selectedMonthUnpaidAmount = quarter['unpaid'][monthIndex];
                                    getMonth("$selectedMonth-2024");
                                    getMonthtotal(selectedMonthUnpaidAmount);
                                    print(quarter['unpaid'][monthIndex]);
                                    print(selectedMonthUnpaidAmount);
                                  });
                                },
                                items: unpaidMonths.map((month) {
                                  return DropdownMenuItem<String>(
                                    value: month,
                                    child: Text(month , style: TextStyle(fontFamily: 'helvetica'),),
                                  );
                                }).toList(),
                              )
                            : const Text("No Unpaid Months", style: TextStyle(fontSize: 16, color: Colors.black54 , fontFamily: 'helvetica')),
                            Row(
                              children: [
                                Container(
                                  height: 25,
                                  width: 25,
                                  decoration:  BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                const SizedBox(width: 8,),
                                const Text("Unpaid" , style: TextStyle(fontFamily: 'helvetica' , fontSize: 18),)
                              ],
                            ),
                            
                            
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 25,
                              width: 25,
                              decoration:  BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const SizedBox(width: 8,),
                            const Text("Paid     " , style: TextStyle(fontFamily: 'helvetica' , fontSize: 18),)
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40 , left: 10 , right: 10),
                          child: InkWell(
                            onTap: selectedMonthUnpaidAmount > 0 ? () {
    openCheckout(selectedMonthUnpaidAmount);
  } : null,
                            child: Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade700,
                                borderRadius: BorderRadiusDirectional.circular(30)
                              ),
                              child:  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text("Tap to pay" , style: TextStyle(fontFamily: 'helvetica' , color: Colors.white70 , fontSize: 20),),
                                        const SizedBox(height: 5,),
                                        Text('Rs. $selectedMonthUnpaidAmount' , style: const TextStyle( color: Colors.white , fontSize: 20 , fontWeight: FontWeight.w800),)
                                      ],
                                    ),
                                  ),
                                  
                                  const Padding(
                                    padding:  EdgeInsets.only(right: 20),
                                    child:  Icon(Icons.arrow_forward_ios_outlined , color: Colors.white,),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                      
                    ),
                  );
                },
              ),
            ]
          ),
          
    );
  }
}
