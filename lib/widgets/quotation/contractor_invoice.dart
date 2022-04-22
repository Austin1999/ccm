import 'package:ccm/FormControllers/quotation_form_controller.dart';
import 'package:ccm/widgets/quotation/payments.dart';
import 'package:ccm/widgets/quotation/quote_drop_down.dart';
import 'package:ccm/widgets/quotation/quote_text_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../FormControllers/invoice_form_controller.dart';
import '../../FormControllers/po_form_controller.dart';
import 'credits.dart';
import 'quote_date_picker.dart';

class ContractorInvoiceForm extends StatefulWidget {
  const ContractorInvoiceForm({Key? key, required this.controller}) : super(key: key);

  final ContractorPoFormController controller;

  @override
  State<ContractorInvoiceForm> createState() => _ContractorInvoiceFormState();
}

class _ContractorInvoiceFormState extends State<ContractorInvoiceForm> {
  ContractorPoFormController get controller => widget.controller;
  InvoiceFormController get invoiceForm => widget.controller.invoiceForm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        color: Color(0xFFE8F3FA),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Contractor Invoice', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
              ),
            ),
            Divider(),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: DataTable(columns: [
                  DataColumn(label: Text('Number')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Issued Date')),
                  DataColumn(label: Text('Received Amount')),
                  DataColumn(label: Text('Last Received Date')),
                  DataColumn(label: Text('Credit Amount')),
                  DataColumn(label: Text('Payments')),
                  DataColumn(label: Text('Credits')),
                  DataColumn(label: Text('Delete')),
                  DataColumn(label: Text('Edit')),
                ], rows: getSource()),
              ),
            ),
            Table(
              children: [
                TableRow(children: [
                  QuoteTextBox(controller: invoiceForm.number, hintText: 'Invoice Number'),
                  QuoteTextBox(controller: invoiceForm.amount, hintText: 'Invoice Amount'),
                  QuoteDate(
                    title: 'Invoice Received Date',
                    date: invoiceForm.issuedDate,
                    onPressed: () async {
                      invoiceForm.issuedDate = await showDatePicker(
                        context: context,
                        initialDate: invoiceForm.issuedDate ?? DateTime.now(),
                        firstDate: DateTime.utc(2000),
                        lastDate: DateTime.utc(2100),
                      );
                      setState(() {});
                    },
                  ),
                  QuoteTextBox(controller: invoiceForm.taxNumber, hintText: 'Tax Number'),
                ]),
                TableRow(
                  children: [
                    QuoteTextBox(
                      controller: TextEditingController(text: invoiceForm.receivedAmount.toString()),
                      hintText: 'Paid Amount',
                      readOnly: true,
                    ),
                    QuoteDate(
                      title: 'Invoice Received Date',
                      date: invoiceForm.lastReceivedDate,
                    ),
                    Container(),
                    Container(),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            controller.addInvoice();
                          });
                        },
                        child: Text("Add Invoice")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          controller.updateInvoice();
                        },
                        child: Text("Edit Invoice")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  getSource() {
    List<DataRow> datarows = [];
    for (int i = 0; i < controller.invoices.length; i++) {
      var e = controller.invoices[i];
      datarows.add(DataRow(color: MaterialStateProperty.all(controller.selectedInvoice == i ? Colors.blue.shade50 : Colors.white), cells: [
        DataCell(Text(e.number)),
        DataCell(Text(e.amount.toString())),
        DataCell(Text(format.format(e.issuedDate))),
        DataCell(Text(e.receivedAmount.toString())),
        DataCell(Text(e.lastReceivedDate == null ? 'No Payments' : format.format(e.lastReceivedDate!))),
        DataCell(Text(e.creditAmount.toString())),
        DataCell(ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return PaymentForm(invoice: e, callback: refresh);
                  });
            },
            child: Text('Payments'))),
        DataCell(ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CreditForm(invoice: e, callback: refresh);
                  });
            },
            child: Text('Credits'))),
        DataCell(IconButton(
            onPressed: () {
              setState(() {
                controller.deleteInvoice(i);
              });
            },
            icon: Icon(Icons.delete))),
        DataCell(IconButton(
            onPressed: () {
              setState(() {
                controller.selectedInvoice = i;
              });
            },
            icon: Icon(Icons.edit))),
      ]));
    }

    return datarows;
  }

  void refresh() {
    setState(() {});
  }
}
