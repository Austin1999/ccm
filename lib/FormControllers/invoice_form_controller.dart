import 'package:flutter/cupertino.dart';

import '../models/quote.dart';

class InvoiceFormController {
  var number = TextEditingController();
  var amount = TextEditingController();
  var taxNumber = TextEditingController();

  // final formKey = GlobalKey<FormState>();

  InvoiceFormController();

  DateTime? issuedDate;
  List<Payment> payments = [];
  List<Credit> credits = [];

  final invoiceFormKey = GlobalKey<FormState>();

  Invoice get object => Invoice(
      number: number.text,
      amount: double.parse(amount.text),
      issuedDate: issuedDate!,
      payments: payments,
      credits: credits,
      taxNumber: taxNumber.text.isEmpty ? null : taxNumber.text);

  factory InvoiceFormController.frominvoice(Invoice invoice) {
    var controller = InvoiceFormController();
    controller.number.text = invoice.number;
    controller.amount.text = invoice.amount.toString();
    controller.taxNumber.text = invoice.taxNumber ?? '';
    controller.issuedDate = invoice.issuedDate;
    controller.payments = invoice.payments;
    controller.credits = invoice.credits;
    controller.taxNumber.text = invoice.taxNumber ?? '';
    return controller;
  }

  double get receivedAmount {
    double amount = 0.0;
    payments.forEach((element) {
      amount += element.amount;
    });
    return amount;
  }

  DateTime? get lastReceivedDate {
    if (payments.isEmpty) {
      return null;
    } else {
      return payments.last.date;
    }
  }
}
