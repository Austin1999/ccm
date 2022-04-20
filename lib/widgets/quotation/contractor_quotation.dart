import 'package:ccm/FormControllers/quotation_form_controller.dart';
import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/widgets/quotation/contractor_invoice.dart';
import 'package:ccm/widgets/quotation/quote_drop_down.dart';
import 'package:ccm/widgets/quotation/quote_text_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../FormControllers/po_form_controller.dart';
import 'quote_date_picker.dart';

class ContractorPoForm extends StatefulWidget {
  const ContractorPoForm({Key? key, required this.controller}) : super(key: key);

  final QuotationFormController controller;

  @override
  State<ContractorPoForm> createState() => _ContractorPoFormState();
}

class _ContractorPoFormState extends State<ContractorPoForm> {
  ContractorPoFormController get contractorForm => widget.controller.contractorForm;
  QuotationFormController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: contractorForm.formKey,
            child: Card(
              elevation: 5,
              color: Color(0xFFE8F3FA),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Contractor Quotation', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
                    ),
                  ),
                  Divider(),
                  ExpansionTile(
                    title: Text("Show POs"),
                    children: [
                      DataTable(
                          headingRowColor: MaterialStateProperty.all(Colors.white),
                          dataRowColor: MaterialStateProperty.all(Colors.white),
                          columns: [
                            DataColumn(label: Text('Number')),
                            DataColumn(label: Text('Contractor')),
                            DataColumn(label: Text('Amount')),
                            DataColumn(label: Text('Issued Date')),
                            DataColumn(label: Text('Quote Number')),
                            DataColumn(label: Text('Quote Amount')),
                            DataColumn(label: Text('Work Commence')),
                            DataColumn(label: Text('Work Complete')),
                          ],
                          rows: getRows())
                    ],
                  ),
                  Table(
                    children: [
                      TableRow(children: [
                        QuoteTextBox(controller: contractorForm.number, hintText: 'PO Number'),
                        Obx(
                          () {
                            print(contractorController.contractorlist.length);
                            return QuoteDropdown(
                              title: 'Contractor Name',
                              items: contractorController.contractorlist
                                  .map((element) => DropdownMenuItem(
                                        child: Text(element.name),
                                        value: element.name,
                                      ))
                                  .toList(),
                              value: contractorForm.contractor,
                              onChanged: (String? value) {
                                setState(() {
                                  contractorForm.contractor = value ?? contractorForm.contractor;
                                });
                              },
                            );
                          },
                        ),
                        QuoteTextBox(controller: contractorForm.amount, hintText: 'PO Amount'),
                        QuoteDate(
                          title: 'PO Issued Date',
                          date: contractorForm.issuedDate,
                          onPressed: () async {
                            await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.utc(2000),
                              lastDate: DateTime.utc(2100),
                            ).then((value) {
                              setState(() {
                                contractorForm.issuedDate = value ?? contractorForm.issuedDate;
                              });
                            });
                          },
                        ),
                      ]),
                      TableRow(children: [
                        QuoteTextBox(controller: contractorForm.quoteNumber, hintText: 'Quotation Number'),
                        QuoteTextBox(controller: contractorForm.quoteAmount, hintText: 'Quotation Amount'),
                        QuoteDate(
                          title: 'Work Commence',
                          date: contractorForm.workCommence,
                          onPressed: () async {
                            await showDatePicker(
                              context: context,
                              initialDate: contractorForm.workCommence ?? DateTime.now(),
                              firstDate: DateTime.utc(2010),
                              lastDate: DateTime.utc(2050),
                            ).then((value) {
                              setState(() {
                                contractorForm.workCommence = value ?? contractorForm.workCommence;
                              });
                            });
                          },
                        ),
                        QuoteDate(
                          title: 'Work Complete',
                          date: contractorForm.workComplete,
                          onPressed: () async {
                            await showDatePicker(
                              context: context,
                              initialDate: contractorForm.workCommence ?? DateTime.now(),
                              firstDate: DateTime.utc(2010),
                              lastDate: DateTime.utc(2050),
                            ).then((value) {
                              setState(() {
                                contractorForm.workComplete = value ?? contractorForm.workComplete;
                              });
                            });
                          },
                        ),
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
                                print("Adding PO");
                                setState(() {
                                  controller.addPo();
                                  print(contractorForm.object.toJson());
                                });
                              },
                              child: Text("Add PO")),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(onPressed: () {}, child: Text("Edit PO")),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ContractorInvoiceForm(controller: contractorForm),
      ],
    );
  }

  getRows() {
    return controller.contractorPos
        .map((e) => DataRow(cells: [
              DataCell(Text(e.number)),
              DataCell(Text(e.contractor)),
              DataCell(Text(e.amount.toString())),
              DataCell(Text(format.format(e.issuedDate))),
              DataCell(Text(e.quoteNumber)),
              DataCell(Text(e.amount.toString())),
              DataCell(Text(e.workCommence == null ? 'Not Assigned' : format.format(e.workCommence!))),
              DataCell(Text(e.workComplete == null ? 'Not Assigned' : format.format(e.workComplete!))),
            ]))
        .toList();
  }
}
