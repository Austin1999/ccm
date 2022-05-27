import 'package:ccm/models/quote.dart';
import 'package:ccm/widgets/quotation/quote_date_picker.dart';
import 'package:ccm/widgets/quotation/quote_text_box.dart';
import 'package:flutter/material.dart';

class CreditForm extends StatefulWidget {
  CreditForm({Key? key, required this.invoice, this.callback, required this.readOnly}) : super(key: key);
  final Invoice invoice;
  final void Function()? callback;
  final bool readOnly;

  @override
  State<CreditForm> createState() => _CreditFormState();
}

class _CreditFormState extends State<CreditForm> {
  final amount = TextEditingController();
  final note = TextEditingController();

  DateTime? date;

  String amountError = '';
  String dateError = '';
  bool get readOnly => widget.readOnly;
  validate() {
    bool result = true;
    try {
      double.parse(amount.text);
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
                child: Text('CREDITS', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
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
                QuoteTextBox(
                  controller: note,
                  hintText: 'Credit Note',
                  onTap: () {
                    setState(() {
                      amountError = '';
                    });
                  },
                ),
                Column(
                  children: [
                    QuoteTextBox(
                      controller: amount,
                      hintText: 'Credit Amount',
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
                      title: 'credit date',
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
              ]),
              TableRow(children: [
                Container(),
                Container(),
                readOnly
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                              onPressed: () {
                                if (validate()) {
                                  setState(() {
                                    widget.invoice.credits.add(Credit(amount: double.parse(amount.text), note: note.text, date: date!));
                                  });
                                }
                              },
                              child: Text("Add")),
                        ),
                      )
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
                  DataColumn(label: Text('Credit Note')),
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
    int length = widget.invoice.credits.length;

    for (int i = 0; i < length; i++) {
      Credit credit = widget.invoice.credits[i];
      rows.add(DataRow(cells: [
        DataCell(Text((i + 1).toString())),
        DataCell(Text(credit.amount.toString())),
        DataCell(Text(credit.note.toString())),
        DataCell(Text(format.format(credit.date))),
        DataCell(IconButton(
            onPressed: readOnly
                ? null
                : () {
                    setState(() {
                      widget.invoice.credits.removeAt(i);
                    });
                  },
            icon: Icon(Icons.delete, color: readOnly ? Colors.grey : Colors.red)))
      ]));
    }
    return rows;
  }
}
