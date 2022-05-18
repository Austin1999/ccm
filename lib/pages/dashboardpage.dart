import 'dart:typed_data';

import 'package:ccm/controllers/dashboard.dart';
import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/widgets/dashboard/pieboard.dart';
import 'package:ccm/widgets/dashboard/top5.dart';
import 'package:ccm/widgets/quotation/quote_drop_down.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:universal_html/html.dart';

import '../controllers/currency_controller.dart';
import '../models/dashboard/AccountChart.dart';
import '../widgets/dashboard/agedAccounatables.dart';
import '../widgets/dashboard/monthly_statement.dart';
import 'dart:ui' as ui;

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    country = 'IN';
    currency = session.country?.currencyCode ?? 'SGD';

    // dashboard.loadData();
  }

  late String currency;
  late String? country;
  String? client;

  final GlobalKey _globalKey = new GlobalKey();

  final _screenshotController = ScreenshotController();
  List<int> bytes = [];

  takeScreenshot() {
    if (kIsWeb) {
      AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64, ${base64.encode(bytes)}')
        ..setAttribute('download', 'output.png')
        ..click();
    }
  }

  @override
  Widget build(BuildContext context) {
    // var map = dashboard.getStatement('IN');
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bytes = (await _screenshotController.capture())!.toList();
            takeScreenshot();
          },
          child: Icon(Icons.print),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: {},
                    children: [
                      TableRow(children: [
                        Align(
                          alignment: Alignment.center,
                          child: Text('DASHBOARD', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25)),
                        ),
                        Container(),
                        QuoteDropdown<String>(
                          title: 'Currency',
                          items: currencyController.items,
                          value: currency,
                          onChanged: (val) {
                            setState(() {
                              currency = val ?? currency;
                            });
                          },
                        ),
                        QuoteDropdown<String>(
                          title: 'Country',
                          value: country,
                          onChanged: (val) {
                            setState(() {
                              country = val ?? country;
                              client = null;
                            });
                          },
                          items: getCountryList(),
                        ),
                        QuoteDropdown<String>(
                          title: 'Client',
                          value: client,
                          onChanged: (val) {
                            setState(() {
                              client = val ?? client;
                            });
                          },
                          items: getClients(),
                        ),
                      ])
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Screenshot(
                  controller: _screenshotController,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: PieBoard(
                            currency: currency,
                            country: country,
                            client: client,
                          ),
                        ),
                      ),
                      AgedAccounts(
                        currency: currency,
                        country: country,
                        client: client,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Builder(builder: (context) {
                          DashboardController controller = Get.put((DashboardController()), tag: 'top5');

                          return FutureBuilder<Map<String, List<AccountChartData>>>(
                              future: controller.loadEntityWiseData(country: country),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) {
                                  var map = snapshot.data;
                                  return Top5Entity(
                                    currency: currency,
                                    country: country,
                                    top5clients: map!["top5clients"] ?? [],
                                    top5contractors: map["top5contractors"] ?? [],
                                  );
                                }

                                if (snapshot.hasError) {
                                  return Text("Could not load data");
                                }
                                return Top5Entity(
                                  currency: currency,
                                  country: country,
                                  top5clients: [],
                                  top5contractors: [],
                                );
                              });
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        child: MonthlyStatement(
                          currency: currency,
                          country: country,
                          client: client,
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  List<DropdownMenuItem<String>> getClients() {
    var list = clientController
        .filteredClients(country)
        .map((element) => DropdownMenuItem(
              child: Text(element.name),
              value: element.docid,
            ))
        .toList();
    list.add(DropdownMenuItem(
      child: Text('All Clients'),
      value: null,
    ));
    return list;
  }

  List<DropdownMenuItem<String>> getCountryList() {
    var list = countryController.countrylist
        .map((element) => DropdownMenuItem(
              child: Text(element.name),
              value: element.code,
            ))
        .toList();
    list.add(DropdownMenuItem(
      child: Text('All Country'),
      value: null,
    ));
    return list;
  }
}
