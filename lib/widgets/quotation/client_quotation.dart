import 'package:ccm/FormControllers/quotation_form_controller.dart';
import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/quote.dart';
import 'package:ccm/widgets/quotation/quote_drop_down.dart';
import 'package:ccm/widgets/quotation/quote_text_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'quote_date_picker.dart';

class ClientQuotation extends StatefulWidget {
  const ClientQuotation({Key? key, required this.controller}) : super(key: key);

  final QuotationFormController controller;

  @override
  State<ClientQuotation> createState() => _ClientQuotationState();
}

class _ClientQuotationState extends State<ClientQuotation> {
  QuotationFormController get controller => widget.controller;

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
                child: Text('CLIENT QUOTATION', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
              ),
            ),
            Divider(),
            Table(
              children: [
                TableRow(children: [
                  QuoteTextBox(controller: widget.controller.number, hintText: 'Quotation'),
                  Obx((() {
                    print(clientController.clientlist.length);
                    return QuoteDropdown(
                      title: 'Client',
                      items: clientController.clientlist.map((element) => DropdownMenuItem(child: Text(element.name), value: element.name)).toList(),
                      value: controller.client,
                      onChanged: (String? value) {
                        setState(() {
                          controller.client = value ?? controller.client;
                        });
                      },
                    );
                  })),
                  QuoteTextBox(controller: widget.controller.amount, hintText: 'Quote Amount'),
                  QuoteTextBox(controller: widget.controller.clientApproval, hintText: 'Client Approval'),
                ]),
                TableRow(children: [
                  QuoteDate(
                    title: 'Issued Date',
                    date: controller.issuedDate,
                    onPressed: () async {
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.utc(2000),
                        lastDate: DateTime.utc(2100),
                      ).then((value) {
                        setState(() {
                          controller.issuedDate = value ?? controller.issuedDate;
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
                  QuoteDate(
                    title: 'Job Completion Date',
                    date: controller.completionDate,
                    onPressed: () async {
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.utc(2000),
                        lastDate: DateTime.utc(2100),
                      ).then((value) {
                        setState(() {
                          controller.completionDate = value ?? controller.completionDate;
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
    );
  }
}
