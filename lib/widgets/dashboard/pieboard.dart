import 'package:ccm/widgets/dashboard/piechart.dart';
import 'package:ccm/widgets/quotation/quote_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/currency_controller.dart';
import '../../controllers/dashboard.dart';
import '../../models/pieChartData.dart';

class PieBoard extends StatefulWidget {
  PieBoard({Key? key, required this.currency, this.country, this.client}) : super(key: key);

  final String currency;
  final String? country;
  final String? client;

  @override
  State<PieBoard> createState() => _PieBoardState();
}

class _PieBoardState extends State<PieBoard> {
  String get currency => widget.currency;
  String? get country => widget.country;
  String? get client => widget.client;

  // ignore: unused_field
  DateTime? _invoiceFromDate;
  // ignore: unused_field
  DateTime? _invoiceToDate;

  DateTime? _quoteFromDate;
  DateTime? _quoteToDate;

  @override
  void initState() {
    super.initState();
    Get.put((DashboardController()), tag: 'PieBoard');
    dashboard = Get.find(tag: 'PieBoard');
  }

  setLAst30days() {
    _quoteFromDate = DateTime.now().subtract(Duration(days: 30));
    _fromDate.text = format.format(_quoteFromDate!);
    _quoteToDate = DateTime.now();
    _toDate.text = format.format(_quoteToDate!);
  }

  setCurrentMonth() {
    _quoteToDate = DateTime.now();
    _quoteFromDate = DateTime.utc(_quoteToDate!.year, _quoteToDate!.month, 1);
    _fromDate.text = format.format(_quoteFromDate!);
    _toDate.text = format.format(_quoteToDate!);
  }

  loadData() {
    dashboard.loadQuoteData(country: widget.country, fromDate: _quoteFromDate, toDate: _quoteToDate, client: widget.client);
  }

  late DashboardController dashboard;

  getRadius() {
    var height = ((MediaQuery.of(context).size.width / 3) - 24) * (10 / 19);
    var radius = height * 7 / 20;
    return radius;
  }

  getClientChartData() {
    var radius = getRadius();
    return [
      PieData(label: 'Invoice Amount', value: dashboard.totalInvoiceAmount.convert('INR', currency), color: Colors.deepOrange, radius: radius),
      PieData(label: 'Received', value: dashboard.totalReceivedAmount.convert('INR', currency), color: Colors.grey, radius: radius),
      PieData(label: 'Receivables', value: dashboard.receivables.convert('INR', currency), color: Colors.blue, radius: radius),
      PieData(label: 'Credits', value: dashboard.clientCredits.convert('INR', currency), color: Colors.yellow, radius: radius),
    ];
  }

  getTotalReceivedRemaining() {
    var radius = getRadius();
    return [
      PieData(label: 'Total', value: dashboard.totalQuoteAmount.convert('INR', currency), color: Colors.deepOrange, radius: radius),
      PieData(label: 'Received', value: dashboard.totalReceivedAmount.convert('INR', currency), color: Colors.blue, radius: radius),
      PieData(
          label: 'Remaining',
          value: (dashboard.totalQuoteAmount - dashboard.totalReceivedAmount).convert('INR', currency),
          color: Colors.grey,
          radius: radius),
    ];
  }

  getContractorChartData() {
    var radius = getRadius();
    return [
      PieData(
          label: 'Invoice Amount', value: dashboard.totalContractorInvoiceAmount.convert('INR', currency), color: Colors.deepOrange, radius: radius),
      PieData(label: 'Paid', value: dashboard.totalPaidAmount.convert('INR', currency), color: Colors.blue, radius: radius),
      PieData(label: 'Payables', value: dashboard.payables.convert('INR', currency), color: Colors.grey, radius: radius),
      PieData(label: 'Credits', value: dashboard.contractorCredits.convert('INR', currency), color: Colors.yellow, radius: radius),
    ];
  }

  getPayablesVsReceivables() {
    var radius = getRadius();
    return [
      // PieData(label: 'Payables', value: dashboard.payables.convert('INR', currency), color: Colors.grey, radius: radius),
      // PieData(label: 'Receivables', value: dashboard.receivables.convert('INR', currency), color: Colors.blue, radius: radius),
      PieData(
          label: 'Payables',
          value: (dashboard.totalContractorAmount - dashboard.totalPaidAmount).convert('INR', currency),
          color: Colors.grey,
          radius: radius),
      PieData(
          label: 'Receivables',
          value: (dashboard.totalQuoteAmount - dashboard.totalReceivedAmount).convert('INR', currency),
          color: Colors.blue,
          radius: radius),
    ];
  }

  getQuoteStatement() {
    var radius = getRadius();

    return [
      PieData(label: 'Contractor credits', value: dashboard.contractorCredits.convert('INR', currency), color: Colors.yellow, radius: radius),
      PieData(label: 'Client credits', value: dashboard.clientCredits.convert('INR', currency), color: Colors.green, radius: radius),
      PieData(label: 'Margin Amount', value: dashboard.totalMargin.convert('INR', currency), color: Colors.deepOrange, radius: radius),
      PieData(label: 'Contactor Amount', value: dashboard.totalContractorAmount.convert('INR', currency), color: Colors.blue, radius: radius),
      PieData(label: 'Quote Amount', value: dashboard.totalQuoteAmount.convert('INR', currency), color: Colors.grey, radius: radius),
    ];
  }

  final _fromDate = TextEditingController();
  final _toDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
    loadData();
    return GetBuilder(
        init: dashboard,
        builder: (_) {
          return Card(
            child: Column(
              children: [
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(children: [
                      QuoteDateBox(
                        title: 'Quote Issued Date',
                        hintText: 'From',
                        readOnly: true,
                        onPressed: () async {
                          _quoteFromDate = await showDatePicker(
                                  context: context,
                                  initialDate: _quoteFromDate ?? DateTime.now(),
                                  firstDate: DateTime.utc(2000),
                                  lastDate: DateTime.utc(2050)) ??
                              _quoteFromDate;
                          _fromDate.text = _quoteFromDate == null ? '' : format.format(_quoteFromDate!);
                          setState(() {
                            loadData();
                          });
                        },
                        controler: _fromDate,
                      ),
                      QuoteDateBox(
                        hintText: 'To ',
                        readOnly: true,
                        onPressed: () async {
                          _quoteToDate = await showDatePicker(
                                  context: context,
                                  initialDate: _quoteToDate ?? DateTime.now(),
                                  firstDate: DateTime.utc(2000),
                                  lastDate: DateTime.utc(2050)) ??
                              _quoteToDate;
                          _toDate.text = _quoteToDate == null ? '' : format.format(_quoteToDate!);
                          setState(() {
                            loadData();
                          });
                        },
                        controler: _toDate,
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.bottom,
                        child: ButtonBar(
                          alignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    setCurrentMonth();

                                    loadData();
                                  });
                                },
                                child: Text("Current month")),
                            ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    setLAst30days();
                                    loadData();
                                  });
                                },
                                child: Text("last 30 days"))
                          ],
                        ),
                      ),
                      Container(),
                    ])
                  ],
                ),
                Table(
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: PieStatement(
                            header: Text('QUOTATION STATEMENT', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
                            chartData: getTotalReceivedRemaining(),
                            footer: Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                child: Text("Margin ${dashboard.totalMargin.convert('INR', currency).toStringAsFixed(2)}"),
                              ),
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 8),
                        //   child: PieStatement(
                        //       header: Text('QUOTATION ', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
                        //       chartData: getQuoteStatement()),
                        // ),

                        // RadialBar(
                        //     header: Text('QUOTATION STATEMENT', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
                        //     dataSource: getQuoteStatement()),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: PieStatement(
                              header: Text('PAYABLES / RECEIVABLES', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
                              chartData: getPayablesVsReceivables()),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: PieStatement(
                            header: Text('CLIENT INVOICE STATEMENT', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
                            chartData: getClientChartData(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: PieStatement(
                              header: Text('CONTRACTOR INVOICE STATEMENT', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
                              chartData: getContractorChartData()),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
