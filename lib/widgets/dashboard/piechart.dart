import 'package:ccm/main.dart';
import 'package:ccm/models/pieChartData.dart';
import 'package:ccm/widgets/quotation/quote_date_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieStatement extends StatelessWidget {
  PieStatement({Key? key, required this.chartData, this.footer, this.header}) : super(key: key);

  final List<PieData> chartData;
  final Widget? footer;
  final Widget? header;

  List<PieChartSectionData> getChartSectionData() {
    List<PieChartSectionData> data = [];
    chartData.forEach((element) {
      printNormal(element.value.toString());
      data.add(PieChartSectionData(
        value: double.parse(element.value.toStringAsFixed(2)),
        color: element.color,
        radius: element.radius,
      ));
    });
    return data;
  }

  List<TableRow> getLabels() {
    List<TableRow> rows = [];
    chartData.forEach((element) {
      var row = TableRow(children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 8, bottom: 4, top: 4),
          child: Container(
            decoration: BoxDecoration(color: element.color, borderRadius: BorderRadius.circular(4)),
            height: 25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            element.label,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        Text(
          element.value.toStringAsFixed(2),
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ]);
      rows.add(row);
    });
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 300),
        child: Row(
          children: [
            Expanded(
                flex: 5,
                child: Center(
                  child: PieChart(
                    PieChartData(
                      sections: getChartSectionData(),
                      centerSpaceRadius: 0,
                    ),
                  ),
                )),
            Expanded(
              flex: 8,
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {
                      0: FlexColumnWidth(3),
                      1: FlexColumnWidth(9),
                      2: FlexColumnWidth(10),
                    },
                    children: getLabels()),
              ),
            ),
          ],
        ));
  }
}
