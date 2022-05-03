import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/dashboard/AccountChart.dart';
import 'package:flutter/material.dart';

class Top5Entity extends StatelessWidget {
  Top5Entity({Key? key, this.country, this.currency, required this.data, this.isClient = false}) : super(key: key);

  final String? country;
  final String? currency;
  final List<AccountChartData> data;
  final bool isClient;

  List<DataRow> getRows() {
    List<DataRow> rows = [];
    data.sort(
      (a, b) => b.amount.compareTo(a.amount),
    );

    for (int i = 0; i < 5; i++) {
      if (i < data.length) {
        rows.add(
          DataRow(
            cells: [
              DataCell(Text(clientController.getName(data[i].entity))),
              DataCell(
                Text(data[i].amount.toStringAsFixed(2)),
              ),
            ],
          ),
        );
      } else {
        rows.add(
          DataRow(
            cells: [
              DataCell(Text('')),
              DataCell(
                Text(''),
              ),
            ],
          ),
        );
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    data.sort((a, b) => b.amount.compareTo(a.amount));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: DataTable(columns: [
          DataColumn(
            label: Text(isClient ? 'CLIENT' : 'CONTRACTOR'),
          ),
          DataColumn(
            label: Text(isClient ? 'RECEIVABLES' : 'PAYABLES'),
          )
        ], rows: getRows()),
      ),
    );
  }
}
