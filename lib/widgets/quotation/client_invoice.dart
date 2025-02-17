import 'package:ccm/FormControllers/quotation_form_controller.dart';
import 'package:ccm/widgets/quotation/credits.dart';
import 'package:ccm/widgets/quotation/payments.dart';
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
  void initState() {
    issuedDateController.text = controller.invoiceForm.issuedDate == null ? '' : format.format(controller.invoiceForm.issuedDate!);
    super.initState();
  }

  final issuedDateController = TextEditingController();

  void refresh() {
    setState(() {});
  }

  String? _requiredValidator(String? number) {
    if ((number ?? '').isEmpty) {
      return 'Field should not be empty';
    }
    return null;
  }

  String? _requiredDuplicateValidator(String? number) {
    if ((number ?? '').isEmpty) {
      return 'Field should not be empty';
    }
    if (controller.clientInvoices.where((element) => element.number == number).isNotEmpty) {
      return 'Duplicate number';
    }
    return null;
  }

  String? _amountValidator(String? p1) {
    try {
      double.parse(p1.toString());
    } catch (e) {
      return 'Amount should be numbers and not empty';
    }

    var amount = double.parse(p1 ?? '');
    double invoiceTotal = controller.clientInvoices.fold(0, (previousValue, element) => previousValue + element.amount);
    invoiceTotal += amount;

    if (invoiceTotal > double.parse(controller.amount.text)) {
      return 'Invoice amount should not be exceeding quote amount';
    }

    return null;
  }

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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Table(
                children: [
                  TableRow(
                    children: [
                      Card(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DataTable(
                              headingRowColor: MaterialStateProperty.all(Colors.white),
                              dataRowColor: MaterialStateProperty.all(Colors.white),
                              columns: [
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
                              ],
                              rows: getSource()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Form(
              key: controller.invoiceForm.invoiceFormKey,
              child: Table(
                children: [
                  TableRow(children: [
                    QuoteTextBox(controller: controller.invoiceForm.number, hintText: 'Invoice Number', validator: _requiredDuplicateValidator),
                    QuoteTextBox(controller: controller.invoiceForm.amount, hintText: 'Invoice Amount', validator: _amountValidator),
                    QuoteDateBox(
                      hintText: 'Issued Date',
                      controler: issuedDateController,
                      title: 'Issued Date',
                      validator: _requiredValidator,
                      onPressed: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: controller.invoiceForm.issuedDate ?? DateTime.now(),
                          firstDate: DateTime.utc(2000),
                          lastDate: DateTime.utc(2100),
                        ).then((value) {
                          setState(() {
                            controller.invoiceForm.issuedDate = value ?? controller.invoiceForm.issuedDate;
                            issuedDateController.text =
                                controller.invoiceForm.issuedDate == null ? '' : format.format(controller.invoiceForm.issuedDate!);
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
                          setState(() {
                            controller.updateInvoice();
                          });
                        },
                        child: Text("Update Invoice")),
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
      datarows.add(
        DataRow(
          color: MaterialStateProperty.all(
            controller.selectedInvoice == i ? Colors.grey.shade300 : Colors.white,
          ),
          cells: [
            DataCell(Text(e.number)),
            DataCell(Text(e.amount.toString())),
            DataCell(Text(format.format(e.issuedDate))),
            DataCell(Text(e.closedAmount.toString())),
            DataCell(Text(e.lastReceivedDate == null ? '' : format.format(e.lastReceivedDate!))),
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
                    issuedDateController.text = format.format(controller.invoiceForm.issuedDate!);
                  });
                },
                icon: Icon(Icons.edit))),
          ],
        ),
      );
    }

    return datarows;
  }
}
