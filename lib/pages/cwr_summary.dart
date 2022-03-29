import 'package:ccm/controllers/getControllers.dart';
import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/quotation.dart';
import 'package:ccm/pages/quotation_view.dart';
import 'package:ccm/services/firebase.dart';
import 'package:ccm/widgets/widget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'countries_list.dart';

class CwrSummary extends StatefulWidget {
  CwrSummary({Key? key}) : super(key: key);

  @override
  _CwrSummaryState createState() => _CwrSummaryState();
}

class _CwrSummaryState extends State<CwrSummary>
    with SingleTickerProviderStateMixin {
  String? _value;
  String? _approvalvalue;
  TextEditingController clientQuoteclientName = TextEditingController();
  TextEditingController searchcon = TextEditingController();
  List<Quotation>? filtereddocs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Get.put(QuotationController());

    setState(() {
      clientQuoteclientName = TextEditingController(
          text: clientController.clientlist.isEmpty
              ? 'N/A'
              : clientController.clientlist.first.name);
      filtereddocs = quotationController.quotionlist;
      // print(filtereddocs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF3A5F85)),
      backgroundColor: Color(0xFFFAFAFA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Align(
                  //   alignment: Alignment.centerLeft,
                  //   child:
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(session.country!.name,
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                  // ),
                  Row(
                    children: [
                      Tooltip(
                        message: "Add Quotation",
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            // style: ButtonStyle(shape: BoxShape.rectangle),
                            onPressed: () {
                              Get.to(
                                () => QuotationView(
                                  // data: Quotation(
                                  //     qnumber: '',
                                  //     clientname: '',
                                  //     qamount: 0.00,
                                  //     clientApproval: '',
                                  //     dateIssued: DateTime.now(),
                                  //     description: '',
                                  //     approvalStatus: '',
                                  //     ccmTicketNumber: '',
                                  //     jobcompletionDate: DateTime.now(),
                                  //     overallstatus: '',
                                  //     clientInvoices: [],
                                  //     isTrash: false),
                                  isEdit: false,
                                ),
                              );
                            },
                            child: AspectRatio(
                                aspectRatio: 1,
                                child: Icon(
                                  Icons.add,
                                  size: 20,
                                )),
                          ),
                        ),
                      ),
                      Tooltip(
                        message: "Export",
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: AspectRatio(
                                aspectRatio: 1,
                                child: Icon(
                                  Icons.download,
                                  size: 20,
                                )),
                          ),
                        ),
                      ),
                      Tooltip(
                        message: "Recycle Bin",
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child:
                                          StreamBuilder<
                                                  QuerySnapshot<
                                                      Map<String, dynamic>>>(
                                              stream: countries
                                                  .doc(session.country!.code)
                                                  .collection('quotations')
                                                  .where('isTrash',
                                                      isEqualTo: true)
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                        ConnectionState
                                                            .active &&
                                                    snapshot.hasData) {
                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          height: 50,
                                                          width:
                                                              double.infinity,
                                                          color: Colors.blue,
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              'Recycle Bin',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                fontSize: 25,
                                                              ),
                                                            ),
                                                          )),
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: DataTable(
                                                          headingTextStyle:
                                                              TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                          columns: [
                                                            "INVOICE",
                                                            "QUOTE NO",
                                                            "DATE ISSUED",
                                                            "CLIENT",
                                                            "DESCRIPTION",
                                                            "QUOTE AMT",
                                                            "STATUS",
                                                            "CLIENT PO",
                                                            // "MARGIN %",
                                                            "MARGIN AMT",
                                                            "CCM TKT NO",
                                                            "COMPLETION DATE",
                                                            "RESTORE",
                                                            "DELETE"
                                                          ]
                                                              .map((e) =>
                                                                  DataColumn(
                                                                      label: Text(
                                                                          e)))
                                                              .toList(),
                                                          rows: snapshot
                                                              .data!.docs
                                                              .map<DataRow>(
                                                            (e) {
                                                              print(e.data());
                                                              Quotation data =
                                                                  Quotation
                                                                      .fromJson(
                                                                          e.data(),
                                                                          e.id);
                                                              return DataRow(
                                                                cells: [
                                                                  DataCell(
                                                                    IconButton(
                                                                      onPressed:
                                                                          () {},
                                                                      icon: Icon(
                                                                          Icons
                                                                              .notes_rounded),
                                                                    ),
                                                                  ),
                                                                  DataCell(
                                                                    Text(data
                                                                        .qnumber),
                                                                  ),
                                                                  DataCell(
                                                                    Text(
                                                                      data.dateIssued
                                                                          .toString()
                                                                          .substring(
                                                                              0,
                                                                              10),
                                                                    ),
                                                                  ),
                                                                  DataCell(
                                                                    Text(data
                                                                        .clientname),
                                                                  ),
                                                                  DataCell(
                                                                    Text(data
                                                                        .description),
                                                                  ),
                                                                  DataCell(
                                                                    Text(data
                                                                        .qamount
                                                                        .toString()),
                                                                  ),
                                                                  DataCell(
                                                                    Text(data
                                                                        .approvalStatus),
                                                                  ),
                                                                  DataCell(
                                                                    Text(''),
                                                                  ),
                                                                  DataCell(
                                                                    Text(''),
                                                                  ),
                                                                  DataCell(
                                                                    Text(data
                                                                        .ccmTicketNumber),
                                                                  ),
                                                                  DataCell(
                                                                    Text(data
                                                                        .jobcompletionDate
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            10)),
                                                                  ),
                                                                  DataCell(
                                                                    IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .restore),
                                                                      onPressed:
                                                                          () {
                                                                        countries
                                                                            .doc(session.country!.code)
                                                                            .collection('quotations')
                                                                            .doc(e.id)
                                                                            .update(
                                                                          {
                                                                            "isTrash":
                                                                                false
                                                                          },
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                                  DataCell(
                                                                    IconButton(
                                                                      onPressed:
                                                                          () {
                                                                        CoolAlert
                                                                            .show(
                                                                          width: MediaQuery.of(context).size.width > 500
                                                                              ? MediaQuery.of(context).size.width / 2
                                                                              : MediaQuery.of(context).size.width * 0.85,
                                                                          showCancelBtn:
                                                                              true,
                                                                          onCancelBtnTap: () =>
                                                                              Navigator.pop(context),
                                                                          onConfirmBtnTap:
                                                                              () {
                                                                            // setState(() {
                                                                            countries.doc(session.country!.code).collection('quotations').doc(e.id).delete();
                                                                            // });
                                                                            Navigator.pop(context);
                                                                          },
                                                                          context:
                                                                              context,
                                                                          type:
                                                                              CoolAlertType.confirm,
                                                                        );
                                                                      },
                                                                      icon: Icon(
                                                                          Icons
                                                                              .delete),
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          ).toList(),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20.0,
                                                      ),
                                                      Center(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      16.0),
                                                              child: Text(
                                                                  'Cancel'),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Shimmer.fromColors(
                                                    baseColor:
                                                        Colors.grey[300]!,
                                                    highlightColor:
                                                        Colors.grey[100]!,
                                                    // enabled: _enabled,
                                                    child:
                                                        SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.vertical,
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: DataTable(
                                                          headingTextStyle:
                                                              TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                          columns: [
                                                            "EDIT",
                                                            "INVOICE",
                                                            "QUOTE NO",
                                                            "DATE ISSUED",
                                                            "CLIENT",
                                                            "DESCRIPTION",
                                                            "QUOTE AMT",
                                                            "STATUS",
                                                            "CLIENT PO",
                                                            // "MARGIN %",
                                                            "MARGIN AMT",
                                                            "CCM TKT NO",
                                                            "COMPLETION DATE",
                                                            "DELETE"
                                                          ]
                                                              .map((e) =>
                                                                  DataColumn(
                                                                      label:
                                                                          Text(
                                                                    e,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  )))
                                                              .toList(),
                                                          rows: List.generate(
                                                            20,
                                                            (index) => DataRow(
                                                              cells: [
                                                                DataCell(
                                                                  Icon(
                                                                    Icons.edit,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Icon(
                                                                    Icons
                                                                        .notes_rounded,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            4.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            4.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            4.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            4.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            4.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            4.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            4.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            4.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            4.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            4.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                                DataCell(
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            4.0),
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          100,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }),
                                    );
                                  });
                            },
                            child: AspectRatio(
                                aspectRatio: 1,
                                child: Icon(
                                  Icons.delete,
                                  size: 20,
                                )),
                          ),
                        ),
                      ),
                      // Tooltip(
                      //   message: "Refresh",
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(16.0),
                      //     child: ElevatedButton(
                      //       onPressed: () {},
                      //       child: AspectRatio(
                      //           aspectRatio: 1,
                      //           child: Icon(
                      //             Icons.refresh,
                      //             size: 20,
                      //           )),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                color: Color(0xFFE8F3FA),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        // Table(children: [
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
                                'Search',
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
                                  onChanged: (value) => setState(() {}),
                                  controller: searchcon,
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'From',
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
                                    decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.calendar_today),
                                      hintText: 'dd-mm-yyy',
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                )
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
                                  'To',
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
                                    decoration: InputDecoration(
                                      suffixIcon: Icon(Icons.calendar_today),
                                      hintText: 'dd-mm-yyy',
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                  ),
                                )
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
                                            value: _value,
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
                                              DropdownMenuItem(
                                                child: Text("All Quotations"),
                                                value: 'All Quotations',
                                              )
                                            ],
                                            onChanged: (String? value) {
                                              setState(() {
                                                _value = value;
                                                filtereddocs!
                                                    // quotationController.quotionlist
                                                    .where((element) {
                                                  // Quotation data =
                                                  //     Quotation.fromJson(
                                                  //         element.data());
                                                  return element
                                                          .overallstatus ==
                                                      value;
                                                }).toList();
                                                print(filtereddocs);
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
                                            value: _approvalvalue,
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
                                              DropdownMenuItem(
                                                child: Text("All Quotations"),
                                                value: 'All Quotations',
                                              )
                                            ],
                                            onChanged: (String? value) {
                                              setState(() {
                                                _approvalvalue = value;
                                                filtereddocs!
                                                    .where((element) =>
                                                        element
                                                            .approvalStatus ==
                                                        'Pending')
                                                    .toList();
                                                print(filtereddocs);
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
                                  'Client',
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
                        ),
                      ],
                    )
                    // ]),
                    ),
              ),
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: countries
                    .doc(session.country!.code)
                    .collection('quotations')
                    .where('isTrash', isEqualTo: false)
                    .where('search', arrayContains: searchcon.text)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active &&
                      snapshot.hasData) {
                    filtereddocs = snapshot.data!.docs
                        .map((e) => Quotation.fromJson(e.data(), e.id))
                        .toList();
                    // filtereddocs!.value.isNotEmpty && filtereddocs != null
                    // quotationController.quotionlist.isNotEmpty
                    // ?
                    return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingTextStyle:
                                TextStyle(fontWeight: FontWeight.bold),
                            columns: [
                              "EDIT",
                              "INVOICE",
                              "QUOTE NO",
                              "DATE ISSUED",
                              "CLIENT",
                              "DESCRIPTION",
                              "QUOTE AMT",
                              "STATUS",
                              "CLIENT PO",
                              // "MARGIN %",
                              "MARGIN AMT",
                              "CCM TKT NO",
                              "COMPLETION DATE",
                              "DELETE"
                            ].map((e) => DataColumn(label: Text(e))).toList(),
                            rows:
                                // quotationController.quotionlist
                                filtereddocs!.map<DataRow>((data) {
                              // print(e.data());

                              return DataRow(
                                cells: [
                                  DataCell(
                                    IconButton(
                                        onPressed: () {
                                          Get.to(
                                            () => QuotationView(
                                              isEdit: true,
                                              data: data,
                                              id: data.id,
                                            ),
                                          );
                                        },
                                        icon: Icon(Icons.edit)),
                                  ),
                                  DataCell(
                                    IconButton(
                                      onPressed: () {
                                        listInvoice(data);
                                      },
                                      icon: Icon(
                                        Icons.notes_rounded,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(data.qnumber),
                                  ),
                                  DataCell(
                                    Text(
                                      data.dateIssued
                                          .toString()
                                          .substring(0, 10),
                                    ),
                                  ),
                                  DataCell(
                                    Text(data.clientname),
                                  ),
                                  DataCell(
                                    Text(data.description),
                                  ),
                                  DataCell(
                                    Text(data.qamount.toString()),
                                  ),
                                  DataCell(
                                    Text(data.approvalStatus),
                                  ),
                                  DataCell(
                                    Text(''),
                                  ),
                                  DataCell(
                                    Text(''),
                                  ),
                                  DataCell(
                                    Text(data.ccmTicketNumber),
                                  ),
                                  DataCell(
                                    Text(data.jobcompletionDate
                                        .toString()
                                        .substring(0, 10)),
                                  ),
                                  DataCell(
                                    IconButton(
                                      onPressed: () {
                                        CoolAlert.show(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width >
                                                  500
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.85,
                                          showCancelBtn: true,
                                          onCancelBtnTap: () =>
                                              Navigator.pop(context),
                                          onConfirmBtnTap: () {
                                            // setState(() {
                                            countries
                                                .doc(session.country!.code)
                                                .collection('quotations')
                                                .doc(data.id)
                                                .update(
                                              {"isTrash": true},
                                            );
                                            // });
                                            Navigator.pop(context);
                                          },
                                          context: context,
                                          type: CoolAlertType.confirm,
                                        );
                                      },
                                      icon: Icon(Icons.delete),
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ));
                    // ));
                  } else {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      // enabled: _enabled,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingTextStyle:
                                TextStyle(fontWeight: FontWeight.bold),
                            columns: [
                              "EDIT",
                              "INVOICE",
                              "QUOTE NO",
                              "DATE ISSUED",
                              "CLIENT",
                              "DESCRIPTION",
                              "QUOTE AMT",
                              "STATUS",
                              "CLIENT PO",
                              // "MARGIN %",
                              "MARGIN AMT",
                              "CCM TKT NO",
                              "COMPLETION DATE",
                              "DELETE"
                            ]
                                .map((e) => DataColumn(
                                        label: Text(
                                      e,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )))
                                .toList(),
                            rows: List.generate(
                              20,
                              (index) => DataRow(
                                cells: [
                                  DataCell(
                                    Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                  ),
                                  DataCell(
                                    Icon(
                                      Icons.notes_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        width: 100,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        width: 100,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        width: 100,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        width: 100,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        width: 100,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        width: 100,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        width: 100,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        width: 100,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        width: 100,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        width: 100,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Container(
                                        width: 100,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  listInvoice(Quotation quotation) {
    TabController controller = TabController(length: 2, vsync: this);

    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 70,
                  color: Colors.blue,
                  child: TabBar(
                    controller: controller,
                    tabs: [
                      Tab(text: "Client Invoice"),
                      Tab(text: "Contrator Invoice")
                    ],
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5.0,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingTextStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                columns: [
                                  "INVOICE NO",
                                  "INVOICE AMOUNT",
                                  "ISSUED DATE",
                                  "RECIEVED DATE",
                                  "RECIEVED AMOUNT",
                                  "CREDIT NOTE AMOUNT",
                                  "CREDIT NOTE NO",
                                  "CREDIT RECIEVED DATE",
                                ]
                                    .map((e) => DataColumn(
                                            label: Text(
                                          e,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        )))
                                    .toList(),
                                rows: quotation.clientInvoices
                                    .map((e) => DataRow(cells: [
                                          DataCell(
                                            Text(e.number),
                                          ),
                                          DataCell(
                                            Text(e.amount.toString()),
                                          ),
                                          DataCell(
                                            Text(
                                              e.issueDate.toString().substring(
                                                    0,
                                                    10,
                                                  ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              e.receivedDate
                                                  .toString()
                                                  .substring(
                                                    0,
                                                    10,
                                                  ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              e.recievedamount.toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(''),
                                          ),
                                          DataCell(
                                            Text(''),
                                          ),
                                          DataCell(
                                            Text(''),
                                          ),
                                        ]))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 5.0,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: DataTable(
                                headingTextStyle:
                                    TextStyle(fontWeight: FontWeight.bold),
                                columns: [
                                  "INVOICE NO",
                                  "INVOICE AMOUNT",
                                  "INVOICE RECIEVED DATE",
                                  "TAX NO",
                                  "PAID DATE",
                                  "PAID AMOUNT",
                                  "CREDIT NOTE AMOUNT",
                                  "CREDIT NOTE NO",
                                  "CREDIT RECIEVED DATE",
                                ]
                                    .map((e) => DataColumn(
                                            label: Text(
                                          e,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        )))
                                    .toList(),
                                rows: quotation
                                    .contractorPurchaseOrders.first.invoices
                                    .map((e) => DataRow(cells: [
                                          DataCell(
                                            Text(e.number),
                                          ),
                                          DataCell(
                                            Text(e.amount.toString()),
                                          ),
                                          DataCell(
                                            Text(
                                              e.receivedDate
                                                  .toString()
                                                  .substring(
                                                    0,
                                                    10,
                                                  ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(e.taxNumber!),
                                          ),
                                          DataCell(
                                            Text(
                                              e.paidDate.toString().substring(
                                                    0,
                                                    10,
                                                  ),
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              e.paidamount.toString(),
                                            ),
                                          ),
                                          DataCell(
                                            Text(''),
                                          ),
                                          DataCell(
                                            Text(''),
                                          ),
                                          DataCell(
                                            Text(''),
                                          ),
                                        ]))
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                    controller: controller,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Back'),
                ),
              ],
            ),
          ));
        });
  }
}
