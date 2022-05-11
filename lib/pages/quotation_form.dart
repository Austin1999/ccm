import 'dart:async';

import 'package:ccm/FormControllers/quotation_form_controller.dart';
import 'package:ccm/controllers/getControllers.dart';
import 'package:ccm/controllers/getx_controllers.dart';

import 'package:ccm/models/quote.dart';
import 'package:ccm/pages/comments.dart';
import 'package:ccm/widgets/quotation/client_invoice.dart';
import 'package:ccm/widgets/quotation/client_quotation.dart';
import 'package:ccm/widgets/quotation/contractor_quotation.dart';
import 'package:ccm/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/quotation/invoice_list.dart';
import '../widgets/quotation/quote_date_picker.dart';

class QuotationForm extends StatefulWidget {
  QuotationForm({Key? key, this.quotation}) : super(key: key);

  final Quotation? quotation;

  @override
  State<QuotationForm> createState() => _QuotationFormState();
}

class _QuotationFormState extends State<QuotationForm> {
  @override
  void initState() {
    print("initalizing state");
    super.initState();
    if (widget.quotation != null) {
      timer = Timer.periodic(Duration(seconds: 5), (timer) {
        databaseRef.child('session').child(widget.quotation!.id.toString()).child(authController.auth.currentUser!.uid).set({
          "time": DateTime.now().millisecondsSinceEpoch,
          "quote": widget.quotation!.id,
          "uid": authController.auth.currentUser!.uid,
          "name": authController.auth.currentUser!.displayName
        });
      });
    }
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  late QuotationFormState _formState;

  QuotationFormController get controller => _formState.controller;

  Timer? timer;

  List<String> uids = [];
  List<Quotation> get relatedQuotes => _formState.relatedQuotes;
  int selectedIndex = 0;

  List<DataRow> getdataRows(StateSetter setstate) {
    List<DataRow> rows = [];

    for (int i = 0; i < relatedQuotes.length; i++) {
      var e = relatedQuotes[i];
      print(i);
      rows.add(
        DataRow(
          color: MaterialStateProperty.all(selectedIndex == i ? Colors.grey.shade300 : Colors.white),
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
                  _formState.controller = QuotationFormController.fromQuotation(e);
                  _formState.notifyChildrens();
                  _formState.update();
                  setstate(() {
                    selectedIndex = i;
                  });
                },
                icon: Icon(Icons.edit))),
          ],
        ),
      );
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    Get.put(ClientController());

    Get.put(QuotationFormState(widget.quotation), tag: widget.quotation?.id ?? 'EmptyQuote');
    _formState = Get.find(tag: widget.quotation?.id ?? 'EmptyQuote');

    if (widget.quotation != null) {
      databaseRef.child('session').child(widget.quotation!.id.toString()).onChildChanged.listen((event) {
        var value = event.snapshot.value as Map<String, dynamic>;
        if (value["uid"] != authController.auth.currentUser!.uid) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Another user has opened this quote")));
        }
      });
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF3A5F85),
          title: Text('In a world of gray, CCM provides clarity to all construction & facility projects'),
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return CommentsList(comments: controller.comments);
                  },
                );
              },
              icon: Icon(Icons.chat_bubble),
            ),
          ],
        ),
        floatingActionButton: ElevatedButton(
            onPressed: () async {
              if (controller.quoteFormKey.currentState!.validate()) {
                var quotation = controller.object;
                var future;
                if (widget.quotation == null) {
                  future = quotation.add();
                } else {
                  future = quotation.update(checkNumber: quotation.number != widget.quotation!.number);
                }
                showFutureDialog(context: context, future: future);
              }
            },
            child: Text("Submit")),
        body: GetBuilder(
            init: _formState,
            builder: (_) {
              return SingleChildScrollView(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: StatefulBuilder(builder: (context, setstate) {
                                  return DataTable(
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
                                      rows: getdataRows(setstate));
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ClientQuotation(controller: controller),
                  ClientInvoiceForm(controller: controller),
                  ContractorPoForm(controller: controller),
                  SizedBox(
                    height: 40.0,
                  ),
                ],
              ));
            }),
      ),
    );
  }
}
