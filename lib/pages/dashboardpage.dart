import 'package:ccm/controllers/dashboard.dart';
import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/widgets/dashboard/pieboard.dart';
import 'package:ccm/widgets/dashboard/top5.dart';
import 'package:ccm/widgets/quotation/quote_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/currency_controller.dart';
import '../widgets/dashboard/agedAccounatables.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    country = session.country?.code;
    currency = session.country?.currencyCode ?? 'SGD';

    // dashboard.loadData();
  }

  late String currency;
  late String? country;
  String? client;

  @override
  Widget build(BuildContext context) {
    // var map = dashboard.getStatement('IN');
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                        });
                      },
                      items: countryController.countrylist
                          .map((element) => DropdownMenuItem(
                                child: Text(element.name),
                                value: element.code,
                              ))
                          .toList(),
                    ),
                    QuoteDropdown<String>(
                      title: 'Client',
                      value: client,
                      onChanged: (val) {
                        setState(() {
                          client = val ?? client;
                        });
                      },
                      items: clientController.overAllClientList
                          .map((element) => DropdownMenuItem(
                                child: Text(element.name),
                                value: element.docid,
                              ))
                          .toList(),
                    ),
                  ])
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
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
                Builder(builder: (context) {
                  Get.put(DashboardController(), tag: 'top5');
                  DashboardController controller = Get.find(tag: 'top5');
                  return GetBuilder(
                      init: controller,
                      builder: (context) {
                        controller.loadEntityWiseData();
                        return ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: 300),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Top5Entity(
                                  country: country,
                                  currency: currency,
                                  data: controller.topReceivables,
                                  isClient: true,
                                )),
                                Expanded(
                                    child: Top5Entity(
                                  country: country,
                                  currency: currency,
                                  data: controller.topPayables,
                                  isClient: false,
                                )),
                              ],
                            ),
                          ),
                        );
                      });
                })
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
