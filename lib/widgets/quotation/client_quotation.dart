import 'package:ccm/FormControllers/quotation_form_controller.dart';
import 'package:ccm/controllers/currency_controller.dart';
import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/quote.dart';
import 'package:ccm/services/firebase.dart';
import 'package:ccm/widgets/quotation/quote_drop_down.dart';
import 'package:ccm/widgets/quotation/quote_text_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart' as list;

import 'quote_date_picker.dart';

class ClientQuotation extends StatefulWidget {
  const ClientQuotation({Key? key, required this.controller}) : super(key: key);

  final QuotationFormController controller;

  @override
  State<ClientQuotation> createState() => _ClientQuotationState();
}

class _ClientQuotationState extends State<ClientQuotation> {
  QuotationFormController get controller => widget.controller;

  final quoteIssuedDateController = TextEditingController();
  final jobCompletionDateController = TextEditingController();

  @override
  void initState() {
    quoteIssuedDateController.text = controller.issuedDate == null ? '' : format.format(controller.issuedDate!);
    jobCompletionDateController.text = controller.completionDate == null ? '' : format.format(controller.completionDate!);
    controller.currencyCode = controller.currencyCode ?? session.country!.currencyCode;
    super.initState();
  }

  static const _categoryList = [
    {'key': "FM", "value": "FM", "text": "FM Contract"},
    {'key': "IN", "value": "IN", "text": "Interior & General"},
    {'key': "EL", "value": "EL", "text": "Electrical"},
    {'key': "HV", "value": "HV", "text": "HVAC System"},
    {'key': "PL", "value": "PL", "text": "Plumping & Pest"},
    {'key': "FI", "value": "FI", "text": "Fire Protection"},
    {'key': "AV", "value": "AV", "text": "AV system"},
    {'key': "IT", "value": "IT", "text": "IT & Security"},
    {'key': "CA", "value": "CA", "text": "Carpentry Works"},
    {'key': "FU", "value": "FU", "text": "Furniture & Rugs"},
    {'key': "AD", "value": "AD", "text": "Additional Works"}
  ];

  List<DropdownMenuItem<String>> get categoryItems => _categoryList
      .map((e) => DropdownMenuItem(
            child: Text(e['text'] ?? ''),
            value: e['value'],
          ))
      .toList();

  String? _requiredValidator(String? number) {
    if ((number ?? '').isEmpty) {
      return 'Field should not be empty';
    }
    return null;
  }

  String? _amountValidator(String? p1) {
    try {
      double.parse(p1.toString());
    } catch (e) {
      return 'Amount should be numbers and not empty';
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
          key: controller.quoteFormKey,
          child: Column(
            children: [
              Table(
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 40),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text('CLIENT QUOTATION', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
                      ),
                    ),
                    Container(),
                    Container(),
                    QuoteDropdown<String>(
                      title: 'Currency',
                      items: currencyController.items,
                      value: controller.currencyCode,
                      onChanged: (val) {
                        setState(() {
                          controller.currencyCode = val ?? controller.currencyCode;
                        });
                      },
                    ),
                    QuoteDropdown<String>(
                      value: controller.category,
                      title: 'Category',
                      items: categoryItems,
                      onChanged: (val) {
                        controller.category = val;
                      },
                    ),
                    QuoteTypeAhead(
                        onSelected: (val) {
                          setState(() {
                            controller.parentQuote = val;
                          });
                        },
                        onChanged: (val) {
                          if ((val).isEmpty) {
                            controller.parentQuote = null;
                          }
                        },
                        text: (controller.parentQuote ?? ''),
                        optionsBuilder: (textValue) async {
                          var values = await quotations.get().then((value) => value.docs
                              .map((e) => Quotation.fromJson(e.data()).number)
                              .where((element) => element.toLowerCase().startsWith(textValue.text.toLowerCase()))
                              .toList());

                          return values;
                        },
                        title: 'Parent quote'),
                  ])
                ],
              ),
              Divider(),
              Table(
                children: [
                  TableRow(children: [
                    QuoteTextBox(
                      controller: widget.controller.number,
                      hintText: 'Quotation',
                      validator: (val) {
                        if ((val ?? '').isEmpty) {
                          return 'Field should not be empty';
                        }
                        return null;
                      },
                    ),
                    QuoteDropdown<String>(
                      title: 'Client',
                      validator: (val) {
                        if ((val ?? '').isEmpty) {
                          return 'Please select a client';
                        }
                        return null;
                      },
                      items: clientController.clientlist.map((element) => DropdownMenuItem(child: Text(element.name), value: element.docid)).toList(),
                      value: controller.client,
                      onChanged: (String? value) {
                        setState(() {
                          controller.client = value ?? controller.client;
                        });
                      },
                    ),
                    QuoteTextBox(
                      validator: _amountValidator,
                      controller: widget.controller.amount,
                      hintText: 'Quote Amount',
                      onChanged: (amount) {
                        var margin;
                        var percent;
                        try {
                          margin = controller.object.margin;
                          percent = controller.object.percent;
                          setState(() {});
                        } catch (e) {
                          margin = 0;
                          percent = 0;
                        }
                        setState(() {
                          controller.marginController.text = margin.toStringAsFixed(2);
                          controller.percentController.text = percent.toStringAsFixed(2);
                        });
                      },
                    ),
                    QuoteTextBox(
                      controller: widget.controller.clientApproval,
                      hintText: 'Client Approval',
                    ),
                  ]),
                  TableRow(children: [
                    QuoteDateBox(
                      readOnly: true,
                      hintText: 'Enter date',
                      controler: quoteIssuedDateController,
                      title: 'Issued Date',
                      validator: (val) {
                        if ((val ?? '').isEmpty) {
                          return 'Date should not be empty';
                        }
                        return null;
                      },
                      onPressed: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: controller.issuedDate ?? DateTime.now(),
                          firstDate: DateTime.utc(2000),
                          lastDate: DateTime.utc(2100),
                        ).then((value) {
                          setState(() {
                            controller.issuedDate = value ?? controller.issuedDate;
                            quoteIssuedDateController.text = controller.issuedDate == null ? '' : format.format(controller.issuedDate!);
                          });
                        });
                      },
                    ),
                    QuoteTextBox(controller: widget.controller.description, hintText: 'Description'),
                    QuoteDropdown<ApprovalStatus>(
                      value: controller.approvalStatus,
                      title: 'Approval Status',
                      onChanged: (value) {
                        setState(() {
                          controller.approvalStatus = value ?? controller.approvalStatus;
                        });
                      },
                      selectedItemBuilder: (context) {
                        return ApprovalStatus.values.map((e) {
                          return SizedBox(height: 52, child: Text(e.toString().split('.').last.toUpperCase()));
                        }).toList();
                      },
                      items: ApprovalStatus.values.map((e) {
                        return DropdownMenuItem(
                          child: Text(e.toString().split('.').last.toUpperCase()),
                          value: e,
                        );
                      }).toList(),
                    ),
                    Row(
                      children: [
                        Expanded(flex: 3, child: QuoteTextBox(readOnly: true, controller: widget.controller.marginController, hintText: 'Margin')),
                        Expanded(flex: 2, child: QuoteTextBox(readOnly: true, controller: widget.controller.percentController, hintText: '%')),
                      ],
                    ),
                  ]),
                  TableRow(children: [
                    QuoteTextBox(controller: widget.controller.ccmTicketNumber, hintText: 'CCM Ticket Number'),
                    QuoteDateBox(
                      hintText: 'Job Completion Date',
                      controler: jobCompletionDateController,
                      title: 'Job Completion Date',
                      onPressed: () async {
                        await showDatePicker(
                          context: context,
                          initialDate: controller.completionDate ?? DateTime.now(),
                          firstDate: DateTime.utc(2000),
                          lastDate: DateTime.utc(2100),
                        ).then((value) {
                          setState(() {
                            controller.completionDate = value ?? controller.completionDate;
                            jobCompletionDateController.text = controller.completionDate == null ? '' : format.format(controller.completionDate!);
                          });
                        });
                      },
                    ),
                    Container(),
                    QuoteDropdown<OverallStatus>(
                      value: controller.overallStatus,
                      title: 'Overall Status',
                      onChanged: (value) {
                        setState(() {
                          controller.overallStatus = value ?? controller.overallStatus;
                        });
                      },
                      items: OverallStatus.values.map((e) {
                        return DropdownMenuItem(
                          child: Text(e.toString().split('.').last.toUpperCase()),
                          value: e,
                        );
                      }).toList(),
                    ),
                  ]),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
