import 'package:ccm/controllers/currency_controller.dart';
import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/main.dart';
import 'package:ccm/models/countries.dart';
import 'package:ccm/models/dashboard/AccountChart.dart';
import 'package:ccm/models/dashboard_data.dart';
import 'package:ccm/services/firebase.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    print("Initializing.....");
  }

  double receivables = 0;
  double payables = 0;
  double clientCredits = 0;
  double contractorCredits = 0;
  double totalInvoiceAmount = 0;
  double totalContractorInvoiceAmount = 0;
  double totalQuoteAmount = 0;
  double totalContractorAmount = 0;
  double totalMargin = 0;
  double totalReceivedAmount = 0;
  double totalPaidAmount = 0;

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

  loadReceivables({DateTime? fromDate, DateTime? toDate, String? country, String? client}) {
    clear();
    Query<Map<String, dynamic>> query = receivablesRef;
    // if (fromDate != null) {
    //   query = query.where("date", isGreaterThanOrEqualTo: fromDate.millisecondsSinceEpoch);
    // }
    // if (toDate != null) {
    //   query = query.where("date", isLessThanOrEqualTo: toDate.millisecondsSinceEpoch);
    // }
    if (fromDate != null) {
      query = query.where("quoteDate", isGreaterThanOrEqualTo: fromDate);
    }
    if (toDate != null) {
      query = query.where("quoteDate", isLessThanOrEqualTo: toDate);
    }
    if (country != null) {
      query = query.where("country", isEqualTo: country);
    }
    if (client != null) {
      query = query.where("entity", isEqualTo: client);
    }
    query.get().then((value) {
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

  loadPayables({DateTime? fromDate, DateTime? toDate, String? country, String? client}) {
    clear();
    Query<Map<String, dynamic>> query = payablesRef;
    // if (fromDate != null) {
    //   query = query.where("date", isGreaterThanOrEqualTo: fromDate);
    // }
    // if (toDate != null) {
    //   query = query.where("date", isLessThanOrEqualTo: toDate);
    // }
    if (fromDate != null) {
      query = query.where("quoteDate", isGreaterThanOrEqualTo: fromDate);
    }
    if (toDate != null) {
      query = query.where("quoteDate", isLessThanOrEqualTo: toDate);
    }
    if (country != null) {
      query = query.where("country", isEqualTo: country);
    }
    if (client != null) {
      query = query.where("client", isEqualTo: client);
    }
    query.get().then((value) {
      value.docs.forEach((element) {
        var payable = ListElement.fromJson(element.data());
        try {
          payables += payable.amount.convert(payable.currency, 'INR');
          contractorCredits += payable.credits.convert(payable.currency, 'INR');
          totalPaidAmount += payable.closedAmount.convert(payable.currency, 'INR');
          totalContractorInvoiceAmount += payable.actualAmount.convert(payable.currency, 'INR');
        } catch (e) {
          // payables += 0;
        }
      });
      update();
    });
  }

  List<AccountChartData> get topReceivables {
    return receivablesClientWise.keys.map((e) => AccountChartData(entity: e, amount: receivablesClientWise[e]!, currency: 'INR')).toList();
  }

  List<AccountChartData> get topPayables {
    return payablesContractorWise.keys.map((e) => AccountChartData(entity: e, amount: receivablesClientWise[e]!, currency: 'INR')).toList();
  }

  loadEntityWiseData() {
    receivablesClientWise = {};
    clientController.overAllClientList.forEach((element) {
      receivablesRef.where("entity", isEqualTo: element.docid).get().then((value) {
        value.docs.forEach((element) {
          var listElement = ListElement.fromJson(element.data());
          receivablesClientWise[listElement.entity] =
              (receivablesClientWise[listElement.entity] ?? 0) + listElement.amount.convert(listElement.currency, 'INR');
        });
        update();
      });
    });
    payablesContractorWise = {};
    contractorController.contractorlist.forEach((element) {
      payablesRef.where("entity", isEqualTo: element.docid).get().then((value) {
        value.docs.forEach((element) {
          var listElement = ListElement.fromJson(element.data());
          payablesContractorWise[listElement.entity] =
              (payablesContractorWise[listElement.entity] ?? 0) + listElement.amount.convert(listElement.currency, 'INR');
        });
        update();
      });
    });
  }

  loadAgedPayables({String? country, String? client}) {
    Query<Map<String, dynamic>> query = payablesRef;

    if (country != null) {
      query = query.where("country", isEqualTo: country);
    }
    query.get().then((value) {
      value.docs.forEach((element) {
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
      });
      update();
    });
  }

  loadAgedReceivables({String? country, String? client}) {
    Query<Map<String, dynamic>> query = receivablesRef;

    if (country != null) {
      query = query.where("country", isEqualTo: country);
    }
    query.get().then((value) {
      value.docs.forEach((element) {
        var receivable = ListElement.fromJson(element.data());
        var days = receivable.daysAged;
        print(days);
        if (days < 30) {
          agedReceivables['0+'] = (agedReceivables['0+'] ?? 0) + receivable.amount;
        } else if (days < 60) {
          agedReceivables['30+'] = (agedReceivables['30+'] ?? 0) + receivable.amount;
        } else if (days < 90) {
          agedReceivables['60+'] = (agedReceivables['60+'] ?? 0) + receivable.amount;
        } else {
          agedReceivables['90+'] = (agedReceivables['90+'] ?? 0) + receivable.amount;
        }
      });
      update();
    });
  }

  getTop5receivables() {
    List<AccountChartData> clients = [];

    receivablesClientWise.forEach((key, value) {
      clients.add(AccountChartData(
        amount: value,
        entity: key,
        currency: 'INR',
      ));
    });
    clients.sort(((b, a) => a.amount.compareTo(b.amount)));
  }

  List<AccountChartData> getTop5Payables() {
    List<AccountChartData> contractors = [];
    payablesContractorWise.forEach((key, value) {
      contractors.add(AccountChartData(
        amount: value,
        entity: key,
        currency: 'INR',
      ));
    });
    contractors.sort(((b, a) => a.amount.compareTo(b.amount)));
    printNormal(contractors.length.toString());
    return contractors;
  }

  loadQuoteData({DateTime? fromDate, DateTime? toDate, String? country, String? client}) {
    clear();
    Query<Map<String, dynamic>> query = dashboardDataRef;
    if (fromDate != null) {
      query = query.where("date", isGreaterThanOrEqualTo: fromDate);
    }
    if (toDate != null) {
      query = query.where("date", isLessThanOrEqualTo: toDate);
    }
    if (country != null) {
      query = query.where("country", isEqualTo: country);
    }
    if (client != null) {
      query = query.where("client", isEqualTo: client);
    }
    query.get().then((value) {
      value.docs.map((e) => DashboardData.fromJson(e.data())).forEach((element) {
        totalMargin += element.margin.convert(element.currency, 'INR');
        totalContractorAmount += element.contractorAmount.convert(element.currency, 'INR');
        totalQuoteAmount += element.quoteAmount.convert(element.currency, 'INR');
      });
    });
  }
}
