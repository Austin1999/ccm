import 'package:ccm/widgets/quotation/payments.dart';
import 'package:ccm/widgets/quotation/quote_text_box.dart';
import 'package:flutter/material.dart';

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
  InvoiceFormController get invoiceForm => controller.invoiceForm;

  @override
  void initState() {
    issuedDateController.text = invoiceForm.issuedDate == null ? '' : format.format(invoiceForm.issuedDate!);
    super.initState();
  }

  final issuedDateController = TextEditingController();

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
    if (controller.invoices.where((element) => element.number == number).isNotEmpty) {
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
    double invoiceTotal = controller.invoices.fold(0, (previousValue, element) => previousValue + element.amount);
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
        child: Form(
          key: invoiceForm.invoiceFormKey,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Table(
                  children: [
                    TableRow(
                      children: [
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
                      ],
                    ),
                  ],
                ),
              ),
              Table(
                children: [
                  TableRow(children: [
                    QuoteTextBox(controller: invoiceForm.number, hintText: 'Invoice Number', validator: _requiredDuplicateValidator),
                    QuoteTextBox(controller: invoiceForm.amount, hintText: 'Invoice Amount', validator: _amountValidator),
                    QuoteDateBox(
                      hintText: 'Invoice Received Date',
                      validator: _requiredValidator,
                      title: 'Received Date',
                      controler: issuedDateController,
                      onPressed: () async {
                        invoiceForm.issuedDate = await showDatePicker(
                          context: context,
                          initialDate: invoiceForm.issuedDate ?? DateTime.now(),
                          firstDate: DateTime.utc(2000),
                          lastDate: DateTime.utc(2100),
                        );
                        setState(() {
                          issuedDateController.text = invoiceForm.issuedDate == null ? '' : format.format(invoiceForm.issuedDate!);
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
                          child: Text("Edit Invoice")),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getSource() {
    List<DataRow> datarows = [];
    for (int i = 0; i < controller.invoices.length; i++) {
      var e = controller.invoices[i];
      datarows.add(
        DataRow(
          color: MaterialStateProperty.all(controller.selectedInvoice == i ? Colors.grey.shade300 : Colors.white),
          cells: [
            DataCell(Text(e.number)),
            DataCell(Text(e.amount.toString())),
            DataCell(Text(format.format(e.issuedDate))),
            DataCell(Text(e.closedAmount.toString())),
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
                    controller.selectedInvoice = null;
                  });
                },
                icon: Icon(Icons.delete))),
            DataCell(IconButton(
                onPressed: () {
                  setState(() {
                    controller.selectedInvoice = i;
                    issuedDateController.text = controller.invoiceForm.issuedDate == null ? '' : format.format(controller.invoiceForm.issuedDate!);
                  });
                },
                icon: Icon(Icons.edit))),
          ],
        ),
      );
    }

    return datarows;
  }

  void refresh() {
    setState(() {});
  }
}
