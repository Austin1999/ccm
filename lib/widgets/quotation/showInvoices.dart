import 'package:ccm/models/quote.dart';
import 'package:ccm/widgets/quotation/invoice_list.dart';
import 'package:flutter/material.dart';

class InvoiceSummmary extends StatelessWidget {
  const InvoiceSummmary({Key? key, required this.clientInvoices, required this.contractorInvoices}) : super(key: key);

  final List<Invoice> clientInvoices;
  final List<Invoice> contractorInvoices;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 300,
            child: TabBar(labelColor: Colors.blue, automaticIndicatorColorAdjustment: true, tabs: [
              Tab(text: 'Client Invoice'),
              Tab(text: 'Contractor Invoice'),
            ]),
          ),
          Expanded(
            child: TabBarView(children: [
              InvoiceList(invoices: clientInvoices),
              InvoiceList(invoices: contractorInvoices),
            ]),
          ),
        ],
      ),
    );
  }
}
