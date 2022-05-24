import 'package:ccm/controllers/sessionController.dart';
import 'package:ccm/models/quote.dart';
import 'package:ccm/services/firebase.dart';
import 'package:ccm/widgets/quotation/invoice_list.dart';
import 'package:ccm/widgets/quotation/multiselect.dart';
import 'package:ccm/widgets/quotation/quote_date_picker.dart';
import 'package:ccm/widgets/quotation/quote_drop_down.dart';
import 'package:ccm/widgets/quotation/quote_text_box.dart';
import 'package:ccm/widgets/widget.dart';
import 'package:flutter/material.dart';

class CwrTrashSummary extends StatefulWidget {
  CwrTrashSummary({Key? key}) : super(key: key);

  @override
  State<CwrTrashSummary> createState() => _CwrTrashSummaryState();
}

class _CwrTrashSummaryState extends State<CwrTrashSummary> {
  @override
  void initState() {
    // Get.put(ClientController());
    filter();
    super.initState();
  }

  List<String> selectedItems = [];

  final searchController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  OverallStatus? overallStatus;
  ApprovalStatus? approvalStatus;
  late Query<Map<String, dynamic>> query;
  List<Quotation> quotationList = [];

  filter() {
    query = trashQuotations;
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
      appBar: AppBar(
          backgroundColor: Color(0xFF3A5F85),
          centerTitle: true,
          title: Text(
            "TRASHED QUOTES",
          )),
      backgroundColor: Color(0xFFFAFAFA),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(session.country!.name.toUpperCase(), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
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
                    child: Icon(Icons.filter_alt_off)),
              )
            ],
          ),
          Card(
            color: Color(0xFFE8F3FA),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                  4: FlexColumnWidth(2),
                  5: FlexColumnWidth(2),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: ListTile(
                        title: Text("Clients"),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Card(
                            color: Colors.white,
                            child: DropDownMultiSelect(
                                options: clientController.clientlist.map((e) => e.name).toList(),
                                selectedValues: selectedItems,
                                onChanged: (val) {
                                  setState(() {
                                    selectedItems = val;
                                  });
                                },
                                decoration: InputDecoration(border: OutlineInputBorder(), fillColor: Colors.white),
                                whenEmpty: 'Select client'),
                          ),
                        ),
                      ),
                    )
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
                  quotes = [];
                }

                if (selectedItems.isNotEmpty) {
                  var temp = [];
                  temp = selectedItems.map((e) => clientController.getIdByName(e).docid).toList();
                  quotes = quotes.where((element) => temp.contains(element.client)).toList();
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
                              DataColumn(label: Text('Restore')),
                              DataColumn(label: Text('Invoice')),
                              DataColumn(label: Text('Child Quotes')),
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
            var future = trashQuotations.doc(e.id).delete().then((value) => e.add());
            showFutureDialog(context: context, future: future);
          },
          icon: Icon(
            Icons.restore,
            color: Colors.indigo,
          ))),
      DataCell(IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  List<Widget> children = [];
                  children.add(Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Client Invoices".toUpperCase()),
                  ));
                  children.add(InvoiceList(invoices: e.clientInvoices, poNumber: e.clientApproval));
                  children.add(const Divider());
                  children.add(Text("Contractor Invoices".toUpperCase()));
                  e.contractorPo.forEach((element) {
                    children.add(InvoiceList(invoices: element.invoices, poNumber: element.number));
                    children.add(const Divider());
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
      DataCell(IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return FutureBuilder<List<DataRow>>(
                      future: getChildQuotes(e.number),
                      builder: (context, snapshot) {
                        List<DataRow> rows = [];
                        if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                          rows = snapshot.data ?? [];

                          if (rows.isEmpty) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AlertDialog(
                                  content: Center(
                                    child: Text("No child quotes available"),
                                  ),
                                ),
                              ],
                            );
                          }

                          return AlertDialog(
                            content: DataTable(columns: [
                              DataColumn(label: Text('Restore')),
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
                            ], rows: rows),
                          );
                        }
                        if (snapshot.hasError) {
                          return AlertDialog(content: Center(child: Text("Error occurred, Please try again..")));
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      });
                });
          },
          icon: Icon(
            Icons.view_agenda,
            color: Colors.indigo,
          ))),
      DataCell(SelectableText(e.number)),
      DataCell(SelectableText(format.format(e.issuedDate))),
      DataCell(SelectableText(clientController.getName(e.client))),
      DataCell(SelectableText(e.description)),
      DataCell(SelectableText(e.amount.toString())),
      DataCell(SelectableText(e.approvalStatus.toString().split('.').last.toUpperCase())),
      DataCell(SelectableText(e.clientApproval.toString())),
      DataCell(SelectableText(e.margin.toStringAsFixed(2))),
      DataCell(SelectableText(e.ccmTicketNumber.toString())),
      DataCell(SelectableText(e.completionDate == null ? '' : format.format(e.completionDate!))),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => quoteList.length;

  @override
  int get selectedRowCount => 0;

  Future<List<DataRow>> getChildQuotes(String number) async {
    List<DataRow> rows = [];

    return quotations.where("parentQuote", isEqualTo: number).get().then((value) {
      value.docs.forEach((element) {
        var q = Quotation.fromJson(element.data());

        var row = DataRow(
          color: q.overallStatus == OverallStatus.completed ? MaterialStateProperty.all(Colors.green) : null,
          cells: [
            DataCell(IconButton(
                onPressed: () {
                  var future = trashQuotations.doc(q.id).delete().then((value) => q.add());
                  showFutureDialog(context: context, future: future);
                },
                icon: Icon(
                  Icons.restore,
                  color: Colors.indigo,
                ))),
            DataCell(IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        List<Widget> children = [];
                        children.add(Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Client Invoices".toUpperCase()),
                        ));
                        children.add(InvoiceList(invoices: q.clientInvoices, poNumber: q.clientApproval));
                        children.add(const Divider());
                        children.add(Text("Contractor Invoices".toUpperCase()));
                        q.contractorPo.forEach((element) {
                          children.add(InvoiceList(invoices: element.invoices, poNumber: element.number));
                          children.add(const Divider());
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
            DataCell(SelectableText(q.number)),
            DataCell(SelectableText(format.format(q.issuedDate))),
            DataCell(SelectableText(clientController.getName(q.client))),
            DataCell(SelectableText(q.description)),
            DataCell(SelectableText(q.amount.toString())),
            DataCell(SelectableText(q.approvalStatus.toString().split('.').last.toUpperCase())),
            DataCell(SelectableText(q.clientApproval.toString())),
            DataCell(SelectableText(q.margin.toStringAsFixed(2))),
            DataCell(SelectableText(q.ccmTicketNumber.toString())),
            DataCell(SelectableText(q.completionDate == null ? '' : format.format(q.completionDate!))),
          ],
        );
        rows.add(row);
      });

      return rows;
    });
  }
}
