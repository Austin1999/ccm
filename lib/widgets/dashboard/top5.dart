import 'package:ccm/controllers/currency_controller.dart';
import 'package:ccm/controllers/dashboard.dart';
import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/dashboard/AccountChart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Top5Entity extends StatelessWidget {
  Top5Entity({
    Key? key,
    this.country,
    required this.currency,
    required this.top5clients,
    required this.top5contractors,
  }) : super(key: key);

  final String? country;
  final String currency;
  final List<AccountChartData> top5clients;
  final List<AccountChartData> top5contractors;

  List<DataRow> getRows(List<AccountChartData> data) {
    List<DataRow> rows = [];
    for (int i = 0; i < 5; i++) {
      if (i < data.length) {
        rows.add(
          DataRow(
            cells: [
              DataCell(
                Text(
                  (i + 1).toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              DataCell(
                Text(
                  data[i].entity,
                  textAlign: TextAlign.center,
                ),
              ),
              DataCell(
                Text(data[i].amount.convert('INR', currency).toStringAsFixed(2)),
              ),
            ],
          ),
        );
      } else {
        rows.add(
          DataRow(
            cells: [
              DataCell(Text('')),
              DataCell(Text('')),
              DataCell(Text('')),
            ],
          ),
        );
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text('RANK'),
                  ),
                  DataColumn(
                    label: Text('CLIENT'),
                  ),
                  DataColumn(
                    label: Text('RECEIVABLES'),
                  )
                ],
                rows: getRows(top5clients),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: DataTable(
                columns: [
                  DataColumn(
                    label: Text('RANK'),
                  ),
                  DataColumn(
                    label: Text('CONTRACTOR'),
                  ),
                  DataColumn(
                    label: Text('PAYABLES'),
                  )
                ],
                rows: getRows(top5contractors),
              ),
            ),
          ),
        ),
      ],
    );
    ;
  }
}
