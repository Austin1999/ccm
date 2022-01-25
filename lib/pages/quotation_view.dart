import 'package:ccm/models/quotation.dart';
import 'package:ccm/widgets/widget.dart';
import 'package:flutter/material.dart';

class QuotationView extends StatefulWidget {
  QuotationView({Key? key, this.quotation}) : super(key: key);

  final Quotation? quotation;
  @override
  _QuotationViewState createState() => _QuotationViewState();
}

class _QuotationViewState extends State<QuotationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF3A5F85),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Table(
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Quotation", style: Theme.of(context).textTheme.headline6),
                    ),
                    Container(),
                    Container(),
                    Container()
                  ]),
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomTextFormField(labelText: "Quotation Number"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomTextFormField(
                        labelText: "Amount",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CustomTextFormField(labelText: ""),
                    ),
                    Container()
                  ])
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  ExpansionTile(
                    title: Text("Client Invoices List"),
                    children: [
                      DataTable(
                          columns: ["Invoice Number", "Amount", "Issued Date", "last received date", "Received Amount", "Edit", "Delete", "Payments"]
                              .map((e) => DataColumn(label: Text(e)))
                              .toList(),
                          rows: [
                            DataRow(
                              cells: ["INV01", "500.20", "12/10/2022", "22/10/2022", "300", "Edit", "Delete", "Payments"]
                                  .map((e) => DataCell(Text(e)))
                                  .toList(),
                            )
                          ]),
                      Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
                        // columnWidths: {6, 30},
                        children: [
                          TableRow(children: [
                            Padding(padding: const EdgeInsets.all(16.0), child: CustomTextFormField(labelText: "")),
                            Padding(padding: const EdgeInsets.all(16.0), child: CustomTextFormField(labelText: "")),
                            Padding(padding: const EdgeInsets.all(16.0), child: CustomTextFormField(labelText: "")),
                            Padding(padding: const EdgeInsets.all(16.0), child: CustomTextFormField(labelText: "")),
                            Padding(padding: const EdgeInsets.all(16.0), child: CustomTextFormField(labelText: "")),
                          ]),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text("Submit"),
                            ),
                          )),
                    ],
                  ),
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Client PO", style: Theme.of(context).textTheme.headline6),
                        ),
                        Container(),
                        Container(),
                        DropdownButtonFormField(
                          items: ["PO1000", "PO2000"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) {},
                        ),
                      ]),
                      TableRow(children: [
                        Padding(padding: const EdgeInsets.all(16.0), child: CustomTextFormField(labelText: "Quotation Number")),
                        Padding(padding: const EdgeInsets.all(16.0), child: CustomTextFormField(labelText: "Amount")),
                        Padding(padding: const EdgeInsets.all(16.0), child: CustomTextFormField(labelText: "")),
                        Padding(padding: const EdgeInsets.all(16.0), child: CustomTextFormField(labelText: "")),
                      ]),
                      TableRow(children: [
                        Padding(padding: const EdgeInsets.all(16.0), child: CustomTextFormField(labelText: "Quotation Number")),
                        Padding(padding: const EdgeInsets.all(16.0), child: CustomTextFormField(labelText: "Amount")),
                        Padding(padding: const EdgeInsets.all(16.0), child: CustomTextFormField(labelText: "")),
                        Center(
                          child: ElevatedButton(onPressed: () {}, child: Text("      Add      ")),
                        ),
                      ])
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
