import 'package:ccm/FormControllers/quotation_form_controller.dart';
import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/quote.dart';
import 'package:ccm/widgets/quotation/contractor_invoice.dart';
import 'package:ccm/widgets/quotation/quote_text_box.dart';
import 'package:flutter/material.dart';

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

  final issuedDateController = TextEditingController();
  final commenceDateController = TextEditingController();
  final completeDateController = TextEditingController();

  @override
  void initState() {
    issuedDateController.text = contractorForm.issuedDate == null ? '' : format.format(contractorForm.issuedDate!);
    commenceDateController.text = contractorForm.workCommence == null ? '' : format.format(contractorForm.workCommence!);
    completeDateController.text = contractorForm.workComplete == null ? '' : format.format(contractorForm.workComplete!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: contractorForm.contractorFormKey,
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Table(
                      children: [
                        TableRow(
                          children: [
                            Card(
                              color: Colors.white,
                              shadowColor: Colors.amber,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DataTable(columns: [
                                  DataColumn(label: Text('Number')),
                                  DataColumn(label: Text('Contractor')),
                                  DataColumn(label: Text('Amount')),
                                  DataColumn(label: Text('Issued Date')),
                                  DataColumn(label: Text('Quote Number')),
                                  DataColumn(label: Text('Quote Amount')),
                                  DataColumn(label: Text('Work Commence')),
                                  DataColumn(label: Text('Work Complete')),
                                  DataColumn(label: Text('Edit')),
                                  DataColumn(label: Text('Delete')),
                                ], rows: getRows()),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Table(
                    children: [
                      TableRow(children: [
                        QuoteTextBox(
                          controller: contractorForm.number,
                          hintText: 'PO Number',
                          validator: _requiredDuplicateValidator,
                        ),
                        QuoteTypeAhead(
                          text: controller.contractorForm.contractor,
                          validator: _requiredValidator,
                          title: 'Contractor',
                          optionsBuilder: (TextEditingValue value) {
                            var contractorList = contractorController.contractorlist.map((element) => element.name).toList();
                            return contractorList.where((element) => element.toLowerCase().startsWith(value.text.toLowerCase()));
                          },
                          optionsViewBuilder: (context, onSelected, options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(maxHeight: 200, maxWidth: MediaQuery.of(context).size.width / 4.57),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: options.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(options.elementAt(index)),
                                            onTap: () {
                                              onSelected(options.elementAt(index));
                                            },
                                          );
                                        }),
                                  ),
                                ),
                              ),
                            );
                          },
                          onSelected: (option) => setState(() {
                            controller.contractorForm.contractor = option;
                          }),
                        ),
                        QuoteTextBox(
                          controller: contractorForm.amount,
                          hintText: 'PO Amount',
                          validator: _amountValidator,
                        ),
                        QuoteDateBox(
                          hintText: 'PO Issued Date',
                          controler: issuedDateController,
                          title: 'PO Issued Date',
                          validator: _requiredValidator,
                          onPressed: () async {
                            await showDatePicker(
                              context: context,
                              initialDate: contractorForm.issuedDate ?? DateTime.now(),
                              firstDate: DateTime.utc(2000),
                              lastDate: DateTime.utc(2100),
                            ).then((value) {
                              setState(() {
                                contractorForm.issuedDate = value;
                                issuedDateController.text = contractorForm.issuedDate == null ? '' : format.format(contractorForm.issuedDate!);
                              });
                            });
                          },
                        ),
                      ]),
                      TableRow(children: [
                        QuoteTextBox(
                          controller: contractorForm.quoteNumber,
                          hintText: 'Quotation Number',
                        ),
                        QuoteTextBox(controller: contractorForm.quoteAmount, hintText: 'Quotation Amount'),
                        QuoteDateBox(
                          hintText: 'Work Commence',
                          title: 'Work Commence',
                          controler: commenceDateController,
                          onPressed: () async {
                            await showDatePicker(
                              context: context,
                              initialDate: contractorForm.workCommence ?? DateTime.now(),
                              firstDate: DateTime.utc(2010),
                              lastDate: DateTime.utc(2050),
                            ).then((value) {
                              setState(() {
                                contractorForm.workCommence = value;
                                commenceDateController.text = contractorForm.workCommence == null ? '' : format.format(contractorForm.workCommence!);
                              });
                            });
                          },
                        ),
                        QuoteDateBox(
                          hintText: 'Work Complete',
                          title: 'Work Complete',
                          controler: completeDateController,
                          onPressed: () async {
                            await showDatePicker(
                              context: context,
                              initialDate: contractorForm.workComplete ?? DateTime.now(),
                              firstDate: DateTime.utc(2010),
                              lastDate: DateTime.utc(2050),
                            ).then((value) {
                              setState(() {
                                contractorForm.workComplete = value;
                                completeDateController.text = contractorForm.workComplete == null ? '' : format.format(contractorForm.workComplete!);
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
                                setState(() {
                                  controller.addPo();
                                });
                              },
                              child: Text("Add PO")),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                controller.updatePo();
                              });
                            },
                            child: Text("Edit PO"),
                          ),
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
    List<DataRow> dataRows = [];
    int length = controller.contractorPos.length;
    for (int i = 0; i < length; i++) {
      var e = controller.contractorPos[i];

      dataRows.add(DataRow(key: UniqueKey(), color: (i == controller.selectedPo) ? MaterialStateProperty.all(Colors.grey.shade300) : null, cells: [
        DataCell(Text(e.number)),
        DataCell(Text(e.contractor)),
        DataCell(Text(e.amount.toString())),
        DataCell(Text(format.format(e.issuedDate))),
        DataCell(Text(e.quoteNumber ?? '')),
        DataCell(Text(e.amount.toString())),
        DataCell(Text(e.workCommence == null ? 'Not Assigned' : format.format(e.workCommence!))),
        DataCell(Text(e.workComplete == null ? 'Not Assigned' : format.format(e.workComplete!))),
        DataCell(IconButton(
            onPressed: () {
              setState(() {
                controller.selectedPo = i;
              });
            },
            icon: Icon(Icons.edit))),
        DataCell(IconButton(
            onPressed: () {
              setState(() {
                controller.deletePo(i);
              });
            },
            icon: Icon(Icons.delete))),
      ]));
    }
    return dataRows;
  }

  getSource() {
    return ContractorSource(
      contractorPOs: controller.contractorPos,
      poIndex: controller.selectedPo,
    );
  }

  String? _amountValidator(String? p1) {
    try {
      double.parse(p1.toString());
    } catch (e) {
      return 'Amount should be numbers and not empty';
    }
    return null;
  }

  String? _requiredDuplicateValidator(String? number) {
    if ((number ?? '').isEmpty) {
      return 'Field should not be empty';
    }
    if (controller.contractorPos.map((e) => e.number).contains(number)) {
      return 'Duplicate PO number';
    }
    return null;
  }

  String? _requiredValidator(String? number) {
    if ((number ?? '').isEmpty) {
      return 'Field should not be empty';
    }

    return null;
  }
}

class ContractorSource extends DataTableSource {
  final List<ContractorPo> contractorPOs;
  final int? poIndex;
  final void Function()? onPressedEdit;
  final void Function()? onPressDelete;

  ContractorSource({
    required this.contractorPOs,
    required this.poIndex,
    this.onPressedEdit,
    this.onPressDelete,
  });

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= contractorPOs.length) return null;
    final e = contractorPOs[index];
    return DataRow(
        key: UniqueKey(),
        color: (index == poIndex) ? MaterialStateProperty.all(Colors.grey.shade300) : MaterialStateProperty.all(Colors.white),
        cells: [
          DataCell(Text(e.number)),
          DataCell(Text(e.contractor)),
          DataCell(Text(e.amount.toString())),
          DataCell(Text(format.format(e.issuedDate))),
          DataCell(Text(e.quoteNumber ?? '')),
          DataCell(Text(e.amount.toString())),
          DataCell(Text(e.workCommence == null ? 'Not Assigned' : format.format(e.workCommence!))),
          DataCell(Text(e.workComplete == null ? 'Not Assigned' : format.format(e.workComplete!))),
          DataCell(IconButton(onPressed: onPressedEdit, icon: Icon(Icons.edit))),
          DataCell(IconButton(onPressed: onPressDelete, icon: Icon(Icons.delete))),
        ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => contractorPOs.length;

  @override
  int get selectedRowCount => 0;
}
