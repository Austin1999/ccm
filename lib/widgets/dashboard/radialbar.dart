import 'package:ccm/models/pieChartData.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

class RadialBar extends StatefulWidget {
  const RadialBar({Key? key, required this.dataSource}) : super(key: key);

  final List<PieData> dataSource;

  @override
  State<RadialBar> createState() => _RadialBarState();
}

class _RadialBarState extends State<RadialBar> {
  List<PieData> get dataSource => widget.dataSource;

  @override
  void initState() {
    super.initState();
  }

  List<TableRow> getLabels() {
    List<TableRow> rows = [];
    dataSource.forEach((element) {
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

  double getMaxValue() {
    double quoteValue = dataSource.last.value;
    double allValue = dataSource.map((e) => e.value).fold<double>(0, (previousValue, element) => previousValue + element) - quoteValue;
    return (quoteValue > allValue ? quoteValue : allValue) * 1;
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 300),
        child: Center(
          child: Row(
            children: [
              Expanded(
                  flex: 5,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: SfCircularChart(
                      series: [
                        RadialBarSeries<PieData, String>(
                          maximumValue: getMaxValue(),
                          useSeriesColor: true,
                          dataSource: dataSource,
                          trackOpacity: 0.2,
                          pointColorMapper: (data, _) => data.color,
                          xValueMapper: (PieData data, _) => data.label,
                          yValueMapper: (PieData data, _) => data.value,
                          cornerStyle: CornerStyle.bothCurve,
                          radius: '80%',
                        )
                      ],
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
          ),
        ));
  }
}
