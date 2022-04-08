import 'package:ccm/controllers/getx_controllers.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({Key? key}) : super(key: key);

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  String? searchcountry;
  String? clientsearch;
  final List<ChartData> agedreceivable = [
    ChartData('60', 2545, Colors.grey),
    ChartData('30', 16405, Colors.blue),
    ChartData('0', 72980, Colors.orange),
  ];
  final List<ChartData> agedpayables = [
    ChartData('60', 72980, Colors.grey),
    ChartData('30', 16405, Colors.blue),
    ChartData('0', 50404, Colors.orange),
  ];
  final List<ChartData> total = [
    ChartData(
        'Total',
        double.parse(clientDashboardController.clientpayment['totalamount']
            .toStringAsFixed(2)),
        Colors.grey),
    ChartData(
        'Recieved',
        double.parse(clientDashboardController.clientpayment['totalrecieved']
            .toStringAsFixed(2)),
        Colors.blue),
    ChartData(
        'Remaining',
        double.parse((clientDashboardController.clientpayment['totalamount'] -
                clientDashboardController.clientpayment['totalrecieved'])
            .toStringAsFixed(2)),
        Colors.orange),
  ];

  final List<ChartData> monthly = [
    ChartData(
        'Total',
        // 200,
        double.parse(clientDashboardController
            .clientpayment[DateTime.now().month.toString()]['total']
            .toStringAsFixed(2)),
        Colors.grey),
    ChartData(
        'Recieved',
        // 500,
        double.parse(clientDashboardController
            .clientpayment[DateTime.now().month.toString()]['recieved']
            .toStringAsFixed(2)),
        Colors.blue),
    ChartData(
        'Remaining',
        double.parse((clientDashboardController
                    .clientpayment[DateTime.now().month.toString()]['total'] -
                clientDashboardController
                    .clientpayment[DateTime.now().month.toString()]['recieved'])
            .toStringAsFixed(2)),
        Colors.orange),
  ];

  final List<ChartData> pending = [
    ChartData(
        'Payables',
        // 200,
        double.parse(contractorController.contractorlist
            .fold(
                0,
                (int previousValue, element) =>
                    previousValue + element.payable!)
            .toStringAsFixed(2)),
        Colors.grey),
    ChartData(
        'Recieved',
        double.parse((clientDashboardController.clientpayment['totalamount'] -
                clientDashboardController.clientpayment['totalrecieved'])
            .toStringAsFixed(2)),
        Colors.blue),
  ];

  List<ChartData> yearlytotal = [
    ChartData(
        1,
        double.parse(clientDashboardController.clientpayment['1']['total']
            .toStringAsFixed(2))),
    ChartData(
        2,
        double.parse(clientDashboardController.clientpayment['2']['total']
            .toStringAsFixed(2))),
    ChartData(
        3,
        double.parse(clientDashboardController.clientpayment['3']['total']
            .toStringAsFixed(2))),
    ChartData(
        4,
        double.parse(clientDashboardController.clientpayment['4']['total']
            .toStringAsFixed(2))),
    ChartData(
        5,
        double.parse(clientDashboardController.clientpayment['5']['total']
            .toStringAsFixed(2))),
    ChartData(
        6,
        double.parse(clientDashboardController.clientpayment['6']['total']
            .toStringAsFixed(2))),
    ChartData(
        7,
        double.parse(clientDashboardController.clientpayment['7']['total']
            .toStringAsFixed(2))),
    ChartData(
        8,
        double.parse(clientDashboardController.clientpayment['8']['total']
            .toStringAsFixed(2))),
    ChartData(
        9,
        double.parse(clientDashboardController.clientpayment['9']['total']
            .toStringAsFixed(2))),
    ChartData(
        10,
        double.parse(clientDashboardController.clientpayment['10']['total']
            .toStringAsFixed(2))),
    ChartData(
        11,
        double.parse(clientDashboardController.clientpayment['11']['total']
            .toStringAsFixed(2))),
    ChartData(
        12,
        double.parse(clientDashboardController.clientpayment['12']['total']
            .toStringAsFixed(2))),
  ];
  List<ChartData> yearlyrecieved = [
    ChartData(
        1,
        double.parse(clientDashboardController.clientpayment['1']['recieved']
            .toStringAsFixed(2))),
    ChartData(
        2,
        double.parse(clientDashboardController.clientpayment['2']['recieved']
            .toStringAsFixed(2))),
    ChartData(
        3,
        double.parse(clientDashboardController.clientpayment['3']['recieved']
            .toStringAsFixed(2))),
    ChartData(
        4,
        double.parse(clientDashboardController.clientpayment['4']['recieved']
            .toStringAsFixed(2))),
    ChartData(
        5,
        double.parse(clientDashboardController.clientpayment['5']['recieved']
            .toStringAsFixed(2))),
    ChartData(
        6,
        double.parse(clientDashboardController.clientpayment['6']['recieved']
            .toStringAsFixed(2))),
    ChartData(
        7,
        double.parse(clientDashboardController.clientpayment['7']['recieved']
            .toStringAsFixed(2))),
    ChartData(
        8,
        double.parse(clientDashboardController.clientpayment['8']['recieved']
            .toStringAsFixed(2))),
    ChartData(
        9,
        double.parse(clientDashboardController.clientpayment['9']['recieved']
            .toStringAsFixed(2))),
    ChartData(
        10,
        double.parse(clientDashboardController.clientpayment['10']['recieved']
            .toStringAsFixed(2))),
    ChartData(
        11,
        double.parse(clientDashboardController.clientpayment['11']['recieved']
            .toStringAsFixed(2))),
    ChartData(
        12,
        double.parse(clientDashboardController.clientpayment['12']['recieved']
            .toStringAsFixed(2))),
  ];
  List<ChartData> yearlyremaining = [
    ChartData(1, 35),
    ChartData(2, 23),
    ChartData(3, 34),
    ChartData(4, 25),
    ChartData(5, 40),
    ChartData(6, 40),
    ChartData(7, 40),
    ChartData(8, 40),
    ChartData(9, 40),
    ChartData(10, 40),
    ChartData(11, 40),
    ChartData(12, 40),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    shadowColor: Colors.grey[600],
                    elevation: 5,
                    color: Colors.lightBlue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 5,
                                    child: DropdownButtonHideUnderline(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: DropdownButton(
                                            value: searchcountry,
                                            items: session.countries
                                                .map((e) => DropdownMenuItem(
                                                      child: Text(e.name),
                                                      value: e.code,
                                                    ))
                                                .toList(),
                                            onChanged: (String? value) {
                                              setState(() {
                                                searchcountry = value!;
                                              });
                                            },
                                            hint: Text("Select item")),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: Card(
                                      color: Colors.white,
                                      elevation: 5,
                                      child: TextFormField(
                                        onChanged: (value) {
                                          setState(() {
                                            // searchcontractor = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'Currency',
                                            suffixIcon: Icon(Icons.search),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none)),
                                      )),
                                ),
                                // SizedBox(
                                //   width:
                                //       MediaQuery.of(context).size.width * 0.30,
                                //   child: Card(
                                //     color: Colors.white,
                                //     elevation: 5,
                                //     child: DropdownButtonHideUnderline(
                                //       child: Padding(
                                //         padding: const EdgeInsets.symmetric(
                                //             horizontal: 8.0),
                                //         child: DropdownButton(
                                //             value: searchcountry,
                                //             items: clientController.clientlist
                                //                 .map((e) => DropdownMenuItem(
                                //                       child: Text(e.name),
                                //                       value: e.name,
                                //                     ))
                                //                 .toList(),
                                //             onChanged: (String? value) {
                                //               setState(() {
                                //                 clientsearch = value!;
                                //               });
                                //             },
                                //             hint: Text("Select Client")),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Card(
                          shadowColor: Colors.grey[600],
                          elevation: 5,
                          color: Colors.lightBlue[50],
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                              height: 580,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 50.0,
                                    child: Center(
                                      child: Text(
                                        'Total',
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          color: Colors.grey,
                                          height: 50,
                                          width: 80,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Text(
                                          'Total',
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Spacer(),
                                        Text(
                                          total[0].y.toString(),
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          color: Colors.blue,
                                          height: 50,
                                          width: 80,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Text(
                                          'Received',
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Spacer(),
                                        Text(
                                          total[1].y.toString(),
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          color: Colors.orange,
                                          height: 50,
                                          width: 80,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Text(
                                          'Remaining',
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.orange,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Spacer(),
                                        Text(
                                          total[2].y.toString(),
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  SfCircularChart(series: <CircularSeries>[
                                    // Render pie chart
                                    PieSeries<ChartData, String>(
                                        dataSource: total,
                                        pointColorMapper: (ChartData data, _) =>
                                            data.color,
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y)
                                  ])
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Card(
                          shadowColor: Colors.grey[600],
                          elevation: 5,
                          color: Colors.lightBlue[50],
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                              height: 580,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 50.0,
                                    child: Center(
                                      child: Text(
                                        'Monthly Statement',
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          color: Colors.grey,
                                          height: 50,
                                          width: 80,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Text(
                                          'Total',
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Spacer(),
                                        Text(
                                          monthly[0].y.toString(),
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          color: Colors.blue,
                                          height: 50,
                                          width: 80,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Text(
                                          'Received',
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Spacer(),
                                        Text(
                                          monthly[1].y.toString(),
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          color: Colors.orange,
                                          height: 50,
                                          width: 80,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Text(
                                          'Remaining',
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.orange,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Spacer(),
                                        Text(
                                          monthly[2].y.toString(),
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  SfCircularChart(series: <CircularSeries>[
                                    // Render pie chart
                                    PieSeries<ChartData, String>(
                                        dataSource: monthly,
                                        pointColorMapper: (ChartData data, _) =>
                                            data.color,
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y)
                                  ])
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Card(
                          shadowColor: Colors.grey[600],
                          elevation: 5,
                          color: Colors.lightBlue[50],
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                              height: 580,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 50.0,
                                    child: Center(
                                      child: Text(
                                        'Pending Statement',
                                        style: TextStyle(
                                          fontSize: 25,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          color: Colors.grey,
                                          height: 50,
                                          width: 80,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Text(
                                          'Payables',
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Spacer(),
                                        Text(
                                          pending[0].y.toString(),
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          color: Colors.blue,
                                          height: 50,
                                          width: 80,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Text(
                                          'Receivables',
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Spacer(),
                                        Text(
                                          pending[1].y.toString(),
                                          style: TextStyle(
                                              fontSize: 22,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w300),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  SfCircularChart(series: <CircularSeries>[
                                    // Render pie chart
                                    PieSeries<ChartData, String>(
                                        dataSource: pending,
                                        pointColorMapper: (ChartData data, _) =>
                                            data.color,
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y)
                                  ])
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Aged Receivables',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Card(
                              shadowColor: Colors.grey[600],
                              elevation: 5,
                              color: Colors.lightBlue[50],
                              child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SfCartesianChart(series: <ChartSeries>[
                                    BarSeries<ChartData, double>(
                                        dataLabelMapper: (ChartData data, _) =>
                                            data.y.toString(),
                                        dataSource: agedreceivable,
                                        xValueMapper: (ChartData data, _) =>
                                            double.parse(data.x),
                                        yValueMapper: (ChartData data, _) =>
                                            data.y,
                                        width: 0.6, // Width of the bars
                                        spacing: 0.3 // Spacing between the bars
                                        )
                                  ])),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Aged Payables',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Card(
                              shadowColor: Colors.grey[600],
                              elevation: 5,
                              color: Colors.lightBlue[50],
                              child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SfCartesianChart(series: <ChartSeries>[
                                    BarSeries<ChartData, double>(
                                        dataLabelMapper: (ChartData data, _) =>
                                            data.y.toString(),
                                        dataSource: agedpayables,
                                        xValueMapper: (ChartData data, _) =>
                                            double.parse(data.x),
                                        yValueMapper: (ChartData data, _) =>
                                            data.y,
                                        width: 0.6, // Width of the bars
                                        spacing: 0.3 // Spacing between the bars
                                        )
                                  ])),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Text('Monthly State per Year'),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Card(
                    shadowColor: Colors.grey[600],
                    elevation: 5,
                    color: Colors.lightBlue[50],
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SfCartesianChart(
                        // Columns will be rendered back to back
                        enableSideBySideSeriesPlacement: false,
                        series: <ChartSeries<ChartData, int>>[
                          ColumnSeries<ChartData, int>(
                              color: Colors.grey,
                              dataSource: yearlytotal,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y),
                          ColumnSeries<ChartData, int>(
                            color: Colors.blue,
                            opacity: 0.9,
                            width: 0.4,
                            dataSource: yearlyrecieved,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                          ),
                          ColumnSeries<ChartData, int>(
                            color: Colors.orange,
                            opacity: 0.9,
                            width: 0.4,
                            dataSource: yearlyremaining,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final dynamic x;
  final double y;
  final Color? color;
}
