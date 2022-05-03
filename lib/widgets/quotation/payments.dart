import 'package:ccm/models/quote.dart';
import 'package:ccm/widgets/quotation/quote_date_picker.dart';
import 'package:ccm/widgets/quotation/quote_text_box.dart';
import 'package:flutter/material.dart';

class PaymentForm extends StatefulWidget {
  PaymentForm({Key? key, required this.invoice, this.callback}) : super(key: key);
  final Invoice invoice;
  final void Function()? callback;

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final amount = TextEditingController();

  DateTime? date;

  String amountError = '';
  String dateError = '';

  validate() {
    bool result = true;
    try {
      var mount = double.parse(amount.text);
      if (widget.invoice.closedAmount + mount > widget.invoice.amount) {
        setState(() {
          amountError = 'Payments should not exceed invoice amount';
          result = false;
        });
      }
    } catch (e) {
      setState(() {
        amountError = 'Amount should be number and not empty';
        result = false;
      });
    }
    if (date == null) {
      setState(() {
        dateError = 'Date should not be empty';
        result = false;
      });
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 160, vertical: 96),
      backgroundColor: Color(0xFFE8F3FA),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.callback!();
                },
                icon: Icon(Icons.arrow_back_ios)),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('PAYMENTS', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
              ),
            ),
          ),
          Divider(),
          Table(
            children: [
              TableRow(children: [
                QuoteTextBox(
                  hintText: 'Invoice Number',
                  controller: TextEditingController(text: widget.invoice.number),
                  readOnly: true,
                ),
                QuoteTextBox(hintText: 'Invoice Amount', controller: TextEditingController(text: widget.invoice.amount.toString()), readOnly: true),
                QuoteTextBox(
                    hintText: 'Issued Date', controller: TextEditingController(text: format.format(widget.invoice.issuedDate)), readOnly: true),
              ]),
              TableRow(children: [
                Column(
                  children: [
                    QuoteTextBox(
                      controller: amount,
                      hintText: 'Payment Amount',
                      onTap: () {
                        setState(() {
                          amountError = '';
                        });
                      },
                    ),
                    Text(
                      amountError,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                Column(
                  children: [
                    QuoteDate(
                      title: 'Payment date',
                      date: date,
                      onPressed: () async {
                        date = await showDatePicker(
                          context: context,
                          initialDate: date ?? DateTime.now(),
                          firstDate: DateTime.utc(2000),
                          lastDate: DateTime.utc(2100),
                        );
                        setState(() {
                          if (date != null) {
                            dateError = '';
                          }
                        });
                      },
                    ),
                    Text(
                      dateError,
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 48, left: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              if (validate()) {
                                setState(() {
                                  widget.invoice.payments.add(Payment(amount: double.parse(amount.text), date: date!));
                                });
                              }
                            },
                            child: Text("Add Payment")),
                      ],
                    ),
                  ),
                ),
              ])
            ],
          ),
          Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                color: Colors.white,
                child: DataTable(columns: [
                  DataColumn(label: Text('S.No')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Delete')),
                ], rows: getRows()),
              ),
            ),
          )
        ],
      ),
    );
  }

  getRows() {
    List<DataRow> rows = [];
    int length = widget.invoice.payments.length;

    for (int i = 0; i < length; i++) {
      Payment payment = widget.invoice.payments[i];
      rows.add(DataRow(cells: [
        DataCell(Text((i + 1).toString())),
        DataCell(Text(payment.amount.toString())),
        DataCell(Text(format.format(payment.date))),
        DataCell(IconButton(
            onPressed: () {
              setState(() {
                widget.invoice.payments.removeAt(i);
              });
            },
            icon: Icon(Icons.delete, color: Colors.red)))
      ]));
    }
    return rows;
  }
}
