import 'package:ccm/FormControllers/quotation_form_controller.dart';
import 'package:ccm/controllers/getControllers.dart';
import 'package:ccm/models/quote.dart';
import 'package:ccm/widgets/quotation/client_invoice.dart';
import 'package:ccm/widgets/quotation/client_quotation.dart';
import 'package:ccm/widgets/quotation/contractor_quotation.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/quotation/card_input.dart';

class QuotationForm extends StatefulWidget {
  QuotationForm({Key? key, this.quotation}) : super(key: key);

  final Quotation? quotation;

  @override
  State<QuotationForm> createState() => _QuotationFormState();
}

class _QuotationFormState extends State<QuotationForm> {
  @override
  void initState() {
    Get.put(ClientController());
    if (widget.quotation != null) {
      controller = QuotationFormController.fromQuotation(widget.quotation!);
    } else {
      controller = QuotationFormController();
    }
    super.initState();
  }

  late QuotationFormController controller;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF3A5F85),
          title: Text('In a world of gray, CCM provides clarity to all construction & facility projects'),
        ),
        floatingActionButton: ElevatedButton(
            onPressed: () {
              print(controller.clientInvoices.first.toJson());
            },
            child: Text("Submit")),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 8.0,
              ),
              ClientQuotation(controller: controller),
              ClientInvoiceForm(controller: controller),
              ContractorPoForm(controller: controller),
              SizedBox(
                height: 40.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
