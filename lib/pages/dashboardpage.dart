import 'dart:convert';

import 'package:ccm/controllers/dashboard.dart';
import 'package:ccm/models/client.dart';
import 'package:ccm/models/dashboard/AccountChart.dart';
import 'package:ccm/widgets/dashboard/monthly_statement.dart';
import 'package:ccm/widgets/dashboard/top5.dart';
import 'package:ccm/widgets/quotation/quote_drop_down.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:universal_html/html.dart';

import '../controllers/currency_controller.dart';
import '../controllers/sessionController.dart';
import '../widgets/dashboard/agedAccounatables.dart';
import '../widgets/dashboard/pieboard.dart';
import '../widgets/multiSelect.dart';

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
    selectedClients = clientController.filteredClients(country).toList();

    // dashboard.loadData();
  }

  late String currency;
  late String? country;
  String? client;

  List<Client> selectedClients = [];

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
                              selectedClients = [];
                            });
                          },
                          items: getCountryList(),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: ListTile(
                            title: Text("Clients"),
                            subtitle: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Card(
                                elevation: 8,
                                color: Colors.white,
                                child: MultiSelect<Client>(
                                    options: clientController.filteredClients(country).toList(),
                                    selectedValues: selectedClients,
                                    onChanged: (val) {
                                      setState(() {
                                        selectedClients = val;
                                      });
                                    },
                                    decoration: InputDecoration(border: OutlineInputBorder(), fillColor: Colors.white),
                                    whenEmpty: 'Select client'),
                              ),
                            ),
                          ),
                        )
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
                            client: selectedClients.map((e) => e.docid!).toList(),
                          ),
                        ),
                      ),
                      AgedAccounts(
                        currency: currency,
                        country: country,
                        client: selectedClients.map((e) => e.docid!).toList(),
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
                          client: selectedClients.map((e) => e.docid!).toList(),
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
    var list = session.sessionCountries
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
