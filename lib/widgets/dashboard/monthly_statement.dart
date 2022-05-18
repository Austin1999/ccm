import 'dart:math';

import 'package:ccm/controllers/currency_controller.dart';
import 'package:ccm/models/dashboard/BarChart.dart';
import 'package:ccm/models/dashboard_data.dart';
import 'package:ccm/services/firebase.dart';
import 'package:ccm/widgets/dashboard/customrendere.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'customrendere.dart';

List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

class MonthlyStatement extends StatefulWidget {
  const MonthlyStatement({Key? key, this.country, required this.currency, this.client}) : super(key: key);

  final String? country;
  final String currency;
  final String? client;

  @override
  State<MonthlyStatement> createState() => _MonthlyStatementState();
}

class _MonthlyStatementState extends State<MonthlyStatement> {
  @override
  void initState() {
    super.initState();
    clear();
  }

  List<String> get monthsShifted {
    List<String> list = [];
    int currentMonth = DateTime.now().month;
    list = months.sublist(currentMonth);
    list.addAll(months.sublist(0, currentMonth));
    return list;
  }

  String? get country => widget.country;
  String get currency => widget.currency;
  String? get client => widget.client;

  clear() {
    total = monthsShifted.map((e) => BarChartData(key: e, value: 0)).toList();
    received = monthsShifted.map((e) => BarChartData(key: e, value: 0)).toList();
    receivables = monthsShifted.map((e) => BarChartData(key: e, value: 0)).toList();
  }

  List<BarChartData> total = [];
  List<BarChartData> received = [];
  List<BarChartData> receivables = [];

  loadData() async {
    Query<Map<String, dynamic>> query = dashboardDataRef;
    query = query.where('issuedDate', isGreaterThanOrEqualTo: fromDate);
    query = query..where('issuedDate', isLessThanOrEqualTo: DateTime.now());
    if (country != null) {
      query = query.where('country', isEqualTo: country);
    }
    if (client != null) {
      query = query.where('client', isEqualTo: client);
    }
    await query.get().then((value) {
      clear();
      try {
        value.docs.forEach((element) {
          var data = DashboardData.fromJson(element.data());
          total[(data.issuedDate.month + DateTime.now().month + 1) % 12].value += data.amount.convert(data.currencyCode, widget.currency);
          received[(data.issuedDate.month + DateTime.now().month + 1) % 12].value += data.receivedAmount.convert(data.currencyCode, widget.currency);
          // receivables[(data.issuedDate.month + 6)%12].value += data.receivableAmount.convert(data.currencyCode, widget.currency);
          receivables[(data.issuedDate.month + DateTime.now().month + 1) % 12].value +=
              (data.amount - data.receivedAmount).convert(data.currencyCode, widget.currency);
        });
      } catch (e) {
        printError(info: e.toString());
      }
    });
  }

  DateTime get fromDate {
    DateTime date = DateTime.now().subtract(Duration(days: 365));

    return DateTime.utc(date.year, date.month);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('MONTHLY STATEMENT', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 500),
              child: FutureBuilder(
                future: loadData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                    return charts.BarChart(
                      [
                        charts.Series<BarChartData, String>(
                          id: 'total',
                          domainFn: (BarChartData data, _) => data.key,
                          measureFn: (data, _) => data.value,
                          data: total,
                          seriesColor: charts.ColorUtil.fromDartColor(Colors.deepOrange),
                          labelAccessorFn: (data, _) => data.value == 0 ? '' : data.value.toStringAsFixed(2),
                        ),
                        charts.Series<BarChartData, String>(
                          id: 'received',
                          domainFn: (BarChartData data, _) => data.key,
                          measureFn: (data, _) => data.value,
                          data: received,
                          seriesColor: charts.ColorUtil.fromDartColor(Colors.blue),
                          labelAccessorFn: (data, _) => data.value == 0 ? '' : data.value.toStringAsFixed(2),
                        ),
                        charts.Series<BarChartData, String>(
                            id: 'receivables',
                            domainFn: (BarChartData data, _) => data.key,
                            measureFn: (data, _) => data.value,
                            data: receivables,
                            seriesColor: charts.ColorUtil.fromDartColor(Colors.grey),
                            labelAccessorFn: (data, _) => data.value == 0 ? '' : data.value.toStringAsFixed(2)),
                      ],
                      barGroupingType: charts.BarGroupingType.grouped,
                      barRendererDecorator: new BarLabelDecoratorWorkAround<String>(
                          labelPosition: BarLabelPosition.auto,
                          insideLabelStyleSpec: charts.TextStyleSpec(
                            fontSize: 16,
                            fontWeight: 'BOLD',
                            color: charts.Color(r: 255, g: 255, b: 255),
                          )),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text("Sorry, Could not load Data. Please try again"),
                    );
                  }
                  return Center(
                    child: Text("Loading.."),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
