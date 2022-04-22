import 'package:ccm/FormControllers/invoice_form_controller.dart';
import 'package:flutter/cupertino.dart';

import '../models/quote.dart';

class ContractorPoFormController {
  var number = TextEditingController();
  String? contractor;
  var amount = TextEditingController();
  DateTime? issuedDate;
  var quoteAmount = TextEditingController();
  var quoteNumber = TextEditingController();
  DateTime? workCommence;
  DateTime? workComplete;
  List<Invoice> invoices = [];
  InvoiceFormController invoiceForm = InvoiceFormController();

  final contractorFormKey = GlobalKey<FormState>();

  int? _invoiceIndex;

  ContractorPoFormController();

  ContractorPo get object => ContractorPo(
        number: number.text,
        contractor: contractor!,
        amount: double.parse(amount.text),
        issuedDate: issuedDate!,
        quoteNumber: quoteNumber.text,
        quoteAmount: double.parse(quoteAmount.text),
        workCommence: workCommence,
        workComplete: workComplete,
        invoices: invoices,
      );

  factory ContractorPoFormController.fromPO(ContractorPo po) {
    var controller = ContractorPoFormController();
    controller.number.text = po.number;
    controller.contractor = po.contractor;
    controller.amount.text = po.amount.toString();
    controller.issuedDate = po.issuedDate;
    controller.quoteNumber.text = po.quoteNumber;
    controller.quoteAmount.text = po.quoteAmount.toString();
    controller.workCommence = po.workCommence;
    controller.workComplete = po.workComplete;
    controller.invoices = po.invoices;

    if (controller.invoices.isNotEmpty) {
      controller.invoiceForm = InvoiceFormController.frominvoice(controller.invoices.first);
      controller.selectedInvoice = 0;
    }
    return controller;
  }

  addInvoice() {
    // if (invoiceForm.formKey.currentState!.validate()) {
    //   invoices.add(invoiceForm.object);
    // }
    invoices.add(invoiceForm.object);
  }

  set selectedInvoice(int? index) {
    _invoiceIndex = index;
    invoiceForm = (index == null) ? InvoiceFormController() : _selectInvoice(invoices.elementAt(index));
  }

  int? get selectedInvoice => _invoiceIndex;

  _selectInvoice(Invoice invoice) {
    return InvoiceFormController.frominvoice(invoice);
  }

  deleteInvoice(int index) {
    if (_invoiceIndex == index) {
      selectedInvoice = index;
    }
    invoices.removeAt(index);
  }

  updateInvoice() {
    // if (invoiceForm.formKey.currentState!.validate() && _invoiceIndex != null) {
    //   invoices.removeAt(_invoiceIndex!);
    //   invoices.insert(_invoiceIndex!, invoiceForm.object);
    // }

    invoices.removeAt(_invoiceIndex!);
    invoices.insert(_invoiceIndex!, invoiceForm.object);
  }
}
