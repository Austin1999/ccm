import 'package:ccm/controllers/currency_controller.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:ccm/controllers/dashboard.dart';
import 'package:ccm/models/dashboard/BarChart.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AgedAccounts extends StatefulWidget {
  const AgedAccounts({Key? key, this.currency = 'SGD', this.country, required this.client}) : super(key: key);

  final String currency;
  final String? country;
  final List<String> client;

  @override
  State<AgedAccounts> createState() => _AgedAccountsState();
}

class _AgedAccountsState extends State<AgedAccounts> {
  @override
  void initState() {
    Get.put(DashboardController(), tag: 'aged');
    controller = Get.find(tag: 'aged');

    super.initState();
  }

  late DashboardController controller;

  List<charts.Series<BarChartData, String>> getPayableChartData() {
    var list = controller.agedPayables.keys.map((e) => BarChartData(key: e, value: controller.agedPayables[e] ?? 0)).toList();
    return [
      charts.Series<BarChartData, String>(
        seriesColor: charts.ColorUtil.fromDartColor(Colors.deepOrange),
        labelAccessorFn: (data, index) => data.value.convert('INR', widget.currency).toStringAsFixed(2),
        data: list,
        domainFn: (barData, _) => barData.key,
        id: 'agedPayables',
        measureFn: (barData, _) => barData.value.convert('INR', widget.currency),
        displayName: 'Aged Payables',
      )
    ];
  }

  List<charts.Series<BarChartData, String>> getReceivableChartData() {
    var list = controller.agedReceivables.keys.map((e) => BarChartData(key: e, value: controller.agedReceivables[e] ?? 0)).toList();
    return [
      charts.Series<BarChartData, String>(
        data: list,
        labelAccessorFn: (data, index) => data.value.convert('INR', widget.currency).toStringAsFixed(2),
        domainFn: (barData, _) => barData.key,
        id: 'agedReceivables',
        measureFn: (barData, _) => barData.value.convert('INR', widget.currency),
        displayName: 'Aged Receivables',
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    controller.loadAgedPayables(country: widget.country, clients: widget.client);
    controller.loadAgedReceivables(country: widget.country, clients: widget.client);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 400,
        ),
        child: GetBuilder(
            init: controller,
            builder: (_) {
              return Row(
                children: [
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Table(
                          children: [
                            TableRow(children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      'AGED RECEIVABLES',
                                      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                                    ),
                                  )),
                            ]),
                            TableRow(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: 320),
                                  child: charts.BarChart(
                                    getReceivableChartData(),
                                    animate: true,
                                    vertical: false,
                                    barRendererDecorator: new charts.BarLabelDecorator<String>(
                                        labelPosition: charts.BarLabelPosition.auto,
                                        insideLabelStyleSpec: charts.TextStyleSpec(
                                          fontSize: 16,
                                          fontWeight: 'BOLD',
                                          color: charts.Color(r: 255, g: 255, b: 255),
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Table(
                          children: [
                            TableRow(children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      'AGED PAYABLES',
                                      style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                                    ),
                                  )),
                            ]),
                            TableRow(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(maxHeight: 320),
                                  child: charts.BarChart(
                                    getPayableChartData(),
                                    animate: true,
                                    vertical: false,
                                    barRendererDecorator: new charts.BarLabelDecorator<String>(
                                        labelPosition: charts.BarLabelPosition.auto,
                                        insideLabelStyleSpec:
                                            charts.TextStyleSpec(fontSize: 16, fontWeight: 'BOLD', color: charts.Color(r: 0, g: 0, b: 0))),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
