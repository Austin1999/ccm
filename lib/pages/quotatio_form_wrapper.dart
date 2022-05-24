import 'package:ccm/FormControllers/quotation_form_controller.dart';
import 'package:ccm/pages/quotation_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/sessionController.dart';
import '../models/quote.dart';
import '../services/firebase.dart';
import '../widgets/quotation/invoice_list.dart';
import '../widgets/quotation/quote_date_picker.dart';

class QuotationFormList extends StatefulWidget {
  QuotationFormList({Key? key, this.quotation}) : super(key: key);

  final Quotation? quotation;

  @override
  State<QuotationFormList> createState() => _QuotationFormListState();
}

class _QuotationFormListState extends State<QuotationFormList> {
  @override
  void initState() {
    super.initState();
    populateQuotes();
    selectedQuotation = widget.quotation;
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int val) {
    _selectedIndex = val;
    setState(() {
      selectedQuotation = relatedQuotes[val];
    });
  }

  late Quotation? selectedQuotation;

  List<DataRow> getdataRows() {
    List<DataRow> rows = [];

    for (int i = 0; i < relatedQuotes.length; i++) {
      var e = relatedQuotes[i];

      rows.add(
        DataRow(
          color: MaterialStateProperty.all(i == selectedIndex ? Colors.grey.shade300 : Colors.white),
          cells: [
            DataCell(Text(e.number)),
            DataCell(Text(clientController.getName(e.client))),
            DataCell(Text(e.description)),
            DataCell(Text(e.amount.toStringAsFixed(2))),
            DataCell(Text(e.approvalStatus.toString().split('.').last.toUpperCase())),
            DataCell(Text(e.clientApproval)),
            DataCell(Text(e.margin.toStringAsFixed(2))),
            DataCell(Text(e.ccmTicketNumber)),
            DataCell(Text(e.completionDate == null ? '' : format.format(e.completionDate!))),
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
                icon: Icon(Icons.insert_drive_file_outlined))),
            DataCell(IconButton(
                onPressed: () {
                  selectedIndex = i;
                },
                icon: Icon(Icons.edit))),
          ],
        ),
      );
    }
    return rows;
  }

  List<Quotation> relatedQuotes = [];

  Future<List<Quotation>> populateQuotes() async {
    List<Quotation> relatedQuotes = [];
    if (widget.quotation != null) {
      relatedQuotes = await quotations.where('parentQuote', isEqualTo: widget.quotation!.number).get().then((value) {
        return value.docs.map((e) => Quotation.fromJson(e.data())).toList();
      });
      relatedQuotes.insert(0, widget.quotation!);
    }
    return relatedQuotes;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: FutureBuilder<List<Quotation>>(
                future: populateQuotes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                    relatedQuotes = snapshot.data ?? [];

                    return Table(
                      children: [
                        TableRow(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: DataTable(
                                  headingRowColor: MaterialStateProperty.all(Colors.white),
                                  dataRowColor: MaterialStateProperty.all(Colors.white),
                                  columns: [
                                    DataColumn(label: Text("QUOTE NUMBER")),
                                    DataColumn(label: Text("CLIENT")),
                                    DataColumn(label: Text("DESCRIPTION")),
                                    DataColumn(label: Text("AMOUNT")),
                                    DataColumn(label: Text("STATUS")),
                                    DataColumn(label: Text("CLIENT PO")),
                                    DataColumn(label: Text("MARGIN")),
                                    DataColumn(label: Text("CCM TICKET")),
                                    DataColumn(label: Text("COMPLETION DATE")),
                                    DataColumn(label: Text("INVOICES")),
                                    DataColumn(label: Text("EDIT")),
                                  ],
                                  rows: getdataRows()),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          ),
        ),
        Expanded(
            child: GetBuilder(
                init: QuotationFormState.instance,
                builder: (_) {
                  return QuotationForm(
                    quotation: selectedQuotation,
                  );
                }))
      ],
    );
  }
}

enum FormMode { add, update }
