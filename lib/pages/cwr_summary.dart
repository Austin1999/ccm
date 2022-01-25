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
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(session.country!.name.toUpperCase(), style: Theme.of(context).textTheme.headline6),
                  ),
                ),
                Padding(
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
                          size: 16,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: AspectRatio(
                        aspectRatio: 1,
                        child: Icon(
                          Icons.download,
                          size: 16,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: AspectRatio(
                        aspectRatio: 1,
                        child: Icon(
                          Icons.delete,
                          size: 16,
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {},
                    child: AspectRatio(
                        aspectRatio: 1,
                        child: Icon(
                          Icons.refresh,
                          size: 16,
                        )),
                  ),
                ),
              ],
            ),
          ),
          Card(
            color: Color(0xFFE8F3FA),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(children: [
                TableRow(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: CustomTextFormField(),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: CustomTextFormField(),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: CustomTextFormField(),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: CustomTextFormField(),
                    )),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: CustomTextFormField(),
                    )),
                  ],
                )
              ]),
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
