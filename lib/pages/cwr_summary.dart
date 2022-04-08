import 'dart:convert';
import 'dart:html';
import 'package:ccm/controllers/getControllers.dart';
import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/quotation.dart';
import 'package:ccm/pages/quotation_view.dart';
import 'package:ccm/services/firebase.dart';
import 'package:ccm/widgets/widget.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:excel/excel.dart';
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
  String _statusvalue = 'Pending';
  String? _approvalvalue = 'Approved';
  TextEditingController clientQuoteclientName = TextEditingController();
  TextEditingController searchcon = TextEditingController();
  TextEditingController fromdate = TextEditingController();
  TextEditingController todate = TextEditingController();
  DateTime? fromdateval = DateTime(2000);
  DateTime? todateval = DateTime.now();
  // List<Quotation>? filtereddocs;
  // List<Quotation>? tempdocs;

  List<Quotation> filter(List<Quotation> quotation) {
    // if (_statusvalue == null &&
    //     _approvalvalue == null &&
    //     clientQuoteclientName.text.isEmpty) {
    //   return quotation;
    // } else {
    return quotation
        .where(
          (value) =>
              (value.overallstatus == _statusvalue) &&
              (value.approvalStatus == _approvalvalue) &&
              (value.jobcompletionDate.isAfter(
                fromdateval!.subtract(
                  Duration(
                    days: 1,
                  ),
                ),
              )) &&
              (value.jobcompletionDate.isBefore(
                todateval!.add(
                  Duration(days: 1),
                ),
              )),
        )
        .toList();
    // }
  }

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
      // filtereddocs = quotationController.quotionlist;
      // tempdocs = filtereddocs;
      // print(filtereddocs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF3A5F85)),
      backgroundColor: Color(0xFFFAFAFA),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: countries
            .doc(session.country!.code)
            .collection('quotations')
            .where('isTrash', isEqualTo: false)
            .where('search', arrayContains: searchcon.text)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active &&
              snapshot.hasData) {
            var docs = snapshot.data!.docs
                .map((e) => Quotation.fromJson(e.data(), e.id))
                .toList();
            // print(docs);
            List<Quotation> filtereddocs = filter(docs);
            // print(filtereddocs);

            return SingleChildScrollView(
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
                                  onPressed: () {
                                    var excel = Excel.createExcel();
                                    Sheet sheetObject = excel['CWR-Summary'];
                                    List<String> dataList = [
                                      "Quote Number",
                                      "Date Issued",
                                      "Client",
                                      "Description",
                                      "Quote Amount",
                                      "Approval Status",
                                      "CCM Ticket Number",
                                      "Completion Date"
                                    ];
                                    sheetObject.insertRowIterables(dataList, 0);
                                    for (int i = 0;
                                        i < filtereddocs.length;
                                        i++) {
                                      sheetObject.appendRow(
                                        [
                                          filtereddocs[i].qnumber.toString(),
                                          filtereddocs[i]
                                              .dateIssued
                                              .toIso8601String()
                                              .substring(0, 10),
                                          filtereddocs[i].clientname,
                                          filtereddocs[i].description,
                                          filtereddocs[i].qamount,
                                          filtereddocs[i].approvalStatus,
                                          filtereddocs[i].ccmTicketNumber,
                                          filtereddocs[i]
                                              .jobcompletionDate
                                              .toIso8601String()
                                              .substring(0, 10)
                                        ],
                                      );
                                    }
                                    // RowStyle rowStyle = RowStyle()
                                    // for (int i = 1;
                                    //     i == filtereddocs.length;
                                    //     i++) {
                                    //   var cell1 = sheetObject.cell(
                                    //       CellIndex.indexByString('A${i + 1}'));
                                    //   var cell2 = sheetObject.cell(
                                    //       CellIndex.indexByString('B${i + 1}'));
                                    //   var cell3 = sheetObject.cell(
                                    //       CellIndex.indexByString('C${i + 1}'));
                                    //   var cell4 = sheetObject.cell(
                                    //       CellIndex.indexByString('D${i + 1}'));
                                    //   var cell5 = sheetObject.cell(
                                    //       CellIndex.indexByString('E${i + 1}'));
                                    //   var cell6 = sheetObject.cell(
                                    //       CellIndex.indexByString('F${i + 1}'));
                                    //   var cell7 = sheetObject.cell(
                                    //       CellIndex.indexByString('G${i + 1}'));
                                    //   var cell8 = sheetObject.cell(
                                    //       CellIndex.indexByString('H${i + 1}'));
                                    //   cell1.value =
                                    //       int.parse(filtereddocs[i].qnumber);
                                    //   cell2.value = filtereddocs[i]
                                    //       .dateIssued
                                    //       .toIso8601String()
                                    //       .substring(0, 10);
                                    //   cell3.value = filtereddocs[i].clientname;
                                    //   cell4.value = filtereddocs[i].description;
                                    //   cell5.value =
                                    //       filtereddocs[i].qamount.toString();
                                    //   cell6.value =
                                    //       filtereddocs[i].approvalStatus;
                                    // cell7.value = filtereddocs[i]
                                    //     .ccmTicketNumber
                                    //       .toString();
                                    // cell8.value = filtereddocs[i]
                                    //     .jobcompletionDate
                                    //     .toIso8601String()
                                    //     .substring(0, 10);
                                    // }
                                    excel.setDefaultSheet('CWR-Summary');
                                    // File file = File(excel.encode()!, 'CWR');
                                    var fileBytes = excel.save(
                                        fileName: "CWR-Summary.xlsx");
                                  },
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
                                                            Map<String,
                                                                dynamic>>>(
                                                    stream: countries
                                                        .doc(session
                                                            .country!.code)
                                                        .collection(
                                                            'quotations')
                                                        .where('isTrash',
                                                            isEqualTo: true)
                                                        .snapshots(),
                                                    builder:
                                                        (context, snapshot) {
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
                                                                width: double
                                                                    .infinity,
                                                                color:
                                                                    Colors.blue,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child: Text(
                                                                    'Recycle Bin',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800,
                                                                      fontSize:
                                                                          25,
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
                                                                            FontWeight.bold),
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
                                                                            label:
                                                                                Text(e)))
                                                                    .toList(),
                                                                rows: snapshot
                                                                    .data!.docs
                                                                    .map<
                                                                        DataRow>(
                                                                  (e) {
                                                                    print(e
                                                                        .data());
                                                                    Quotation
                                                                        data =
                                                                        Quotation.fromJson(
                                                                            e.data(),
                                                                            e.id);
                                                                    return DataRow(
                                                                      cells: [
                                                                        DataCell(
                                                                          IconButton(
                                                                            onPressed:
                                                                                () {},
                                                                            icon:
                                                                                Icon(Icons.notes_rounded),
                                                                          ),
                                                                        ),
                                                                        DataCell(
                                                                          Text(data
                                                                              .qnumber),
                                                                        ),
                                                                        DataCell(
                                                                          Text(
                                                                            data.dateIssued.toString().substring(0,
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
                                                                          Text(
                                                                              ''),
                                                                        ),
                                                                        DataCell(
                                                                          Text(
                                                                              ''),
                                                                        ),
                                                                        DataCell(
                                                                          Text(data
                                                                              .ccmTicketNumber),
                                                                        ),
                                                                        DataCell(
                                                                          Text(data
                                                                              .jobcompletionDate
                                                                              .toString()
                                                                              .substring(0, 10)),
                                                                        ),
                                                                        DataCell(
                                                                          IconButton(
                                                                            icon:
                                                                                Icon(Icons.restore),
                                                                            onPressed:
                                                                                () {
                                                                              countries.doc(session.country!.code).collection('quotations').doc(e.id).update(
                                                                                {
                                                                                  "isTrash": false
                                                                                },
                                                                              );
                                                                            },
                                                                          ),
                                                                        ),
                                                                        DataCell(
                                                                          IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              CoolAlert.show(
                                                                                width: MediaQuery.of(context).size.width > 500 ? MediaQuery.of(context).size.width / 2 : MediaQuery.of(context).size.width * 0.85,
                                                                                showCancelBtn: true,
                                                                                onCancelBtnTap: () => Navigator.pop(context),
                                                                                onConfirmBtnTap: () {
                                                                                  // setState(() {
                                                                                  countries.doc(session.country!.code).collection('quotations').doc(e.id).delete();
                                                                                  // });
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                context: context,
                                                                                type: CoolAlertType.confirm,
                                                                              );
                                                                            },
                                                                            icon:
                                                                                Icon(Icons.delete),
                                                                            color:
                                                                                Colors.red,
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
                                                                            .all(
                                                                        8.0),
                                                                child:
                                                                    ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
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
                                                        return Shimmer
                                                            .fromColors(
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
                                                                            FontWeight.bold),
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
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        )))
                                                                    .toList(),
                                                                rows: List
                                                                    .generate(
                                                                  20,
                                                                  (index) =>
                                                                      DataRow(
                                                                    cells: [
                                                                      DataCell(
                                                                        Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        Icon(
                                                                          Icons
                                                                              .notes_rounded,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                100,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                100,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                100,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                100,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                100,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                100,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                100,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                100,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                100,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                100,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      DataCell(
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(4.0),
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                100,
                                                                            color:
                                                                                Colors.white,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          onTap: () async {
                                            fromdateval = await _selectDate(
                                                context, DateTime.now());
                                            setState(() {
                                              fromdate.text = fromdateval
                                                  .toString()
                                                  .substring(0, 10);
                                            });
                                          },
                                          readOnly: true,
                                          controller: fromdate,
                                          decoration: InputDecoration(
                                            suffixIcon:
                                                Icon(Icons.calendar_today),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          onTap: () async {
                                            todateval = await _selectDate(
                                                context, DateTime.now());
                                            setState(() {
                                              todate.text = todateval
                                                  .toString()
                                                  .substring(0, 10);
                                            });
                                          },
                                          readOnly: true,
                                          controller: todate,
                                          decoration: InputDecoration(
                                            suffixIcon:
                                                Icon(Icons.calendar_today),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: DropdownButton(
                                                  value: _statusvalue,
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
                                                      child: Text(
                                                          "All Quotations"),
                                                      value: 'All Quotations',
                                                    )
                                                  ],
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      _statusvalue = value!;
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                      child: Text(
                                                          "All Quotations"),
                                                      value: 'All Quotations',
                                                    )
                                                  ],
                                                  onChanged: (String? value) {
                                                    setState(() {
                                                      _approvalvalue = value;
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
                              // Expanded(
                              //   child: Padding(
                              //     padding: const EdgeInsets.symmetric(
                              //         horizontal: 16.0, vertical: 8.0),
                              //     child: Column(
                              //       crossAxisAlignment: CrossAxisAlignment.start,
                              //       children: [
                              //         Text(
                              //           'Client',
                              //           style: TextStyle(
                              //             fontWeight: FontWeight.bold,
                              //             fontSize: 17,
                              //           ),
                              //         ),
                              //         SizedBox(
                              //           height: 10,
                              //         ),
                              //         SizedBox(
                              //           width: double.infinity,
                              //           child: Card(
                              //             color: Colors.white,
                              //             elevation: 5,
                              //             shadowColor: Colors.grey,
                              //             child: DropdownButtonHideUnderline(
                              //               child: Padding(
                              //                 padding: const EdgeInsets.symmetric(
                              //                     horizontal: 8.0),
                              //                 child: DropdownButton<String>(
                              //                     value: clientQuoteclientName.text,
                              //                     items: clientController
                              //                             .clientlist.isEmpty
                              //                         ? [
                              //                             DropdownMenuItem(
                              //                               value: "N/A",
                              //                               child: Text(
                              //                                 "N/A",
                              //                               ),
                              //                             )
                              //                           ]
                              //                         : clientController.clientlist
                              //                             .toSet()
                              //                             .map((e) =>
                              //                                 DropdownMenuItem(
                              //                                   child: Text(e.name),
                              //                                   value: e.name,
                              //                                 ))
                              //                             .toList(),
                              //                     onChanged: (String? value) {
                              //                       setState(() {
                              //                         clientQuoteclientName.text =
                              //                             value!;
                              //                       });
                              //                     },
                              //                     hint: Text("Client Name")),
                              //               ),
                              //             ),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                            ],
                          )
                          // ]),
                          ),
                    ),
                  ),
                  SingleChildScrollView(
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
                            filtereddocs.map<DataRow>((data) {
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
                                  data.dateIssued.toString().substring(0, 10),
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
                                      width: MediaQuery.of(context).size.width >
                                              500
                                          ? MediaQuery.of(context).size.width /
                                              2
                                          : MediaQuery.of(context).size.width *
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
                    ),
                  ),
                ],
              ),
            );
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
                    headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
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
        },
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
