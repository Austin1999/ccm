import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:ccm/controllers/getControllers.dart';
import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/client.dart';
import 'package:ccm/models/quotation.dart';
import 'package:ccm/services/firebase.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuotationView extends StatefulWidget {
  QuotationView({Key? key, this.data, required this.isEdit, this.id})
      : super(key: key);
  Quotation? data;
  var id;
  bool isEdit;

  @override
  _QuotationViewState createState() => _QuotationViewState();
}

class _QuotationViewState extends State<QuotationView> {
  TextEditingController currency = TextEditingController();
  TextEditingController clientQuotequotationNumber = TextEditingController();
  TextEditingController clientQuoteclientName = TextEditingController(
      text: clientController.clientlist.isEmpty
          ? "N/A"
          : clientController.clientlist.first.name);
  TextEditingController clientQuoteAmount = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> clientkey = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> contractorkey = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> contractinvoiceorkey =
      new GlobalKey();
  TextEditingController clientQuoteclientApproval = TextEditingController();
  TextEditingController clientQuotedateIssued = TextEditingController();
  TextEditingController clientQuoteDesciption = TextEditingController();
  TextEditingController clientQuoteApprovalStatus =
      TextEditingController(text: 'Approved');
  TextEditingController clientQuoteCCMTicketNumber = TextEditingController();
  TextEditingController clientQuoteJobCompletionDate = TextEditingController();
  TextEditingController clientQuoteOverallStatus =
      TextEditingController(text: 'Pending');
  TextEditingController clientInvoiceNo = TextEditingController();
  TextEditingController clientInvoiceAmount = TextEditingController();
  TextEditingController clientInvoiceIssueDate = TextEditingController();
  TextEditingController contractorQuotationPONumber = TextEditingController();
  TextEditingController contractorQuotationContractorName =
      TextEditingController(
          text: contractorController.contractorlist.isEmpty
              ? 'N/A'
              : contractorController.contractorlist.first.name);
  TextEditingController contractorQuotationPOAmount = TextEditingController();
  TextEditingController contractorQuotationPOIssueDate =
      TextEditingController();
  TextEditingController contractorQuotationNo = TextEditingController();
  TextEditingController contractorQuotationAmount = TextEditingController();
  TextEditingController contractorQuotationWorkCommence =
      TextEditingController();
  TextEditingController contractorQuotationWorkComplete =
      TextEditingController();
  TextEditingController contractorInvoiceNo = TextEditingController();
  TextEditingController contractorInvoiceAmount = TextEditingController();
  TextEditingController contractorInvoiceRecievedDate = TextEditingController();
  TextEditingController contractorInvoiceTaxInvoiceNo = TextEditingController();
  TextEditingController contractorInvoicePaidAmount = TextEditingController();
  TextEditingController contractorInvoiceLastPaidDate = TextEditingController();
  TextEditingController comment = TextEditingController();
  TextEditingController clientInvoiceLastRecieveDate = TextEditingController();
  // TextEditingController invoicenumber = TextEditingController();
  // TextEditingController invoiceamount = TextEditingController();
  // TextEditingController issueddate = TextEditingController();
  TextEditingController clientrecievedamount = TextEditingController();
  TextEditingController clientpaymentdate = TextEditingController();

  TextEditingController clientcreditRecieveDate = TextEditingController();
  TextEditingController clientcreditamount = TextEditingController();
  TextEditingController clientcreditnoteno = TextEditingController();

  TextEditingController contractorrecievedamount = TextEditingController();
  TextEditingController contractorpaymentdate = TextEditingController();

  TextEditingController contractorcreditRecieveDate = TextEditingController();
  TextEditingController contractorcreditamount = TextEditingController();
  TextEditingController contractorcreditnoteno = TextEditingController();
  Future<DateTime> _selectDate(
      BuildContext context, DateTime selectedDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) return picked;
    return picked!;
  }

  List<InvoicePaymentModel> clientinvoicepayment = [];
  List<CreditModel> clientcredits = [];
  List<InvoicePaymentModel> contractorinvoicepayment = [];
  List<CreditModel> contractorcredits = [];
  List<String> categorylist = [
    "FM Contract",
    "Interior and General",
    "Electrical",
    "HVAC System",
    "Plumping and Pest",
    "Fire Protection",
    "AV System",
    "IT and Security",
    "Carpentry Works",
    "Furniture and Rugs",
    "Additional Works"
  ];
  List<ClientInvoice> clientinvoices = [];
  List<ContractorInvoice> contractorInvoice = [];
  List<ContractorPurchaseOrder> contractorPO = [];
  List<String> comments = [];
  String? category = "FM Contract";
  String parentQuote = quotationController.quotionlist.isEmpty
      ? 'N/A'
      : quotationController.quotionlist.first.qnumber;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // widget.isEdit ? getData() : null;
  // }

  // getData() {
  //   ClientInvoice clientInvoiceinit = widget.data!.clientInvoices.first;
  //   ContractorInvoice contractorInvoiceinit =
  //       widget.data!.contractorPurchaseOrders.first.invoices.first;
  //   ContractorPurchaseOrder contractorpo =
  //       widget.data!.contractorPurchaseOrders.first;
  //   contractorQuotationContractorName =
  //       TextEditingController(text: contractorpo.name);
  //   clientQuotequotationNumber =
  //       TextEditingController(text: widget.data!.qnumber);
  //   clientQuoteclientName =
  //       TextEditingController(text: widget.data!.clientname);
  //   clientQuoteAmount =
  //       TextEditingController(text: widget.data!.qamount.toString());
  //   clientQuoteclientApproval =
  //       TextEditingController(text: widget.data!.clientApproval);
  //   clientQuotedateIssued = TextEditingController(
  //       text: widget.data!.dateIssued.toString().substring(0, 10));
  //   clientQuoteDesciption =
  //       TextEditingController(text: widget.data!.description);
  //   clientQuoteApprovalStatus =
  //       TextEditingController(text: widget.data!.approvalStatus);
  //   clientQuoteCCMTicketNumber =
  //       TextEditingController(text: widget.data!.ccmTicketNumber);
  //   clientQuoteJobCompletionDate = TextEditingController(
  //     text: widget.data!.jobcompletionDate.toString().substring(0, 10),
  //   );
  //   clientQuoteOverallStatus =
  //       TextEditingController(text: widget.data!.overallstatus);
  //   clientInvoiceNo = TextEditingController(text: clientInvoiceinit.number);
  //   clientInvoiceAmount =
  //       TextEditingController(text: clientInvoiceinit.amount.toString());
  //   clientInvoiceIssueDate = TextEditingController(
  //     text: clientInvoiceinit.issueDate.toString().substring(0, 10),
  //   );
  //   contractorQuotationPONumber =
  //       TextEditingController(text: contractorpo.poNumber);
  //   contractorQuotationPOAmount =
  //       TextEditingController(text: contractorpo.poAmount.toString());
  //   contractorQuotationPOIssueDate = TextEditingController(
  //     text: contractorpo.issueDate.toString().substring(0, 10),
  //   );
  //   contractorQuotationNo =
  //       TextEditingController(text: contractorpo.quotationNumber);
  //   contractorQuotationAmount =
  //       TextEditingController(text: contractorpo.quotationAmount.toString());
  //   contractorQuotationWorkCommence = TextEditingController(
  //     text: contractorpo.workCommenceDate.toString().substring(0, 10),
  //   );
  //   contractorQuotationWorkComplete = TextEditingController(
  //     text: contractorpo.workCompleteDate.toString().substring(0, 10),
  //   );
  //   contractorInvoiceNo =
  //       TextEditingController(text: contractorInvoiceinit.number);
  //   contractorInvoiceAmount =
  //       TextEditingController(text: contractorInvoiceinit.amount.toString());
  //   contractorInvoiceRecievedDate = TextEditingController(
  //     text: contractorInvoiceinit.receivedDate.toString().substring(0, 10),
  //   );
  //   contractorInvoiceTaxInvoiceNo =
  //       TextEditingController(text: contractorInvoiceinit.taxNumber);
  //   contractorInvoicePaidAmount = TextEditingController(
  //       text: contractorInvoiceinit.paidamount.toString());
  //   contractorInvoiceLastPaidDate = TextEditingController(
  //     text: contractorInvoiceinit.paidDate.toString().substring(0, 10),
  //   );
  //   clientInvoiceLastRecieveDate = TextEditingController(
  //     text: clientInvoiceinit.receivedDate.toString().substring(0, 10),
  //   );
  //   clientinvoices = widget.data!.clientInvoices;
  //   contractorInvoice = widget.data!.contractorPurchaseOrders.first.invoices;
  //   contractorPO = widget.data!.contractorPurchaseOrders;
  //   comments = widget.data!.comment!;
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF3A5F85),
          title: Text(
              'In a world of gray, CCM provides clarity to all construction & facility projects'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: SizedBox(
                          height: 45.0,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Back'),
                          ),
                        )),
                  ),
                  Spacer(),
                  Expanded(
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.grey,
                      child: TextFormField(
                        controller: currency,
                        readOnly: true,
                        onTap: () {
                          showCurrencyPicker(
                            context: context,
                            showFlag: true,
                            showCurrencyName: true,
                            showCurrencyCode: true,
                            onSelect: (Currency cur) {
                              currency.text = cur.code;
                            },
                          );
                        },
                        decoration: InputDecoration(
                          hintText: 'INR',
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.grey,
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: DropdownButton<String>(
                              value: parentQuote,
                              items: quotationController.quotionlist.isEmpty
                                  ? [
                                      DropdownMenuItem(
                                        value: 'N/A',
                                        child: Text(
                                          "N/A",
                                        ),
                                      )
                                    ]
                                  : quotationController.quotionlist
                                      .where((Quotation val) =>
                                          val.isTrash == false)
                                      .toSet()
                                      .map((e) => DropdownMenuItem(
                                            child: Text(e.qnumber),
                                            value: e.qnumber,
                                          ))
                                      .toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  parentQuote = value!;
                                });
                              },
                              hint: Text("Parent Quote")),
                        ),
                      ),

                      //  TextFormField(
                      //   // controller: quotationno,
                      //   decoration: InputDecoration(
                      //     hintText: 'Parent Quote',
                      //     border:
                      //         OutlineInputBorder(borderSide: BorderSide.none),
                      //   ),
                      // ),
                    ),
                  ),
                  Expanded(
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.grey,
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: DropdownButton(
                              value: category,
                              items: categorylist
                                  .toSet()
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e),
                                        value: e,
                                      ))
                                  .toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  category = value!;
                                });
                              },
                              hint: Text("Select item")),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  color: Color(0xFFE8F3FA),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Client Quotation',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: Divider(),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            CardInputField(
                              readonly: false,
                              text: 'Quotation Number',
                              hinttext: 'Quotation No',
                              controller: clientQuotequotationNumber,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Client Name",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Card(
                                      color: Colors.white,
                                      elevation: 5,
                                      shadowColor: Colors.grey,
                                      child: DropdownButtonHideUnderline(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: DropdownButton<String>(
                                              value: clientQuoteclientName.text,
                                              items: clientController
                                                      .clientlist.isEmpty
                                                  ? [
                                                      DropdownMenuItem(
                                                        value: "N/A",
                                                        child: Text(
                                                          "N/A",
                                                        ),
                                                      )
                                                    ]
                                                  : clientController.clientlist
                                                      .toSet()
                                                      .map((e) =>
                                                          DropdownMenuItem(
                                                            child: Text(e.name),
                                                            value: e.name,
                                                          ))
                                                      .toList(),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  clientQuoteclientName.text =
                                                      value!;
                                                });
                                              },
                                              hint: Text("Client Name")),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // CardInputField(
                            //   readonly: false,
                            //   text: 'Client Name',
                            //   hinttext: 'Client Name',
                            //   controller: clientQuoteclientName,
                            // ),
                            CardInputField(
                              readonly: false,
                              text: 'Quote Amount',
                              hinttext: 'Quote Amount',
                              controller: clientQuoteAmount,
                            ),
                            CardInputField(
                              readonly: false,
                              text: 'Client Approval',
                              hinttext: 'Client Approval',
                              controller: clientQuoteclientApproval,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date Issued',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Card(
                                      color: Colors.white,
                                      elevation: 5,
                                      shadowColor: Colors.grey,
                                      child: TextFormField(
                                        controller: clientQuotedateIssued,
                                        onTap: () {
                                          _selectDate(
                                            context,
                                            DateTime.now(),
                                          ).then((value) {
                                            setState(() {
                                              clientQuotedateIssued.text = value
                                                  .toString()
                                                  .substring(0, 10);
                                            });
                                          });
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'dd-mm-yyyy',
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            CardInputField(
                              readonly: false,
                              text: 'Description',
                              hinttext: 'Description',
                              controller: clientQuoteDesciption,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Approval Status',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 5,
                                        shadowColor: Colors.grey,
                                        child: DropdownButtonHideUnderline(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: DropdownButton(
                                                value: clientQuoteApprovalStatus
                                                    .text,
                                                items: [
                                                  DropdownMenuItem(
                                                    child: Text("Approved"),
                                                    value: 'Approved',
                                                  ),
                                                  DropdownMenuItem(
                                                    child: Text("Pending"),
                                                    value: 'Pending',
                                                  ),
                                                  DropdownMenuItem(
                                                    child: Text("Rejected"),
                                                    value: 'Rejected',
                                                  ),
                                                  DropdownMenuItem(
                                                    child: Text("Canceled"),
                                                    value: 'Canceled',
                                                  ),
                                                ],
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    clientQuoteApprovalStatus
                                                        .text = value!;
                                                  });
                                                },
                                                hint: Text("Select item")),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Margin',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 80,
                                          child: Card(
                                            color: Colors.grey,
                                            elevation: 5,
                                            shadowColor: Colors.grey,
                                            child: TextFormField(
                                              readOnly: true,
                                              // controller: contactPerson,
                                              decoration: InputDecoration(
                                                hintText: '%',
                                                border: OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            color: Colors.grey,
                                            elevation: 5,
                                            shadowColor: Colors.grey,
                                            child: TextFormField(
                                              readOnly: true,
                                              // controller: contactPerson,
                                              decoration: InputDecoration(
                                                hintText: 'Amount',
                                                border: OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide.none),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            CardInputField(
                              readonly: false,
                              text: 'CCM Ticket Number',
                              hinttext: 'CCM Ticket Number',
                              controller: clientQuoteCCMTicketNumber,
                            ),
                            CardInputField(
                              readonly: false,
                              text: 'Job Completion Date',
                              hinttext: 'dd-mm-yyyy',
                              onTap: () {
                                _selectDate(
                                  context,
                                  DateTime.now(),
                                ).then((value) {
                                  setState(() {
                                    clientQuoteJobCompletionDate.text =
                                        value.toString().substring(0, 10);
                                  });
                                });
                              },
                              controller: clientQuoteJobCompletionDate,
                            ),
                            Spacer(),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Overall Status',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 5,
                                        shadowColor: Colors.grey,
                                        child: DropdownButtonHideUnderline(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: DropdownButton(
                                                value: clientQuoteOverallStatus
                                                    .text,
                                                items: [
                                                  DropdownMenuItem(
                                                    child: Text("Pending"),
                                                    value: 'Pending',
                                                  ),
                                                  DropdownMenuItem(
                                                    child: Text("Completed"),
                                                    value: 'Completed',
                                                  ),
                                                  DropdownMenuItem(
                                                    child: Text("Canceled"),
                                                    value: 'Canceled',
                                                  ),
                                                ],
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    clientQuoteOverallStatus
                                                        .text = value!;
                                                  });
                                                },
                                                hint: Text("Select item")),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  color: Color(0xFFE8F3FA),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Client Invoice',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Divider(),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              clientinvoices.isEmpty
                                  ? CardInputField(
                                      readonly: false,
                                      text: 'Client Invoice No',
                                      hinttext: 'Invoice No',
                                      controller: clientInvoiceNo,
                                    )
                                  : Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Client Invoice No',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: Card(
                                                  color: Colors.white,
                                                  elevation: 5,
                                                  shadowColor: Colors.grey,
                                                  child:
                                                      SimpleAutoCompleteTextField(
                                                    clearOnSubmit: false,
                                                    textSubmitted: (data) {
                                                      clientinvoices.isNotEmpty
                                                          ? clientinvoices
                                                              .forEach((v) {
                                                              if (v.number ==
                                                                  data) {
                                                                setState(() {
                                                                  clientInvoiceNo
                                                                          .text =
                                                                      v.number;
                                                                  clientInvoiceAmount
                                                                          .text =
                                                                      v.amount
                                                                          .toString();
                                                                  clientInvoiceIssueDate.text = v
                                                                      .issueDate
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          10);
                                                                  clientInvoiceLastRecieveDate.text = v
                                                                      .receivedDate
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          10);
                                                                });
                                                              }
                                                            })
                                                          : print('Null Value');
                                                    },
                                                    decoration: InputDecoration(
                                                        hintText: 'Invoice No'),
                                                    controller: clientInvoiceNo,
                                                    suggestions:
                                                        clientinvoices.map((e) {
                                                      print(clientinvoices);
                                                      print(e.number);
                                                      return e.number;
                                                    }).toList(),
                                                    key: clientkey,
                                                  )
                                                  //     DropdownButtonFormField(
                                                  //   items: clientinvoices
                                                  //       .map(
                                                  //         (e) =>
                                                  //             DropdownMenuItem(
                                                  //           child:
                                                  //               Text(e.number),
                                                  //           value: e.number,
                                                  //         ),
                                                  //       )
                                                  //       .toList(),
                                                  //   onChanged: (String? value) {
                                                  //     setState(() {
                                                  //       clientInvoiceNo.text =
                                                  //           value!;
                                                  //     });
                                                  //   },
                                                  //   decoration: InputDecoration(
                                                  //     hintText:
                                                  //         "Client Invoice No",
                                                  //     border:
                                                  //         OutlineInputBorder(
                                                  //             borderSide:
                                                  //                 BorderSide
                                                  //                     .none),
                                                  //   ),
                                                  //   value: clientInvoiceNo.text,
                                                  //   hint: Text(
                                                  //       "Client Invoice No"),
                                                  // )
                                                  //     DropdownButtonHideUnderline(
                                                  //   child: Padding(
                                                  //     padding: const EdgeInsets
                                                  //             .symmetric(
                                                  //         horizontal: 8.0),
                                                  //     child: DropdownButton(
                                                  // value: clientInvoiceNo
                                                  //     .text,
                                                  // items: clientinvoices
                                                  //     .map(
                                                  //       (e) =>
                                                  //           DropdownMenuItem(
                                                  //         child: Text(
                                                  //             e.number),
                                                  //         value: e.number,
                                                  //       ),
                                                  //     )
                                                  //     .toList(),
                                                  //         onChanged:
                                                  //             (String? value) {
                                                  //           setState(() {
                                                  //             clientInvoiceNo
                                                  //                 .text = value!;
                                                  //           });
                                                  //         },
                                                  // hint: Text(
                                                  //     "Client Invoice No")),
                                                  //   ),
                                                  // ),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              CardInputField(
                                readonly: false,
                                text: 'Client Invoice Amount',
                                hinttext: 'Client Invoice Amount',
                                controller: clientInvoiceAmount,
                              ),
                              CardInputField(
                                readonly: false,
                                text: 'Invoice Issue Date',
                                hinttext: 'dd-mm-yyyy',
                                controller: clientInvoiceIssueDate,
                                onTap: () {
                                  _selectDate(
                                    context,
                                    DateTime.now(),
                                  ).then((value) {
                                    setState(() {
                                      clientInvoiceIssueDate.text =
                                          value.toString().substring(0, 10);
                                    });
                                  });
                                },
                              ),
                              CardInputField(
                                readonly: false,
                                text: 'Last Recieved Date',
                                hinttext: 'dd-mm-yyyy',
                                onTap: () {
                                  _selectDate(
                                    context,
                                    DateTime.now(),
                                  ).then((value) {
                                    setState(() {
                                      clientInvoiceLastRecieveDate.text =
                                          value.toString().substring(0, 10);
                                    });
                                  });
                                },
                                controller: clientInvoiceLastRecieveDate,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Date Issued',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Card(
                                        color: Colors.grey[200],
                                        elevation: 5,
                                        shadowColor: Colors.grey,
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: clientInvoiceIssueDate,
                                          decoration: InputDecoration(
                                            hintText: 'dd-mm-yyyy',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                    ])),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            clientinvoices.add(
                                              ClientInvoice(
                                                clientcredits: clientcredits,
                                                clientinvoicepayments:
                                                    clientinvoicepayment,
                                                number: clientInvoiceNo.text,
                                                receivedDate: DateTime.parse(
                                                    clientInvoiceLastRecieveDate
                                                        .text),
                                                recievedamount: 0.00,
                                                amount: double.parse(
                                                    clientInvoiceAmount.text),
                                                issueDate: DateTime.parse(
                                                    clientInvoiceIssueDate
                                                        .text),
                                              ),
                                            );
                                          });

                                          clientInvoiceNo.clear();
                                          clientInvoiceLastRecieveDate.clear();
                                          clientInvoiceAmount.clear();
                                          clientInvoiceIssueDate.clear();
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.success,
                                              text: 'Quotation Added');
                                          clientinvoices.isNotEmpty
                                              ? clientkey.currentState!
                                                  .updateSuggestions(
                                                  clientinvoices
                                                      .map((e) => e.number)
                                                      .toList(),
                                                )
                                              : null;
                                          // showDialog(
                                          //     context: context,
                                          //     builder: (context) {
                                          //       return AlertDialog(
                                          //         title:
                                          //             Text('Quotation Added'),
                                          //       );
                                          //     });
                                        },
                                        child: Text('Add'),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          var invoice = ClientInvoice(
                                            number: clientInvoiceNo.text,
                                            receivedDate: DateTime.parse(
                                                clientInvoiceLastRecieveDate
                                                    .text),
                                            recievedamount: 0.00,
                                            amount: double.parse(
                                                clientInvoiceAmount.text),
                                            issueDate: DateTime.parse(
                                                clientInvoiceIssueDate.text),
                                          );
                                          // clientinvoices.remove(value)
                                        },
                                        child: Text('Edit'),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Client Invoice List',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20.0),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15.0,
                                                      ),
                                                      Divider(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: ElevatedButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: Text('Back'),
                                                        ),
                                                      ),
                                                      DataTable(
                                                          columns: [
                                                            DataColumn(
                                                              label: Text(
                                                                'Invoice No',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            DataColumn(
                                                              label: Text(
                                                                'Invoice Amount',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            DataColumn(
                                                              label: Text(
                                                                'Issued Date',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            DataColumn(
                                                              label: Text(
                                                                'Last Recieved Date',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            DataColumn(
                                                              label: Text(
                                                                'Recieved Amount',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            DataColumn(
                                                              label: Text(
                                                                'Delete',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ],
                                                          rows: clientinvoices
                                                              .map<DataRow>(
                                                                (e) => DataRow(
                                                                  cells: [
                                                                    DataCell(
                                                                      Text(e
                                                                          .number),
                                                                    ),
                                                                    DataCell(
                                                                      Text(e
                                                                          .amount
                                                                          .toString()),
                                                                    ),
                                                                    DataCell(
                                                                      Text(e
                                                                          .issueDate
                                                                          .toString()),
                                                                    ),
                                                                    DataCell(
                                                                      Text(e
                                                                          .receivedDate
                                                                          .toString()),
                                                                    ),
                                                                    DataCell(
                                                                      Text(e
                                                                          .recievedamount
                                                                          .toString()),
                                                                    ),
                                                                    DataCell(
                                                                      Icon(
                                                                        Icons
                                                                            .delete,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      onTap: () =>
                                                                          CoolAlert
                                                                              .show(
                                                                        width: MediaQuery.of(context).size.width > 500
                                                                            ? MediaQuery.of(context).size.width /
                                                                                2
                                                                            : MediaQuery.of(context).size.width *
                                                                                0.85,
                                                                        showCancelBtn:
                                                                            true,
                                                                        onCancelBtnTap:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                        onConfirmBtnTap:
                                                                            () {
                                                                          clientinvoices
                                                                              .remove(e);
                                                                          Navigator.pop(
                                                                              context);
                                                                          Navigator.pop(
                                                                              context);
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        context:
                                                                            context,
                                                                        type: CoolAlertType
                                                                            .confirm,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                              .toList()),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        child: Text('List Invoice'),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showcredits(
                                              name: 'Client',
                                              invoiceNo: clientInvoiceNo,
                                              invoiceAmount:
                                                  clientInvoiceAmount,
                                              invoiceIssueDate:
                                                  clientInvoiceIssueDate,
                                              creditamount: clientcreditamount,
                                              clientInvoiceNo: clientInvoiceNo,
                                              creditRecieveDate:
                                                  clientcreditRecieveDate,
                                              creditnoteno: clientcreditnoteno,
                                              recievedamount:
                                                  clientrecievedamount,
                                              paymentdate: clientpaymentdate);
                                        },
                                        child: Text('Payments/Credits'),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  color: Color(0xFFE8F3FA),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contractor Quotation',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Divider(),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              contractorPO.isEmpty
                                  ? CardInputField(
                                      readonly: false,
                                      text: 'PO Number',
                                      hinttext: 'PO Number',
                                      controller: contractorQuotationPONumber,
                                    )
                                  : Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'PO Number',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: Card(
                                                color: Colors.white,
                                                elevation: 5,
                                                shadowColor: Colors.grey,
                                                child:
                                                    SimpleAutoCompleteTextField(
                                                  clearOnSubmit: false,
                                                  textSubmitted: (data) {
                                                    contractorPO.isNotEmpty
                                                        ? contractorPO
                                                            .forEach((v) {
                                                            if (v.poNumber ==
                                                                data) {
                                                              setState(() {
                                                                contractorQuotationPONumber
                                                                        .text =
                                                                    v.poNumber;

                                                                contractorQuotationPOAmount
                                                                        .text =
                                                                    v.poAmount
                                                                        .toString();

                                                                contractorQuotationContractorName
                                                                        .text =
                                                                    v.name;

                                                                contractorQuotationPOIssueDate
                                                                        .text =
                                                                    v.issueDate
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            10);

                                                                contractorQuotationNo
                                                                        .text =
                                                                    v.quotationNumber!;

                                                                contractorQuotationAmount
                                                                        .text =
                                                                    v.quotationAmount
                                                                        .toString();

                                                                contractorQuotationWorkCommence
                                                                        .text =
                                                                    v.workCommenceDate
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            10);
                                                                contractorQuotationWorkComplete
                                                                        .text =
                                                                    v.workCompleteDate
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            10);
                                                              });
                                                            }
                                                          })
                                                        : print('Null Value');
                                                  },
                                                  decoration: InputDecoration(
                                                      hintText: 'PO No'),
                                                  controller:
                                                      contractorQuotationPONumber,
                                                  suggestions:
                                                      contractorPO.map((e) {
                                                    return e.poNumber;
                                                  }).toList(),
                                                  key: contractorkey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Contractor Name",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 5,
                                        shadowColor: Colors.grey,
                                        child: DropdownButtonHideUnderline(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: DropdownButton<String>(
                                                value:
                                                    contractorQuotationContractorName
                                                        .text,
                                                items: contractorController
                                                        .contractorlist.isEmpty
                                                    ? [
                                                        DropdownMenuItem(
                                                          value: "N/A",
                                                          child: Text(
                                                            "N/A",
                                                          ),
                                                        )
                                                      ]
                                                    : contractorController
                                                        .contractorlist
                                                        .toSet()
                                                        .map((e) =>
                                                            DropdownMenuItem(
                                                              child:
                                                                  Text(e.name),
                                                              value: e.name,
                                                            ))
                                                        .toList(),
                                                onChanged: (String? value) {
                                                  setState(() {
                                                    contractorQuotationContractorName
                                                        .text = value!;
                                                  });
                                                },
                                                hint: Text("Contractor Name")),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // CardInputField(
                              //   readonly: false,
                              //   text: 'Contractor Name',
                              //   hinttext: 'Contractor Name',
                              //   controller: contractorQuotationContractorName,
                              // ),
                              CardInputField(
                                readonly: false,
                                text: 'PO Amount',
                                hinttext: 'PO Amount',
                                controller: contractorQuotationPOAmount,
                              ),
                              CardInputField(
                                readonly: false,
                                text: 'PO Issued Date',
                                onTap: () {
                                  _selectDate(
                                    context,
                                    DateTime.now(),
                                  ).then((value) {
                                    setState(() {
                                      contractorQuotationPOIssueDate.text =
                                          value.toString().substring(0, 10);
                                    });
                                  });
                                },
                                hinttext: 'dd-mm-yyyy',
                                controller: contractorQuotationPOIssueDate,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              CardInputField(
                                readonly: false,
                                text: 'Quotation No',
                                hinttext: 'Quotation No',
                                controller: contractorQuotationNo,
                              ),
                              CardInputField(
                                readonly: false,
                                text: 'Quote Amount',
                                hinttext: 'Quote Amount',
                                controller: contractorQuotationAmount,
                              ),
                              CardInputField(
                                readonly: false,
                                text: 'Work Commence',
                                hinttext: 'dd-mm-yyyy',
                                onTap: () {
                                  _selectDate(
                                    context,
                                    DateTime.now(),
                                  ).then((value) {
                                    setState(() {
                                      contractorQuotationWorkCommence.text =
                                          value.toString().substring(0, 10);
                                    });
                                  });
                                },
                                controller: contractorQuotationWorkCommence,
                              ),
                              CardInputField(
                                readonly: false,
                                text: 'Work Complete',
                                hinttext: 'dd-mm-yyyy',
                                onTap: () {
                                  _selectDate(
                                    context,
                                    DateTime.now(),
                                  ).then((value) {
                                    setState(() {
                                      contractorQuotationWorkComplete.text =
                                          value.toString().substring(0, 10);
                                    });
                                  });
                                },
                                controller: contractorQuotationWorkComplete,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            contractorPO.add(ContractorPurchaseOrder(
                                                name: contractorQuotationContractorName
                                                    .text,
                                                poNumber: contractorQuotationPONumber
                                                    .text,
                                                quotationAmount: double.parse(
                                                    contractorQuotationAmount
                                                        .text),
                                                quotationNumber:
                                                    contractorQuotationNo.text,
                                                issueDate: DateTime.parse(
                                                    contractorQuotationPOIssueDate
                                                        .text),
                                                poAmount: double.parse(
                                                    contractorQuotationPOAmount
                                                        .text),
                                                workCommenceDate: DateTime.parse(
                                                    contractorQuotationWorkCommence.text),
                                                workCompleteDate: DateTime.parse(contractorQuotationWorkComplete.text),
                                                invoices: contractorInvoice));
                                            // clientinvoices.forEach((element) {
                                            //   if (element.number ==
                                            //       clientInvoiceNo.text) {
                                            //     element.contractorpo =
                                            //         contractorPO;
                                            //   }
                                            // });

                                            // contractorQuotationContractorName
                                            //     .clear();
                                            contractorQuotationPONumber.clear();
                                            contractorQuotationAmount.clear();
                                            contractorQuotationNo.clear();
                                            contractorQuotationPOIssueDate
                                                .clear();
                                            contractorQuotationPOAmount.clear();
                                            contractorQuotationWorkCommence
                                                .clear();
                                            contractorQuotationWorkComplete
                                                .clear();
                                            contractorPO.isNotEmpty
                                                ? contractorkey.currentState!
                                                    .updateSuggestions(
                                                    contractorPO
                                                        .map((e) => e.poNumber)
                                                        .toList(),
                                                  )
                                                : null;
                                          });

                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.success,
                                              text:
                                                  'Contractor Quotation Added');

                                          // print(
                                          //   clientinvoices.map(
                                          //     (e) => e.contractorpo!
                                          //         .map((e) => e.name),
                                          //   ),
                                          // );
                                          // Get.rawSnackbar(
                                          //     message:
                                          //         'Contractor Quotation Added',
                                          //     snackPosition: SnackPosition.TOP);
                                        },
                                        child: Text('Add'),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text('Edit'),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Contractor PO List',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20.0),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15.0,
                                                      ),
                                                      Divider(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: ElevatedButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: Text('Back'),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Card(
                                                          elevation: 5.0,
                                                          child: DataTable(
                                                              columnSpacing:
                                                                  52.0,
                                                              columns: [
                                                                DataColumn(
                                                                  label: Text(
                                                                    'Contractor Name',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    'Po Number',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    'Po Amount',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    'Po Issued Date',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    'Quotation No',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    'Quotation Amount',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    'Work Commence',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    'Work Complete',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    'Delete',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                              rows: contractorPO
                                                                  .map<DataRow>(
                                                                    (e) =>
                                                                        DataRow(
                                                                      cells: [
                                                                        DataCell(
                                                                          Text(e
                                                                              .name),
                                                                        ),
                                                                        DataCell(
                                                                          Text(e
                                                                              .poNumber
                                                                              .toString()),
                                                                        ),
                                                                        DataCell(
                                                                          Text(e
                                                                              .poAmount
                                                                              .toString()),
                                                                        ),
                                                                        DataCell(
                                                                          Text(e
                                                                              .issueDate
                                                                              .toString()),
                                                                        ),
                                                                        DataCell(
                                                                          Text(e
                                                                              .quotationNumber
                                                                              .toString()),
                                                                        ),
                                                                        DataCell(
                                                                          Text(e
                                                                              .quotationAmount
                                                                              .toString()),
                                                                        ),
                                                                        DataCell(
                                                                          Text(e
                                                                              .workCommenceDate
                                                                              .toString()),
                                                                        ),
                                                                        DataCell(
                                                                          Text(e
                                                                              .workCompleteDate
                                                                              .toString()),
                                                                        ),
                                                                        DataCell(
                                                                          Icon(
                                                                            Icons.delete,
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          onTap: () =>
                                                                              CoolAlert.show(
                                                                            width: MediaQuery.of(context).size.width > 500
                                                                                ? MediaQuery.of(context).size.width / 2
                                                                                : MediaQuery.of(context).size.width * 0.85,
                                                                            showCancelBtn:
                                                                                true,
                                                                            onCancelBtnTap: () =>
                                                                                Navigator.pop(context),
                                                                            onConfirmBtnTap:
                                                                                () {
                                                                              contractorPO.remove(e);
                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context);
                                                                              setState(() {});
                                                                            },
                                                                            context:
                                                                                context,
                                                                            type:
                                                                                CoolAlertType.confirm,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                  .toList()),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        child: Text('List Contractors'),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  color: Color(0xFFE8F3FA),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contractor Invoice',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Divider(),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              contractorInvoice.isEmpty
                                  ? CardInputField(
                                      readonly: false,
                                      text: 'Contractor Invoice No',
                                      hinttext: 'Contractor Invoice No',
                                      controller: contractorInvoiceNo,
                                    )
                                  : Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Contractor Invoice No',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: Card(
                                                color: Colors.white,
                                                elevation: 5,
                                                shadowColor: Colors.grey,
                                                child:
                                                    SimpleAutoCompleteTextField(
                                                  clearOnSubmit: false,
                                                  textSubmitted: (data) {
                                                    contractorInvoice.isNotEmpty
                                                        ? contractorInvoice
                                                            .forEach((v) {
                                                            if (v.number ==
                                                                data) {
                                                              setState(() {
                                                                contractorInvoiceNo
                                                                        .text =
                                                                    v.number;

                                                                contractorInvoiceAmount
                                                                        .text =
                                                                    v.amount
                                                                        .toString();

                                                                contractorInvoiceRecievedDate
                                                                        .text =
                                                                    v.receivedDate
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            10);

                                                                contractorInvoiceTaxInvoiceNo
                                                                        .text =
                                                                    v.taxNumber
                                                                        .toString();

                                                                contractorInvoicePaidAmount
                                                                        .text =
                                                                    v.paidamount
                                                                        .toString()
                                                                        .toString();

                                                                contractorInvoiceLastPaidDate
                                                                        .text =
                                                                    v.paidDate
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            10);
                                                              });
                                                            }
                                                          })
                                                        : print('Null Value');
                                                  },
                                                  decoration: InputDecoration(
                                                      hintText:
                                                          'Contractor Invoice Number'),
                                                  controller:
                                                      contractorQuotationPONumber,
                                                  suggestions: contractorInvoice
                                                      .map((e) {
                                                    return e.number;
                                                  }).toList(),
                                                  key: contractinvoiceorkey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              CardInputField(
                                readonly: false,
                                text: 'Contractor Invoice Amount',
                                hinttext: 'Contractor Invoice Amount',
                                controller: contractorInvoiceAmount,
                              ),
                              CardInputField(
                                  readonly: false,
                                  text: 'Invoice Recieved Date',
                                  hinttext: 'dd-mm-yyyy',
                                  controller: contractorInvoiceRecievedDate,
                                  onTap: () {
                                    _selectDate(
                                      context,
                                      DateTime.now(),
                                    ).then((value) {
                                      setState(() {
                                        contractorInvoiceRecievedDate.text =
                                            value.toString().substring(0, 10);
                                      });
                                    });
                                  }),
                              CardInputField(
                                readonly: false,
                                text: 'Tax Invoice No',
                                hinttext: 'Tax Invoice No',
                                controller: contractorInvoiceTaxInvoiceNo,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            children: [
                              CardInputField(
                                readonly: false,
                                text: 'Paid Amount',
                                hinttext: 'Paid Amount',
                                controller: contractorInvoicePaidAmount,
                              ),
                              CardInputField(
                                  readonly: false,
                                  text: 'Last Paid Date',
                                  hinttext: 'dd-mm-yyyy',
                                  controller: contractorInvoiceLastPaidDate,
                                  onTap: () {
                                    _selectDate(
                                      context,
                                      DateTime.now(),
                                    ).then((value) {
                                      setState(() {
                                        contractorInvoiceLastPaidDate.text =
                                            value.toString().substring(0, 10);
                                      });
                                    });
                                  }),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            contractorInvoice.add(
                                              ContractorInvoice(
                                                // payments: [],
                                                contractorinvoicepayments:
                                                    contractorinvoicepayment,
                                                contractorcredits:
                                                    contractorcredits,
                                                number:
                                                    contractorInvoiceNo.text,
                                                receivedDate: DateTime.parse(
                                                    contractorInvoiceRecievedDate
                                                        .text),
                                                amount: double.parse(
                                                    contractorInvoiceAmount
                                                        .text),
                                                paidDate: DateTime.parse(
                                                    contractorInvoiceLastPaidDate
                                                        .text),
                                                taxNumber:
                                                    contractorInvoiceTaxInvoiceNo
                                                        .text,
                                                paidamount: double.parse(
                                                    contractorInvoicePaidAmount
                                                        .text),
                                              ),
                                            );
                                            contractorPO.forEach((cpo) {
                                              if (cpo.poNumber ==
                                                  contractorQuotationPONumber
                                                      .text) {
                                                cpo.invoices =
                                                    contractorInvoice;
                                              }
                                              contractorInvoice.isNotEmpty
                                                  ? contractinvoiceorkey
                                                      .currentState!
                                                      .updateSuggestions(
                                                      contractorInvoice
                                                          .map((e) => e.number)
                                                          .toList(),
                                                    )
                                                  : null;
                                            });
                                            // clientinvoices.forEach((ci) {
                                            //   if (ci.number ==
                                            //       clientInvoiceNo.text) {
                                            //     ci.contractorpo = contractorPO;
                                            //   }
                                            // });
                                            contractorInvoiceNo.clear();
                                            contractorInvoiceAmount.clear();
                                            contractorInvoiceLastPaidDate
                                                .clear();
                                            contractorInvoiceTaxInvoiceNo
                                                .clear();
                                            contractorInvoicePaidAmount.clear();
                                          });

                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.success,
                                              text:
                                                  'Contractor Quotation Added');

                                          Get.rawSnackbar(
                                              message: 'Invoice Added',
                                              snackPosition: SnackPosition.TOP);
                                        },
                                        child: Text('Add'),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text('Edit'),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'Contractor Invoice List',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20.0),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15.0,
                                                      ),
                                                      Divider(),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: ElevatedButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                          child: Text('Back'),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Card(
                                                          elevation: 5.0,
                                                          child: DataTable(
                                                              columnSpacing:
                                                                  52.0,
                                                              columns: [
                                                                DataColumn(
                                                                  label: Text(
                                                                    'Invoice No',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    'Invoice Amount',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    'Invoice Received Date',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    'Last Paid Date',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    'Paid Amount',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                    'Delete',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ],
                                                              rows: contractorInvoice
                                                                  .map<DataRow>(
                                                                    (e) =>
                                                                        DataRow(
                                                                      cells: [
                                                                        DataCell(
                                                                          Text(e
                                                                              .number),
                                                                        ),
                                                                        DataCell(
                                                                          Text(e
                                                                              .amount
                                                                              .toString()),
                                                                        ),
                                                                        DataCell(
                                                                          Text(e
                                                                              .receivedDate
                                                                              .toString()),
                                                                        ),
                                                                        DataCell(
                                                                          Text(e
                                                                              .paidDate
                                                                              .toString()),
                                                                        ),
                                                                        DataCell(
                                                                          Text(e
                                                                              .paidamount
                                                                              .toString()),
                                                                        ),
                                                                        DataCell(
                                                                          Icon(
                                                                            Icons.delete,
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          onTap: () =>
                                                                              CoolAlert.show(
                                                                            width: MediaQuery.of(context).size.width > 500
                                                                                ? MediaQuery.of(context).size.width / 2
                                                                                : MediaQuery.of(context).size.width * 0.85,
                                                                            showCancelBtn:
                                                                                true,
                                                                            onCancelBtnTap: () =>
                                                                                Navigator.pop(context),
                                                                            onConfirmBtnTap:
                                                                                () {
                                                                              contractorInvoice.remove(e);
                                                                              Navigator.pop(context);
                                                                              Navigator.pop(context);
                                                                              setState(() {});
                                                                            },
                                                                            context:
                                                                                context,
                                                                            type:
                                                                                CoolAlertType.confirm,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                  .toList()),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              });
                                        },
                                        child: Text('List Invoice'),
                                      ),
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 8.0),
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showcredits(
                                              name: 'Contrator',
                                              invoiceNo: contractorInvoiceNo,
                                              invoiceAmount:
                                                  contractorInvoiceAmount,
                                              invoiceIssueDate:
                                                  contractorInvoiceLastPaidDate,
                                              creditamount:
                                                  contractorcreditamount,
                                              clientInvoiceNo:
                                                  contractorInvoiceNo,
                                              creditRecieveDate:
                                                  contractorcreditRecieveDate,
                                              creditnoteno:
                                                  contractorcreditnoteno,
                                              recievedamount:
                                                  contractorrecievedamount,
                                              paymentdate:
                                                  contractorpaymentdate);
                                        },
                                        child: Text('Payments/Credits'),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 5,
                  color: Color(0xFFE8F3FA),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Comments',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 250,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.60,
                                        child: Card(
                                            color: Colors.grey[200],
                                            elevation: 5,
                                            shadowColor: Colors.grey,
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: comments
                                                    .map(
                                                      (e) => ListTile(
                                                        leading: Text(
                                                          '->',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 22,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        title: Text(e),
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Add Comment',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Card(
                                        color: Colors.white,
                                        elevation: 5,
                                        shadowColor: Colors.grey,
                                        child: TextFormField(
                                          controller: comment,
                                          decoration: InputDecoration(
                                            hintText: 'Comment Something ....',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 8.0),
                                          child: SizedBox(
                                            height: 45.0,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  comments.add(comment.text);
                                                });
                                                comment.clear();
                                              },
                                              child: Text('Add'),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () async {
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.loading,
                            text: 'Loading');
                        Quotation quotationval = Quotation(
                            search: [
                              clientQuotequotationNumber.text,
                              clientInvoiceNo.text,
                              contractorInvoiceNo.text,
                              clientQuoteCCMTicketNumber.text,
                              contractorQuotationPONumber.text,
                              contractorcreditnoteno.text,
                              clientcreditnoteno.text
                            ],
                            category: category!,
                            inr: currency.text,
                            isTrash: false,
                            qnumber: clientQuotequotationNumber.text,
                            clientname: clientQuoteclientName.text,
                            qamount: double.parse(clientQuoteAmount.text),
                            clientApproval: clientQuoteclientApproval.text,
                            dateIssued:
                                DateTime.parse(clientQuotedateIssued.text),
                            description: clientQuoteDesciption.text,
                            approvalStatus: clientQuoteApprovalStatus.text,
                            ccmTicketNumber: clientQuoteCCMTicketNumber.text,
                            jobcompletionDate: DateTime.parse(
                                clientQuoteJobCompletionDate.text),
                            overallstatus: clientQuoteOverallStatus.text,
                            clientInvoices: clientinvoices,
                            contractorPurchaseOrders: contractorPO);
                        print(quotationval.toJson());
                        widget.isEdit
                            ? await countries
                                .doc(session.country!.code)
                                .collection('quotations')
                                .doc(widget.id)
                                .update(
                                  quotationval.toJson(),
                                )
                                .whenComplete(() {
                                var condocid;
                                contractorController.contractorlist
                                    .forEach((v) {
                                  if (v.name ==
                                      contractorQuotationContractorName.text) {
                                    condocid = v.docid;
                                    print(condocid);
                                  }
                                });
                                contractors.doc(condocid).update(
                                  {
                                    "payable": int.parse(
                                        contractorQuotationPOAmount.text),
                                  },
                                ).then((value) {
                                  CoolAlert.show(
                                      onConfirmBtnTap: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      context: context,
                                      type: CoolAlertType.success,
                                      text: 'Quotation Updated');
                                  Navigator.pop(context);
                                });
                              })
                            : await countries
                                .doc(session.country!.code)
                                .collection('quotations')
                                .add(
                                  quotationval.toJson(),
                                )
                                .whenComplete(() {
                                var condocid;
                                contractorController.contractorlist
                                    .forEach((v) {
                                  if (v.name ==
                                      contractorQuotationContractorName.text) {
                                    condocid = v.docid;
                                    print(condocid);
                                  }
                                });
                                contractors.doc(condocid).update(
                                  {
                                    "payable": int.parse(
                                        contractorQuotationPOAmount.text),
                                  },
                                ).then((v) {
                                  List<double> templist = [];
                                  clientinvoices.forEach((element1) {
                                    element1.clientinvoicepayments!
                                        .forEach((element2) {
                                      templist.add(element2.invoiceamount!);
                                    });
                                  });
                                  // .fold(
                                  //     clientinvoices
                                  //         .first.clientinvoicepayments,
                                  //     (List<InvoicePaymentModel>? previousValue,
                                  //             element) =>
                                  //         previousValue +
                                  //         element.clientinvoicepayments);
                                  firestore
                                      .collection('payments')
                                      .doc('clienttotals')
                                      .update(
                                    {
                                      'totalamount': FieldValue.increment(
                                        double.parse(
                                          clientQuoteAmount.text,
                                        ),
                                      ),
                                      'totalrecieved': FieldValue.increment(
                                        templist.fold(
                                            0,
                                            (previousValue, element) =>
                                                previousValue + element),
                                      ),
                                      DateTime.now().month.toString():
                                          FieldValue.increment(
                                        double.parse(
                                          clientQuoteAmount.text,
                                        ),
                                      ),
                                    },
                                  );
                                  CoolAlert.show(
                                      onConfirmBtnTap: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      context: context,
                                      type: CoolAlertType.success,
                                      text: 'Quotation Added!');
                                });
                              });
                      },
                      child: Text('Submit'),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  showcredits({
    required String name,
    required TextEditingController invoiceNo,
    required TextEditingController invoiceAmount,
    required TextEditingController invoiceIssueDate,
    required TextEditingController creditamount,
    required TextEditingController clientInvoiceNo,
    required TextEditingController creditRecieveDate,
    required TextEditingController creditnoteno,
    required TextEditingController recievedamount,
    required TextEditingController paymentdate,
  }) {
    bool isCredit = false;
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SingleChildScrollView(
              child: StatefulBuilder(builder: (context, setState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Back'),
                          ),
                          SizedBox(
                            width: 25.0,
                          ),
                          ElevatedButton(
                            onPressed: () =>
                                setState(() => isCredit = !isCredit),
                            child:
                                Text(isCredit ? 'Add Invoice' : 'Add Credit'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    isCredit
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CardInputField(
                                      readonly: true,
                                      controller: invoiceNo,
                                      hinttext: 'Invoice Number',
                                      text: 'Invoice Number'),
                                  CardInputField(
                                      readonly: true,
                                      controller: invoiceAmount,
                                      hinttext: 'Invoice Amount',
                                      text: 'Invoice Amount'),
                                  CardInputField(
                                      readonly: true,
                                      controller: invoiceIssueDate,
                                      hinttext: 'Issued Date',
                                      text: 'Issued Date'),
                                ],
                              ),
                              Row(
                                children: [
                                  CardInputField(
                                      readonly: false,
                                      controller: creditamount,
                                      hinttext: 'Credit Amount',
                                      text: 'Credit Amount'),
                                  CardInputField(
                                      readonly: false,
                                      controller: creditRecieveDate,
                                      hinttext: 'Client Recieved Date',
                                      text: 'Client Recieved Date'),
                                  CardInputField(
                                      readonly: false,
                                      controller: creditnoteno,
                                      hinttext: 'Client Note No',
                                      text: 'Client Note No'),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16.0, left: 16.0, top: 10.0),
                                    child: SizedBox(
                                      height: 50,
                                      width: 100,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(
                                            () => name == 'Client'
                                                ? clientcredits.add(
                                                    CreditModel(
                                                      invoiceamount:
                                                          double.parse(
                                                              clientInvoiceAmount
                                                                  .text),
                                                      invoicenumber:
                                                          clientInvoiceNo.text,
                                                      issueddate:
                                                          clientInvoiceIssueDate
                                                              .text,
                                                      creditRecieveDate:
                                                          creditRecieveDate
                                                              .text,
                                                      creditamount:
                                                          double.parse(
                                                              creditamount
                                                                  .text),
                                                    ),
                                                  )
                                                : contractorcredits.add(
                                                    CreditModel(
                                                      invoiceamount:
                                                          double.parse(
                                                              clientInvoiceAmount
                                                                  .text),
                                                      invoicenumber:
                                                          clientInvoiceNo.text,
                                                      issueddate:
                                                          clientInvoiceIssueDate
                                                              .text,
                                                      creditRecieveDate:
                                                          creditRecieveDate
                                                              .text,
                                                      creditamount:
                                                          double.parse(
                                                              creditamount
                                                                  .text),
                                                    ),
                                                  ),
                                          );
                                        },
                                        child: Text('Add'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: DataTable(
                                    columns: [
                                      'Credit Note Amount',
                                      'Client Note Recieved Date',
                                      'Client Note Number',
                                      'Edit',
                                      'Delete'
                                    ]
                                        .map<DataColumn>(
                                          (e) => DataColumn(
                                            label: Text(e),
                                          ),
                                        )
                                        .toList(),
                                    rows: clientcredits
                                        .map<DataRow>((e) => DataRow(cells: [
                                              DataCell(
                                                Text(
                                                  e.creditamount.toString(),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  e.creditRecieveDate!,
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  e.creditnoteno!,
                                                ),
                                              ),
                                              DataCell(IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.edit))),
                                              DataCell(
                                                IconButton(
                                                  onPressed: () {
                                                    CoolAlert.show(
                                                        type: CoolAlertType
                                                            .confirm,
                                                        context: context,
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                500
                                                            ? MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2
                                                            : MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.85,
                                                        showCancelBtn: true,
                                                        onCancelBtnTap: () =>
                                                            Navigator.pop(
                                                                context),
                                                        onConfirmBtnTap: () {
                                                          clientcredits
                                                              .remove(e);
                                                        });
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ]))
                                        .toList()),
                              )
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CardInputField(
                                      readonly: true,
                                      controller: clientInvoiceNo,
                                      hinttext: 'Invoice Number',
                                      text: 'Invoice Number'),
                                  CardInputField(
                                      readonly: true,
                                      controller: clientInvoiceAmount,
                                      hinttext: 'Invoice Amount',
                                      text: 'Invoice Amount'),
                                  CardInputField(
                                      readonly: true,
                                      controller: clientInvoiceIssueDate,
                                      hinttext: 'Issued Date',
                                      text: 'Issued Date'),
                                ],
                              ),
                              Row(
                                children: [
                                  CardInputField(
                                      readonly: false,
                                      controller: recievedamount,
                                      hinttext: 'Recieved Amount',
                                      text: 'Recieved Amount'),
                                  CardInputField(
                                      readonly: false,
                                      controller: paymentdate,
                                      hinttext: 'Payment Date',
                                      text: 'Payment Date'),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16.0, left: 16.0, top: 10.0),
                                    child: SizedBox(
                                      height: 50,
                                      width: 100,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(
                                            () => name == 'Client'
                                                ? clientinvoicepayment.add(
                                                    InvoicePaymentModel(
                                                        invoiceamount:
                                                            double.parse(
                                                                clientInvoiceAmount
                                                                    .text),
                                                        invoicenumber:
                                                            clientInvoiceNo
                                                                .text,
                                                        issueddate:
                                                            clientInvoiceIssueDate
                                                                .text,
                                                        recievedamount:
                                                            double.parse(
                                                                recievedamount
                                                                    .text),
                                                        paymentdate:
                                                            paymentdate.text),
                                                  )
                                                : contractorinvoicepayment.add(
                                                    InvoicePaymentModel(
                                                        invoiceamount: double
                                                            .parse(
                                                                clientInvoiceAmount
                                                                    .text),
                                                        invoicenumber:
                                                            clientInvoiceNo
                                                                .text,
                                                        issueddate:
                                                            clientInvoiceIssueDate
                                                                .text,
                                                        recievedamount:
                                                            double.parse(
                                                                recievedamount
                                                                    .text),
                                                        paymentdate:
                                                            paymentdate.text)),
                                          );
                                        },
                                        child: Text('Add'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: DataTable(
                                    columns: [
                                      'Invoice No',
                                      'Invoice Amount',
                                      'Issue Date',
                                      'Recieved Date',
                                      'Recieved Amount',
                                      'Edit',
                                      'Delete'
                                    ]
                                        .map<DataColumn>(
                                          (e) => DataColumn(
                                            label: Text(e),
                                          ),
                                        )
                                        .toList(),
                                    rows: clientinvoicepayment
                                        .map<DataRow>((e) => DataRow(cells: [
                                              DataCell(
                                                Text(
                                                  e.invoicenumber!,
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  e.invoiceamount.toString(),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  e.issueddate!,
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  e.paymentdate!,
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  e.recievedamount.toString(),
                                                ),
                                              ),
                                              DataCell(IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(Icons.edit))),
                                              DataCell(
                                                IconButton(
                                                  onPressed: () {
                                                    CoolAlert.show(
                                                        type: CoolAlertType
                                                            .confirm,
                                                        context: context,
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width >
                                                                500
                                                            ? MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2
                                                            : MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.85,
                                                        showCancelBtn: true,
                                                        onCancelBtnTap: () =>
                                                            Navigator.pop(
                                                                context),
                                                        onConfirmBtnTap: () {
                                                          clientinvoicepayment
                                                              .remove(e);
                                                        });
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ]))
                                        .toList()),
                              )
                            ],
                          ),
                  ],
                );
              }),
            ),
          );
        });
  }
}

// class AddInovice extends StatelessWidget {
//   AddInovice(
//       {required this.invoiceamount,
//       required this.invoicenumber,
//       required this.issueddate,
//       required this.paymentdate,
//       required this.recievedamount,
//       required this.clientcredits,
//       Key? key})
//       : super(key: key);
//   TextEditingController invoicenumber,
//       invoiceamount,
//       issueddate,
//       recievedamount,
//       paymentdate;
//   List<ClientCreditModel> clientcredits;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           children: [
//             CardInputField(
//                 readonly: false,
//                 controller: invoicenumber,
//                 hinttext: 'Invoice Number',
//                 text: 'Invoice Number'),
//             CardInputField(
//                 readonly: false,
//                 controller: invoiceamount,
//                 hinttext: 'Invoice Amount',
//                 text: 'Invoice Amount'),
//             CardInputField(
//                 readonly: false,
//                 controller: invoicenumber,
//                 hinttext: 'Issued Date',
//                 text: 'Issued Date'),
//           ],
//         ),
//         Row(
//           children: [
//             CardInputField(
//                 readonly: false,
//                 controller: invoicenumber,
//                 hinttext: 'Invoice Number',
//                 text: 'Invoice Number'),
//             CardInputField(
//                 readonly: false,
//                 controller: invoicenumber,
//                 hinttext: 'Invoice Number',
//                 text: 'Invoice Number'),
//             Padding(
//               padding:
//                   const EdgeInsets.only(right: 16.0, left: 16.0, top: 10.0),
//               child: SizedBox(
//                 height: 50,
//                 width: 100,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     this.clientcredits.add(ClientCreditModel(
//                         invoiceamount: double.parse(invoiceamount.text),
//                         invoicenumber: invoicenumber.text,
//                         issueddate: issueddate.text,
//                         recievedamount: double.parse(recievedamount.text),
//                         paymentdate: paymentdate.text));
//                   },
//                   child: Text('Add'),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

class AddCredit extends StatelessWidget {
  const AddCredit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CardInputField extends StatelessWidget {
  const CardInputField(
      {Key? key,
      this.onTap,
      required this.readonly,
      required this.controller,
      required this.hinttext,
      required this.text})
      : super(key: key);
  final String text, hinttext;
  final onTap;
  final bool readonly;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              color: Colors.white,
              elevation: 5,
              shadowColor: Colors.grey,
              child: TextFormField(
                onTap: onTap,
                readOnly: readonly,
                controller: controller,
                decoration: InputDecoration(
                  hintText: hinttext,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
