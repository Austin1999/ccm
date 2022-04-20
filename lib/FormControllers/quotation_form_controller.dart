import 'package:ccm/FormControllers/invoice_form_controller.dart';
import 'package:ccm/FormControllers/po_form_controller.dart';
import 'package:ccm/widgets/quotation/quote_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/quote.dart';

class QuotationFormController {
  String? id;
  var number = TextEditingController();
  String? client;
  var amount = TextEditingController();
  var clientApproval = TextEditingController();
  DateTime? issuedDate;
  var description = TextEditingController();
  ApprovalStatus approvalStatus = ApprovalStatus.pending;
  var ccmTicketNumber = TextEditingController();
  var marginController = TextEditingController();
  var percentController = TextEditingController();

  //Ribbon Fields
  String? currencyCode;
  String? parentQuote;
  String? category;
  //==================

  DateTime? completionDate;
  OverallStatus overallStatus = OverallStatus.pending;
  List<Invoice> clientInvoices = [];
  List<ContractorPo> contractorPos = [];
  List<String> comments = [];
  ContractorPoFormController contractorForm = ContractorPoFormController();
  InvoiceFormController invoiceForm = InvoiceFormController();

  QuotationFormController();

  factory QuotationFormController.fromQuotation(Quotation quotation) {
    var controller = QuotationFormController();
    controller.id = quotation.id;
    controller.number.text = quotation.number;
    controller.client = quotation.client;
    controller.amount.text = quotation.amount.toString();
    controller.clientApproval.text = quotation.clientApproval.toString();
    controller.issuedDate = quotation.issuedDate;
    controller.description.text = quotation.description;
    controller.approvalStatus = quotation.approvalStatus;
    controller.ccmTicketNumber.text = quotation.ccmTicketNumber;
    controller.marginController.text = quotation.margin.toString();
    controller.percentController.text = quotation.percent.toString();
    controller.completionDate = quotation.completionDate;
    controller.overallStatus = quotation.overallStatus;
    controller.clientInvoices = quotation.clientInvoices;
    controller.contractorPos = quotation.contractorPo;
    controller.comments = quotation.comments;

    //ribbon
    controller.currencyCode = quotation.currencyCode;
    controller.parentQuote = quotation.parentQuote;
    controller.category = quotation.category;
    //============
    return controller;
  }

  int? _invoiceIndex;

  addInvoice() {
    // if (invoiceForm.formKey.currentState!.validate()) {
    //   clientInvoices.add(invoiceForm.object);
    // }
    clientInvoices.add(invoiceForm.object);
  }

  set selectedInvoice(int? index) {
    _invoiceIndex = index;
    print(clientInvoices.length);

    invoiceForm = (index == null) ? InvoiceFormController() : _selectInvoice(clientInvoices.elementAt(index));
  }

  _selectInvoice(Invoice invoice) {
    return InvoiceFormController.frominvoice(invoice);
  }

  deleteInvoice(int index) {
    if (_invoiceIndex == index) {
      selectedInvoice = index;
    }
    clientInvoices.removeAt(index);
  }

  updateInvoice() {
    // if (invoiceForm.formKey.currentState!.validate() && _invoiceIndex != null) {
    //   clientInvoices.removeAt(_invoiceIndex!);
    //   clientInvoices.insert(_invoiceIndex!, invoiceForm.object);
    // }

    clientInvoices.removeAt(_invoiceIndex!);
    clientInvoices.insert(_invoiceIndex!, invoiceForm.object);
  }

  //=================================   PO Form Controller Starts

  int? _poIndex;

  addPo() {
    // if (invoiceForm.formKey.currentState!.validate()) {
    //   clientInvoices.add(invoiceForm.object);
    // }
    contractorPos.add(contractorForm.object);
  }

  set selectedPo(int? index) {
    _poIndex = index;
    contractorForm = (index == null) ? ContractorPoFormController() : _selectPo(clientInvoices.elementAt(index));
  }

  _selectPo(Invoice invoice) {
    return ContractorPoFormController();
  }

  deletePo(int index) {
    if (_poIndex == index) {
      selectedPo = null;
    }
    contractorPos.removeAt(index);
  }

  updatePo() {
    // if (invoiceForm.formKey.currentState!.validate() && _invoiceIndex != null) {
    //   clientInvoices.removeAt(_invoiceIndex!);
    //   clientInvoices.insert(_invoiceIndex!, invoiceForm.object);
    // }

    contractorPos.removeAt(_poIndex!);
    contractorPos.insert(_poIndex!, contractorForm.object);
  }
}
