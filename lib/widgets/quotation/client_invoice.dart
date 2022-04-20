import 'package:ccm/FormControllers/quotation_form_controller.dart';
import 'package:ccm/widgets/quotation/quote_text_box.dart';
import 'package:flutter/material.dart';

import 'quote_date_picker.dart';

class ClientInvoiceForm extends StatefulWidget {
  const ClientInvoiceForm({Key? key, required this.controller}) : super(key: key);

  final QuotationFormController controller;

  @override
  State<ClientInvoiceForm> createState() => _ClientInvoiceFormState();
}

class _ClientInvoiceFormState extends State<ClientInvoiceForm> {
  QuotationFormController get controller => widget.controller;

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
                child: Text('Client Invoice', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
              ),
            ),
            Divider(),
            ExpansionTile(
              title: Text("Show Invoices"),
              children: [
                DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.white),
                    dataRowColor: MaterialStateProperty.all(Colors.white),
                    columns: [
                      DataColumn(label: Text('Number')),
                      DataColumn(label: Text('Amount')),
                      DataColumn(label: Text('Issued Date')),
                      DataColumn(label: Text('Received Amount')),
                      DataColumn(label: Text('Last Received Date')),
                      DataColumn(label: Text('Credit Amount')),
                      DataColumn(label: Text('Delete')),
                      DataColumn(label: Text('Edit')),
                    ],
                    rows: getSource()),
                SizedBox(height: 20),
              ],
            ),
            Table(
              children: [
                TableRow(children: [
                  QuoteTextBox(controller: controller.invoiceForm.number, hintText: 'Invoice Number'),
                  QuoteTextBox(controller: controller.invoiceForm.amount, hintText: 'Invoice Amount'),
                  QuoteDate(
                    title: 'Issued Date',
                    date: controller.invoiceForm.issuedDate,
                    onPressed: () async {
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.utc(2000),
                        lastDate: DateTime.utc(2100),
                      ).then((value) {
                        setState(() {
                          controller.invoiceForm.issuedDate = value ?? controller.invoiceForm.issuedDate;
                        });
                      });
                    },
                  ),
                  QuoteDate(
                    title: 'Last Received Date',
                    date: controller.invoiceForm.lastReceivedDate,
                  ),
                ]),
                TableRow(children: [
                  QuoteTextBox(
                      readOnly: true,
                      controller: TextEditingController(text: controller.invoiceForm.receivedAmount.toString()),
                      hintText: 'Received Amount'),
                  Container(),
                  Container(),
                  Container(),
                ]),
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
                          print("Invoice Added");
                        },
                        child: Text("Add Invoice")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            controller.updateInvoice();
                          });
                          print("Invoice Updated");
                        },
                        child: Text("Update Invoice")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: () {}, child: Text("Add Payments")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: () {}, child: Text("Add Credits")),
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
    for (int i = 0; i < controller.clientInvoices.length; i++) {
      var e = controller.clientInvoices[i];
      datarows.add(DataRow(cells: [
        DataCell(Text(e.number)),
        DataCell(Text(e.amount.toString())),
        DataCell(Text(format.format(e.issuedDate))),
        DataCell(Text(e.receivedAmount.toString())),
        DataCell(Text(e.lastReceivedDate.toString())),
        DataCell(Text(e.creditAmount.toString())),
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
}
