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

  int? _invoiceIndex;

  final formKey = GlobalKey<FormState>();

  ContractorPo get object => ContractorPo(
        number: number.text,
        contractor: contractor!,
        amount: double.parse(amount.text),
        issuedDate: issuedDate!,
        quoteNumber: quoteNumber.text,
        quoteAmount: double.parse(quoteAmount.text),
        invoices: invoices,
      );

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

  _selectInvoice(Invoice invoice) {
    invoiceForm = InvoiceFormController.frominvoice(invoice);
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
