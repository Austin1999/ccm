import 'package:ccm/controllers/currency_controller.dart';
import 'package:ccm/controllers/sessionController.dart';
import 'package:ccm/main.dart';
import 'package:ccm/models/dashboard/AccountChart.dart';
import 'package:ccm/models/dashboard_data.dart';
import 'package:ccm/services/firebase.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  double totalQuoteAmount = 0;
  double totalInvoiceAmount = 0;
  double receivables = 0;
  double totalReceivedAmount = 0;
  double clientCredits = 0;

  double totalContractorAmount = 0;
  double totalContractorInvoiceAmount = 0;
  double payables = 0;
  double totalPaidAmount = 0;
  double contractorCredits = 0;

  double totalMargin = 0;

  // double amount = 0;
  // double clientInvoiceAmount = 0;
  // double receivedAmount = 0;
  // double receivableAmount = 0;
  // double clientCredits = 0;
  // double contractorInvoiceAmount = 0;
  // double paidAmount = 0;
  // double payableAmount = 0;
  // double contractorCredits = 0;
  // double contractorAmount = 0;

  Map<String, double> payablesContractorWise = {};
  Map<String, double> receivablesClientWise = {};

  Map<String, double> agedReceivables = {
    '0+': 0,
    '30+': 0,
    '60+': 0,
    '90+': 0,
  };
  Map<String, double> agedPayables = {
    '0+': 0,
    '30+': 0,
    '60+': 0,
    '90+': 0,
  };

  clear() {
    receivables = 0;
    payables = 0;
    clientCredits = 0;
    contractorCredits = 0;
    totalInvoiceAmount = 0;
    totalQuoteAmount = 0;
    totalContractorAmount = 0;
    totalMargin = 0;
    totalReceivedAmount = 0;
    totalPaidAmount = 0;
    totalReceivedAmount = 0;
    totalPaidAmount = 0;
    totalContractorInvoiceAmount = 0;
    payablesContractorWise = {};
    receivablesClientWise = {};

    agedReceivables = {
      '0+': 0,
      '30+': 0,
      '60+': 0,
      '90+': 0,
    };
    agedPayables = {
      '0+': 0,
      '30+': 0,
      '60+': 0,
      '90+': 0,
    };
  }

  loadReceivables({DateTime? fromDate, DateTime? toDate, String? country, List<String>? clients}) {
    Query<Map<String, dynamic>> query = receivablesRef;
    if (fromDate != null) {
      query = query.where("quoteDate", isGreaterThanOrEqualTo: fromDate);
    }
    if (toDate != null) {
      query = query.where("quoteDate", isLessThanOrEqualTo: toDate);
    }
    if (country != null) {
      query = query.where("country", isEqualTo: country);
    }
    if (clients != null) {
      query.get().then((value) {
        clear();
        value.docs.forEach((element) {
          if (clients.contains(element["client"])) {
            var receivable = ListElement.fromJson(element.data());
            receivables += receivable.amount.convert(receivable.currency, 'INR');
            clientCredits += receivable.credits.convert(receivable.currency, 'INR');
            totalReceivedAmount += receivable.closedAmount.convert(receivable.currency, 'INR');
            totalInvoiceAmount += receivable.actualAmount.convert(receivable.currency, 'INR');
          }
        });
        update();
      });
    } else {
      query.get().then((value) {
        clear();
        value.docs.forEach((element) {
          var receivable = ListElement.fromJson(element.data());
          receivables += receivable.amount.convert(receivable.currency, 'INR');
          clientCredits += receivable.credits.convert(receivable.currency, 'INR');
          totalReceivedAmount += receivable.closedAmount.convert(receivable.currency, 'INR');
          totalInvoiceAmount += receivable.actualAmount.convert(receivable.currency, 'INR');
        });
        update();
      });
    }
  }

  loadPayables({DateTime? fromDate, DateTime? toDate, String? country, List<String>? clients}) {
    Query<Map<String, dynamic>> query = payablesRef;

    if (fromDate != null) {
      query = query.where("quoteDate", isGreaterThanOrEqualTo: fromDate);
    }
    if (toDate != null) {
      query = query.where("quoteDate", isLessThanOrEqualTo: toDate);
    }
    if (country != null) {
      query = query.where("country", isEqualTo: country);
    }
    if (clients != null) {
      query.get().then((value) {
        clear();
        value.docs.forEach((element) {
          if (clients.contains(element["client"])) {
            var payable = ListElement.fromJson(element.data());
            try {
              payables += payable.amount.convert(payable.currency, 'INR');
              contractorCredits += payable.credits.convert(payable.currency, 'INR');
              totalPaidAmount += payable.closedAmount.convert(payable.currency, 'INR');
              totalContractorInvoiceAmount += payable.actualAmount.convert(payable.currency, 'INR');
            } catch (e) {
              printWarning(e.toString());
            }
          }
        });
        update();
      });
    } else {
      query.get().then((value) {
        clear();
        value.docs.forEach((element) {
          var payable = ListElement.fromJson(element.data());
          try {
            payables += payable.amount.convert(payable.currency, 'INR');
            contractorCredits += payable.credits.convert(payable.currency, 'INR');
            totalPaidAmount += payable.closedAmount.convert(payable.currency, 'INR');
            totalContractorInvoiceAmount += payable.actualAmount.convert(payable.currency, 'INR');
          } catch (e) {
            printWarning(e.toString());
          }
        });
        update();
      });
    }
  }

  List<AccountChartData> get topReceivables {
    var receivables = receivablesClientWise.keys.map((e) => AccountChartData(entity: e, amount: receivablesClientWise[e]!, currency: 'INR')).toList();

    return receivables;
  }

  List<AccountChartData> get topPayables {
    var payables = payablesContractorWise.keys.map((e) => AccountChartData(entity: e, amount: payablesContractorWise[e]!, currency: 'INR')).toList();
    return payables;
  }

  Future<Map<String, List<AccountChartData>>> loadEntityWiseData({String? country}) async {
    List<Future> futures = [];
    var clientList = clientController.filteredClients(country);
    var contractorlist = contractorController.contractorlist.toList();
    if (country != null) {
      clientList = clientList.where((element) => element.country == country).toList();
      contractorlist = contractorlist.where((element) => element.country == country).toList();
    }
    receivablesClientWise = {};
    clientList.forEach((element) {
      futures.add(receivablesRef.where("entity", isEqualTo: element.docid).get().then((value) {
        receivablesClientWise.remove(element.docid);
        value.docs.forEach((element) {
          var listElement = ListElement.fromJson(element.data());
          receivablesClientWise[listElement.entity] =
              (receivablesClientWise[listElement.entity] ?? 0) + listElement.amount.convert(listElement.currency, 'INR');
        });
        update();
      }));
    });
    payablesContractorWise = {};
    contractorlist.forEach((element) {
      futures.add(payablesRef.where("entity", isEqualTo: element.name).get().then((value) {
        payablesContractorWise.remove(element.name);
        value.docs.forEach((element) {
          var listElement = ListElement.fromJson(element.data());
          payablesContractorWise[listElement.entity] =
              (payablesContractorWise[listElement.entity] ?? 0) + listElement.amount.convert(listElement.currency, 'INR');
        });
        update();
      }));
    });

    return Future.wait(futures).then((value) {
      top5clients = getTop5receivables();
      top5contractors = getTop5Payables();
    }).then((value) => {
          "top5clients": top5clients,
          "top5contractors": top5contractors,
        });
  }

  loadAgedPayables({String? country, required List<String> clients}) {
    Query<Map<String, dynamic>> query = payablesRef;

    if (country != null) {
      query = query.where("country", isEqualTo: country);
    }
    // if (clients != null) {
    //   query = query.where("client", isEqualTo: clients);
    // }
    query.get().then((value) {
      agedPayables['0+'] = 0;
      agedPayables['30+'] = 0;
      agedPayables['60+'] = 0;
      agedPayables['90+'] = 0;

      // if (clients.isNotEmpty) {

      // } else {
      //   value.docs.forEach((element) {
      //     var payable = ListElement.fromJson(element.data());
      //     var days = payable.daysAged;
      //     if (days < 30) {
      //       agedPayables['0+'] = (agedPayables['0+'] ?? 0) + payable.amount;
      //     } else if (days < 60) {
      //       agedPayables['30+'] = (agedPayables['30+'] ?? 0) + payable.amount;
      //     } else if (days < 90) {
      //       agedPayables['60+'] = (agedPayables['60+'] ?? 0) + payable.amount;
      //     } else {
      //       agedPayables['90+'] = (agedPayables['90+'] ?? 0) + payable.amount;
      //     }
      //   });
      // }

      value.docs.forEach((element) {
        if (clients.contains(element["client"])) {
          var payable = ListElement.fromJson(element.data());
          var days = payable.daysAged;
          if (days < 30) {
            agedPayables['0+'] = (agedPayables['0+'] ?? 0) + payable.amount;
          } else if (days < 60) {
            agedPayables['30+'] = (agedPayables['30+'] ?? 0) + payable.amount;
          } else if (days < 90) {
            agedPayables['60+'] = (agedPayables['60+'] ?? 0) + payable.amount;
          } else {
            agedPayables['90+'] = (agedPayables['90+'] ?? 0) + payable.amount;
          }
        }
      });

      update();
    });
  }

  loadAgedReceivables({String? country, required List<String> clients}) {
    Query<Map<String, dynamic>> query = receivablesRef;

    if (country != null) {
      query = query.where("country", isEqualTo: country);
    }
    // if (clients != null) {
    //   query = query.where("client", isEqualTo: clients);
    // }
    query.get().then((value) {
      agedReceivables['0+'] = 0;
      agedReceivables['30+'] = 0;
      agedReceivables['60+'] = 0;
      agedReceivables['90+'] = 0;
      value.docs.forEach((element) {
        if (clients.contains(element["client"])) {
          var receivable = ListElement.fromJson(element.data());
          var days = receivable.daysAged;
          if (days < 30) {
            agedReceivables['0+'] = (agedReceivables['0+'] ?? 0) + receivable.amount;
          } else if (days < 60) {
            agedReceivables['30+'] = (agedReceivables['30+'] ?? 0) + receivable.amount;
          } else if (days < 90) {
            agedReceivables['60+'] = (agedReceivables['60+'] ?? 0) + receivable.amount;
          } else {
            agedReceivables['90+'] = (agedReceivables['90+'] ?? 0) + receivable.amount;
          }
        }
      });
      update();
    });
  }

  List<AccountChartData> top5clients = [];
  List<AccountChartData> top5contractors = [];

  List<AccountChartData> getTop5receivables() {
    List<AccountChartData> clients = [];
    receivablesClientWise.forEach((key, value) {
      clients.add(AccountChartData(
        amount: value,
        entity: clientController.getName(key),
      ));
    });
    clients.sort(((b, a) => a.amount.compareTo(b.amount)));
    if (clients.length < 5) {
      return clients;
    } else {
      List<AccountChartData> returns = [];
      for (int i = 0; i < 5; i++) {
        returns.add(clients[i]);
      }
      return returns;
    }
  }

  List<AccountChartData> getTop5Payables() {
    List<AccountChartData> contractors = [];
    payablesContractorWise.forEach((key, value) {
      contractors.add(AccountChartData(
        amount: value,
        entity: key,
      ));
    });
    contractors.sort(((b, a) => a.amount.compareTo(b.amount)));
    if (contractors.length < 5) {
      return contractors;
    } else {
      List<AccountChartData> returns = [];
      for (int i = 0; i < 5; i++) {
        returns.add(contractors[i]);
      }
      return returns;
    }
  }

  loadQuoteData({DateTime? fromDate, DateTime? toDate, String? country, List<String>? clients}) {
    Query<Map<String, dynamic>> query = dashboardDataRef;
    if (fromDate != null) {
      query = query.where("issuedDate", isGreaterThanOrEqualTo: fromDate);
    }
    if (toDate != null) {
      query = query.where("issuedDate", isLessThanOrEqualTo: toDate);
    }
    if (country != null) {
      query = query.where("country", isEqualTo: country);
    }
    if (clients == null) {
      query.get().then((value) {
        clear();
        value.docs.map((e) => DashboardData.fromJson(e.data())).forEach((element) {
          totalMargin += element.margin.convert(element.currencyCode, 'INR');
          totalContractorAmount += element.contractorAmount.convert(element.currencyCode, 'INR');
          totalQuoteAmount += element.amount.convert(element.currencyCode, 'INR');

          totalInvoiceAmount += element.clientInvoiceAmount.convert(element.currencyCode, 'INR');
          totalReceivedAmount += element.receivedAmount.convert(element.currencyCode, 'INR');
          receivables += element.receivableAmount.convert(element.currencyCode, 'INR');
          clientCredits += element.clientCredits.convert(element.currencyCode, 'INR');

          totalContractorInvoiceAmount += element.contractorInvoiceAmount.convert(element.currencyCode, 'INR');
          totalPaidAmount += element.paidAmount.convert(element.currencyCode, 'INR');
          payables += element.payableAmount.convert(element.currencyCode, 'INR');
          contractorCredits += element.contractorCredits.convert(element.currencyCode, 'INR');
        });
        update();
      });
    } else {
      query.get().then((value) {
        clear();
        value.docs.map((e) => DashboardData.fromJson(e.data())).forEach((element) {
          if (clients.contains(element.client)) {
            totalMargin += element.margin.convert(element.currencyCode, 'INR');
            totalContractorAmount += element.contractorAmount.convert(element.currencyCode, 'INR');
            totalQuoteAmount += element.amount.convert(element.currencyCode, 'INR');
            totalInvoiceAmount += element.clientInvoiceAmount.convert(element.currencyCode, 'INR');
            totalReceivedAmount += element.receivedAmount.convert(element.currencyCode, 'INR');
            receivables += element.receivableAmount.convert(element.currencyCode, 'INR');
            clientCredits += element.clientCredits.convert(element.currencyCode, 'INR');
            totalContractorInvoiceAmount += element.contractorInvoiceAmount.convert(element.currencyCode, 'INR');
            totalPaidAmount += element.paidAmount.convert(element.currencyCode, 'INR');
            payables += element.payableAmount.convert(element.currencyCode, 'INR');
            contractorCredits += element.contractorCredits.convert(element.currencyCode, 'INR');
          }
        });
        update();
      });
    }
  }
}
