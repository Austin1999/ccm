import 'package:ccm/controllers/getControllers.dart';
import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/quotation.dart';
import 'package:ccm/services/firebase.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_picker/country_picker.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class QuotationView extends StatefulWidget {
  const QuotationView({Key? key}) : super(key: key);

  @override
  _QuotationViewState createState() => _QuotationViewState();
}

class _QuotationViewState extends State<QuotationView> {
  String? category;
  TextEditingController currency = TextEditingController();
  TextEditingController clientQuotequotationNumber = TextEditingController();
  TextEditingController clientQuoteclientName =
      TextEditingController(text: clientController.clientlist.value.first.name);
  TextEditingController clientQuoteAmount = TextEditingController();
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
      TextEditingController();
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
  @override
  Widget build(BuildContext context) {
    print(clientController.clientlist);
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
                      child: TextFormField(
                        // controller: quotationno,
                        decoration: InputDecoration(
                          hintText: 'Parent Quote',
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
                          child: DropdownButton(
                              value: category,
                              items: categorylist
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
                                          child: DropdownButton(
                                              value: clientQuoteclientName.text,
                                              items: clientController
                                                  .clientlist.value
                                                  .map((e) => DropdownMenuItem(
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
                                                      DropdownButtonFormField(
                                                    items: clientinvoices
                                                        .map(
                                                          (e) =>
                                                              DropdownMenuItem(
                                                            child:
                                                                Text(e.number),
                                                            value: e.number,
                                                          ),
                                                        )
                                                        .toList(),
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        clientInvoiceNo.text =
                                                            value!;
                                                      });
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          "Client Invoice No",
                                                      border:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                    ),
                                                    value: clientInvoiceNo.text,
                                                    hint: Text(
                                                        "Client Invoice No"),
                                                  )
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
                                          // clientInvoiceNo.clear();
                                          clientInvoiceLastRecieveDate.clear();
                                          clientInvoiceAmount.clear();
                                          clientInvoiceIssueDate.clear();
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.success,
                                              text: 'Quotation Added');
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
                                                                          clientinvoices
                                                                              .remove(e),
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
                                        onPressed: () {},
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
                              CardInputField(
                                readonly: false,
                                text: 'PO Number',
                                hinttext: 'PO Number',
                                controller: contractorQuotationPONumber,
                              ),
                              CardInputField(
                                readonly: false,
                                text: 'Contractor Name',
                                hinttext: 'Contractor Name',
                                controller: contractorQuotationContractorName,
                              ),
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
                                          Get.rawSnackbar(
                                              message: 'Quotation Added',
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
                                                                              contractorPO.remove(e),
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
                              CardInputField(
                                readonly: false,
                                text: 'Contractor Invoice No',
                                hinttext: 'Contractor Invoice No',
                                controller: contractorInvoiceNo,
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
                                          contractorInvoice.add(
                                            ContractorInvoice(
                                              // payments: [],
                                              number: contractorInvoiceNo.text,
                                              receivedDate: DateTime.parse(
                                                  contractorInvoiceRecievedDate
                                                      .text),
                                              amount: double.parse(
                                                  contractorInvoiceAmount.text),
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
                                                                              contractorInvoice.remove(e),
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
                                        onPressed: () {},
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
                                      Card(
                                        color: Colors.grey[200],
                                        elevation: 5,
                                        shadowColor: Colors.grey,
                                        child: TextFormField(
                                          readOnly: true,
                                          maxLines: 10,
                                          // controller: quotationno,
                                          decoration: InputDecoration(
                                            // hintText: 'Contractor Invoice No',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
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
                                          // controller: clientname,
                                          decoration: InputDecoration(
                                            hintText: 'Comment Something ....',
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none),
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
                                    child: SizedBox(
                                      height: 45.0,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Text('Send'),
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () async {
                        Quotation quotationval = Quotation(
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
                        await countries
                            .doc(session.country!.code)
                            .collection('quotations')
                            .add(
                              quotationval.toJson(),
                            );
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
