import 'package:ccm/FormControllers/quotation_form_controller.dart';
import 'package:ccm/widgets/quotation/quote_drop_down.dart';
import 'package:ccm/widgets/quotation/quote_text_box.dart';
import 'package:flutter/material.dart';

import '../../FormControllers/invoice_form_controller.dart';
import '../../FormControllers/po_form_controller.dart';
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
            ExpansionTile(
              title: Text("Show invoices"),
              children: [
                Text("hello"),
              ],
            ),
            Table(
              children: [
                TableRow(children: [
                  QuoteTextBox(controller: invoiceForm.number, hintText: 'Invoice Number'),
                  QuoteTextBox(controller: invoiceForm.amount, hintText: 'Invoice Amount'),
                  QuoteDate(
                    title: 'Invoice Received Date',
                    date: controller.issuedDate,
                    onPressed: () async {
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.utc(2000),
                        lastDate: DateTime.utc(2100),
                      ).then((value) {
                        setState(() {
                          controller.issuedDate = value ?? controller.issuedDate;
                        });
                      });
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
                          controller.addInvoice();
                        },
                        child: Text("Add Invoice")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: () {}, child: Text("Edit Invoice")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: () {}, child: Text("Payments")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: () {}, child: Text("Credits")),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
