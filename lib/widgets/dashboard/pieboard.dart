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
    loadData();
  }

  loadData() {
    dashboard.loadReceivables(country: country, fromDate: _quoteFromDate, toDate: _quoteToDate, client: client);
    dashboard.loadQuoteData(country: country, fromDate: _quoteFromDate, toDate: _quoteToDate, client: client);
    dashboard.loadPayables(country: country, fromDate: _quoteFromDate, toDate: _quoteToDate, client: client);
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
      PieData(label: 'Received', value: dashboard.totalReceivedAmount.convert('INR', currency), color: Colors.blue, radius: radius),
      PieData(label: 'Receivables', value: dashboard.receivables.convert('INR', currency), color: Colors.grey, radius: radius),
      PieData(label: 'Credits', value: dashboard.clientCredits.convert('INR', currency), color: Colors.yellow, radius: radius),
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
      PieData(label: 'Payables', value: dashboard.payables.convert('INR', currency), color: Colors.grey, radius: radius),
      PieData(label: 'Receivables', value: dashboard.receivables.convert('INR', currency), color: Colors.blue, radius: radius),
    ];
  }

  getQuoteStatement() {
    var radius = getRadius();
    return [
      PieData(label: 'Quote Amount', value: dashboard.totalQuoteAmount.convert('INR', currency), color: Colors.grey, radius: radius),
      PieData(label: 'Contactor Amount', value: dashboard.totalContractorAmount.convert('INR', currency), color: Colors.blue, radius: radius),
      PieData(label: 'Margin Amount', value: dashboard.totalMargin.convert('INR', currency), color: Colors.deepOrange, radius: radius),
    ];
  }

  final _fromDate = TextEditingController();
  final _toDate = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                      Container(),
                      Container(),
                    ])
                  ],
                ),
                Divider(),
                Table(
                  children: [
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: PieStatement(
                            // chartData: getChartData(map),
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
                    TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: PieStatement(
                              header: Text('PAYABLES / RECEIVABLES', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
                              chartData: getPayablesVsReceivables()),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: PieStatement(
                              header: Text('QUOTATION ', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20)),
                              chartData: getQuoteStatement()),
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
