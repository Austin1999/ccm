import 'package:flutter/material.dart';

import '../../models/quote.dart';
import 'quote_date_picker.dart';

class InvoiceList extends StatelessWidget {
  const InvoiceList({Key? key, required this.invoices, this.poNumber = ''}) : super(key: key);

  final List<Invoice> invoices;
  final String poNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        child: DataTable(columns: [
          DataColumn(label: Text('PO')),
          DataColumn(label: Text('Number')),
          DataColumn(label: Text('Amount')),
          DataColumn(label: Text('Issued Date')),
          DataColumn(label: Text('Paid/Received Amount')),
          DataColumn(label: Text('Last Received Date')),
          DataColumn(label: Text('Credit Amount')),
        ], rows: getSource()),
      ),
    );
  }

  getSource() {
    List<DataRow> datarows = [];
    for (int i = 0; i < invoices.length; i++) {
      var e = invoices[i];
      datarows.add(DataRow(cells: [
        DataCell(Text(poNumber)),
        DataCell(Text(e.number)),
        DataCell(Text(e.amount.toString())),
        DataCell(Text(format.format(e.issuedDate))),
        DataCell(Text(e.closedAmount.toString())),
        DataCell(Text(e.lastReceivedDate == null ? 'No Payments' : format.format(e.lastReceivedDate!))),
        DataCell(Text(e.creditAmount.toString())),
      ]));
    }

    return datarows;
  }
}
