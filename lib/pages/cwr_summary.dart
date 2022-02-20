import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/pages/quotation_view.dart';
import 'package:ccm/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CwrSummary extends StatefulWidget {
  CwrSummary({Key? key}) : super(key: key);

  @override
  _CwrSummaryState createState() => _CwrSummaryState();
}

class _CwrSummaryState extends State<CwrSummary> {
  String? _value;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF3A5F85)),
      backgroundColor: Color(0xFFFAFAFA),
      body: Column(
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
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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
                            Get.to(() => QuotationView());
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
                          onPressed: () {},
                          child: AspectRatio(
                              aspectRatio: 1,
                              child: Icon(
                                Icons.delete,
                                size: 20,
                              )),
                        ),
                      ),
                    ),
                    Tooltip(
                      message: "Refresh",
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          child: AspectRatio(
                              aspectRatio: 1,
                              child: Icon(
                                Icons.refresh,
                                size: 20,
                              )),
                        ),
                      ),
                    ),
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
                child: Table(children: [
                  TableRow(
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
                                          value: _value,
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
                                              _value = value;
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
                  )
                ]),
              ),
            ),
          ),
          SingleChildScrollView(
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
                  "MARGIN %",
                  "MARGIN AMT",
                  "CCM TKT NO",
                  "COMPLETION DATE",
                  "DELETE"
                ].map((e) => DataColumn(label: Text(e))).toList(),
                rows: []),
          ),
        ],
      ),
    );
  }
}
