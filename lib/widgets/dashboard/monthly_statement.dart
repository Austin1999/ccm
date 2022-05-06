import 'dart:html';

import 'package:ccm/controllers/currency_controller.dart';
import 'package:ccm/controllers/dashboard.dart';
import 'package:ccm/models/dashboard/BarChart.dart';
import 'package:ccm/models/dashboard_data.dart';
import 'package:ccm/services/firebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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

  String? get country => widget.country;
  String get currency => widget.currency;
  String? get client => widget.client;

  get months => ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  clear() {
    total = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
        .map((e) => BarChartData(key: e, value: 0))
        .toList();
    received = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
        .map((e) => BarChartData(key: e, value: 0))
        .toList();

    receivables = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December']
        .map((e) => BarChartData(key: e, value: 0))
        .toList();
  }

  List<BarChartData> total = [];
  List<BarChartData> received = [];
  List<BarChartData> receivables = [];

  loadData() async {
    clear();
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
      print("Values Length = ${value.docs.length}");
      try {
        value.docs.forEach((element) {
          var data = DashboardData.fromJson(element.data());
          print(data.amount);
          print(data.issuedDate.month - 1);
          print(months[data.issuedDate.month - 1]);

          total[data.issuedDate.month - 1].value += data.amount.convert(data.currencyCode, widget.currency);
          received[data.issuedDate.month - 1].value += data.receivedAmount.convert(data.currencyCode, widget.currency);
          receivables[data.issuedDate.month - 1].value += data.receivableAmount.convert(data.currencyCode, widget.currency);
        });
      } catch (e) {
        printError(info: e.toString());
      }
      print(total.map((e) => e.value).toList());
    });
  }

  DateTime get fromDate {
    DateTime date = DateTime.now().subtract(Duration(days: 365));
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
                ),
                charts.Series<BarChartData, String>(
                  id: 'received',
                  domainFn: (BarChartData data, _) => data.key,
                  measureFn: (data, _) => data.value,
                  data: received,
                ),
                charts.Series<BarChartData, String>(
                  id: 'receivables',
                  domainFn: (BarChartData data, _) => data.key,
                  measureFn: (data, _) => data.value,
                  data: receivables,
                ),
              ],
              barGroupingType: charts.BarGroupingType.grouped,
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
    );
  }
}
