import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/quote.dart';
import 'package:ccm/models/response.dart';
import 'package:ccm/pages/quotation_form.dart';
import 'package:ccm/services/firebase.dart';
import 'package:ccm/widgets/quotation/invoice_list.dart';
import 'package:ccm/widgets/quotation/quote_date_picker.dart';
import 'package:ccm/widgets/quotation/quote_drop_down.dart';
import 'package:ccm/widgets/quotation/quote_text_box.dart';
import 'package:ccm/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CwrSummary extends StatefulWidget {
  CwrSummary({Key? key}) : super(key: key);

  @override
  State<CwrSummary> createState() => _CwrSummaryState();
}

class _CwrSummaryState extends State<CwrSummary> {
  @override
  void initState() {
    filter();
    super.initState();
  }

  final searchController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  OverallStatus? overallStatus;
  ApprovalStatus? approvalStatus;
  late Query<Map<String, dynamic>> query;
  List<Quotation> quotationList = [];

  filter() {
    query = quotations;
    if (fromDate != null) {
      query = query.where('issuedDate', isGreaterThanOrEqualTo: fromDate);
    }
    if (toDate != null) {
      query = query.where('issuedDate', isLessThanOrEqualTo: toDate);
    }
    if (approvalStatus != null) {
      query = query.where('approvalStatus', isEqualTo: approvalStatus!.index);
    }
    if (overallStatus != null) {
      query = query.where('overallStatus', isEqualTo: overallStatus!.index);
    }

    if (searchController.text.isNotEmpty) {
      query = query.where('search', arrayContains: searchController.text.toLowerCase());
    }

    // query = query.orderBy('id');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF3A5F85)),
      backgroundColor: Color(0xFFFAFAFA),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(session.country!.name.toUpperCase(), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
            ),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  searchController.clear();
                  fromDate = null;
                  toDate = null;
                  overallStatus = null;
                  approvalStatus = null;
                });
                filter();
              },
              child: Text('Clear Filters')),
          Card(
            color: Color(0xFFE8F3FA),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                  4: FlexColumnWidth(2),
                },
                children: [
                  TableRow(children: [
                    QuoteTextBox(
                      controller: searchController,
                      onChanged: (val) {
                        if ((val).isEmpty) {
                          setState(() {
                            filter();
                          });
                        }
                      },
                      hintText: 'Search',
                      trailing: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: GestureDetector(
                            child: MouseRegion(cursor: SystemMouseCursors.click, child: Icon(Icons.search)),
                            onTap: () {
                              filter();
                              setState(() {});
                            },
                          )),
                    ),
                    QuoteDate(
                        title: 'From',
                        date: fromDate,
                        onPressed: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.utc(2000),
                            lastDate: DateTime.utc(2100),
                          ).then((value) {
                            setState(() {
                              fromDate = value ?? fromDate;
                              filter();
                            });
                          });
                        }),
                    QuoteDate(
                      title: 'To',
                      date: toDate,
                      onPressed: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.utc(2000),
                          lastDate: DateTime.utc(2100),
                        ).then((value) {
                          setState(() {
                            toDate = value ?? toDate;
                            filter();
                          });
                        });
                      },
                    ),
                    QuoteDropdown<OverallStatus?>(
                      value: overallStatus,
                      title: 'Overall Status',
                      onChanged: (value) {
                        setState(() {
                          overallStatus = value;
                          filter();
                        });
                      },
                      items: overallStatusItems(),
                    ),
                    QuoteDropdown<ApprovalStatus?>(
                      value: approvalStatus,
                      title: 'Approval Status',
                      onChanged: (value) {
                        setState(() {
                          approvalStatus = value;
                          filter();
                        });
                      },
                      items: approvalStatusItems(),
                    ),
                  ])
                ],
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: query.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                var docs = snapshot.data?.docs ?? [];
                List<Quotation> quotes = [];
                try {
                  quotes = docs.map((e) => Quotation.fromJson(e.data())).toList();
                } catch (e) {
                  print(e.toString());
                  print("I have error ^");
                  quotes = [];
                }

                var source = QuoteDatasource(quotes, context);

                return Theme(
                  data: Theme.of(context).copyWith(
                    cardTheme: CardTheme(color: Colors.white),
                    cardColor: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: PaginatedDataTable(
                            showFirstLastButtons: true,
                            rowsPerPage: 10,
                            columns: [
                              DataColumn(label: Text('Edit')),
                              DataColumn(label: Text('Invoice')),
                              DataColumn(label: Text('Quote')),
                              DataColumn(label: Text('Issued on')),
                              DataColumn(label: Text('Client')),
                              DataColumn(label: Text('Description')),
                              DataColumn(label: Text('Amount')),
                              DataColumn(label: Text('status')),
                              DataColumn(label: Text('Client PO')),
                              DataColumn(label: Text('Margin')),
                              DataColumn(label: Text('CCM Ticket')),
                              DataColumn(label: Text('Completion Date')),
                              DataColumn(label: Text('Delete')),
                            ],
                            source: source,
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                // return SingleChildScrollView(
                //   child: DataTable(
                //       columns: [
                // DataColumn(label: Text('Edit')),
                // DataColumn(label: Text('Invoice')),
                // DataColumn(label: Text('Quote')),
                // DataColumn(label: Text('Issued on')),
                // DataColumn(label: Text('Client')),
                // DataColumn(label: Text('Description')),
                // DataColumn(label: Text('Amount')),
                // DataColumn(label: Text('status')),
                // DataColumn(label: Text('Client PO')),
                // DataColumn(label: Text('Margin')),
                // DataColumn(label: Text('CCM Ticket')),
                // DataColumn(label: Text('Completion Date')),
                // DataColumn(label: Text('Delete')),
                //       ],
                //       rows: quotes
                //           .map((e) => DataRow(cells: [
                //                 DataCell(IconButton(
                //                     onPressed: () {
                //                       Get.to(() => QuotationForm(quotation: e));
                //                     },
                //                     icon: Icon(
                //                       Icons.edit,
                //                       color: Colors.indigo,
                //                     ))),
                //                 DataCell(IconButton(
                //                     onPressed: () {},
                //                     icon: Icon(
                //                       Icons.insert_drive_file,
                //                       color: Colors.indigo,
                //                     ))),
                //                 DataCell(Text(e.number)),
                //                 DataCell(Text(format.format(e.issuedDate))),
                //                 DataCell(Text(e.client)),
                //                 DataCell(Text(e.description)),
                //                 DataCell(Text(e.amount.toString())),
                //                 DataCell(Text(e.approvalStatus.toString().split('.').last.toUpperCase())),
                //                 DataCell(Text(e.clientApproval.toString())),
                //                 DataCell(Text(e.margin.toStringAsFixed(2))),
                //                 DataCell(Text(e.ccmTicketNumber.toString())),
                //                 DataCell(Text(e.completionDate == null ? '' : format.format(e.completionDate!))),
                //                 DataCell(IconButton(
                //                     onPressed: () {
                //                       var future = quotations.doc(e.id).delete().then((value) => Result.success("Deleted Successfully"));
                //                       showFutureDialog(context: context, future: future);
                //                     },
                //                     icon: Icon(
                //                       Icons.delete,
                //                       color: Colors.red,
                //                     ))),
                //               ]))
                //           .toList()),
                // );
              }
              if (snapshot.hasError) {
                print("I have error");
                print(snapshot.error);
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<OverallStatus?>> overallStatusItems() {
    var list = OverallStatus.values.map((e) {
      return DropdownMenuItem(
        child: Text(e.toString().split('.').last.toUpperCase()),
        value: e,
      );
    }).toList();
    list.add(DropdownMenuItem(child: Text("ALL QUOTATIONS")));
    return list;
  }

  List<DropdownMenuItem<ApprovalStatus?>> approvalStatusItems() {
    var list = ApprovalStatus.values.map((e) {
      return DropdownMenuItem(
        child: Text(e.toString().split('.').last.toUpperCase()),
        value: e,
      );
    }).toList();
    list.add(DropdownMenuItem(child: Text("ALL QUOTATIONS")));
    return list;
  }
}

class QuoteDatasource extends DataTableSource {
  final List<Quotation> quoteList;
  final BuildContext context;

  QuoteDatasource(this.quoteList, this.context);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= quoteList.length) return null;
    final e = quoteList[index];
    return DataRow.byIndex(index: index, cells: [
      DataCell(IconButton(
          onPressed: () {
            Get.to(() => QuotationForm(quotation: e));
          },
          icon: Icon(
            Icons.edit,
            color: Colors.indigo,
          ))),
      DataCell(IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  List<Widget> children = [];
                  children.add(Text("Client Invoices"));
                  children.add(InvoiceList(invoices: e.clientInvoices));
                  e.contractorPo.forEach((element) {
                    children.add(InvoiceList(invoices: element.invoices));
                  });
                  return Dialog(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: children,
                    ),
                  );
                });
          },
          icon: Icon(
            Icons.insert_drive_file,
            color: Colors.indigo,
          ))),
      DataCell(SelectableText(e.number)),
      DataCell(SelectableText(format.format(e.issuedDate))),
      DataCell(SelectableText(e.client)),
      DataCell(SelectableText(e.description)),
      DataCell(SelectableText(e.amount.toString())),
      DataCell(SelectableText(e.approvalStatus.toString().split('.').last.toUpperCase())),
      DataCell(SelectableText(e.clientApproval.toString())),
      DataCell(SelectableText(e.margin.toStringAsFixed(2))),
      DataCell(SelectableText(e.ccmTicketNumber.toString())),
      DataCell(SelectableText(e.completionDate == null ? '' : format.format(e.completionDate!))),
      DataCell(IconButton(
          onPressed: () {
            var future = quotations.doc(e.id).delete().then((value) => Result.success("Deleted Successfully"));
            showFutureDialog(context: context, future: future);
          },
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ))),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => quoteList.length;

  @override
  int get selectedRowCount => 0;
}
