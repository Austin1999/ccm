import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/comment.dart';
import 'package:ccm/models/dashboard_data.dart';
import 'package:ccm/models/response.dart';
import 'package:ccm/services/firebase.dart';

enum ApprovalStatus { pending, approved, rejected, cancelled }
enum OverallStatus { pending, completed, cancelled }

class Quotation {
  Quotation({
    this.id,
    required this.number,
    required this.client,
    required this.amount,
    required this.currencyCode,
    this.parentQuote,
    this.category,
    required this.clientApproval,
    required this.issuedDate,
    required this.description,
    required this.approvalStatus,
    required this.ccmTicketNumber,
    this.completionDate,
    required this.overallStatus,
    required this.clientInvoices,
    required this.contractorPo,
    required this.comments,
  });

  String? id;
  String number;
  String client;
  double amount;
  String? currencyCode;
  String? parentQuote;
  String? category;
  String clientApproval;
  DateTime issuedDate;
  String description;
  ApprovalStatus approvalStatus;
  String ccmTicketNumber;
  DateTime? completionDate;
  OverallStatus overallStatus;
  List<Invoice> clientInvoices;
  List<ContractorPo> contractorPo;
  List<Comment> comments;

  double get margin => (amount - clientCredits) - (contractorAmount - contractorCredits);
  double get percent => margin * 100 / (contractorPo.fold(0, (previousValue, element) => previousValue + element.amount));

  double get receivedAmount => clientInvoices.fold(0, (previousValue, element) => previousValue + element.closedAmount);
  double get receivableAmount => clientInvoices.fold(0, (previousValue, element) => previousValue + element.remaining);

  double get paidAmount => contractorPo.fold(0, (previousValue, element) => previousValue + element.paidAmount);
  double get payableAmount => contractorPo.fold(0, (previousValue, element) => previousValue + element.totalPayables);

  double get clientCredits => clientInvoices.fold(0, (previousValue, element) => previousValue + element.creditAmount);
  double get contractorCredits => contractorPo.fold(0, (previousValue, element) => previousValue + element.credits);

  double get contractorAmount => contractorPo.fold(0, (previousValue, element) => previousValue + element.amount);

  List<Map<String, dynamic>> get receivables => clientInvoices
      .map((e) => ListElement(
          closedAmount: e.closedAmount,
          actualAmount: e.amount,
          amount: e.remaining,
          date: e.issuedDate,
          credits: e.creditAmount,
          entity: client,
          quote_id: id ?? '',
          currency: currencyCode ?? '',
          country: session.country!.code,
          quoteDate: issuedDate,
          client: client))
      // .where((element) => element.amount > 0)
      .map((e) => e.toJson())
      .toList();

  List<Map<String, dynamic>> get payables {
    List<Map<String, dynamic>> payables = [];
    contractorPo.forEach((element) {
      payables.addAll(element.payables.map((e) {
        e.quote_id = id ?? '';
        e.currency = currencyCode ?? '';
        e.country = session.country!.code;
        e.quoteDate = issuedDate;
        e.client = client;
        return e.toJson();
      }).toList());
    });
    return payables;
  }

  factory Quotation.fromJson(Map<String, dynamic> json) => Quotation(
        id: json["id"],
        number: json["number"],
        client: json["client"],
        amount: json["amount"],
        clientApproval: json["clientApproval"],
        issuedDate: json["issuedDate"]?.toDate(),
        description: json["description"],
        approvalStatus: ApprovalStatus.values.elementAt(json["approvalStatus"]),
        ccmTicketNumber: json["ccmTicketNumber"],
        completionDate: json["completionDate"]?.toDate(),
        overallStatus: OverallStatus.values.elementAt(json["overallStatus"]),
        clientInvoices: List<Invoice>.from(json["clientInvoices"].map((x) => Invoice.fromJson(x))),
        contractorPo: List<ContractorPo>.from(json["contractorPo"].map((x) => ContractorPo.fromJson(x))),
        comments: List<Comment>.from(json["comments"].map((x) => Comment.fromJson(x))),
        currencyCode: json['currencyCode'],
        parentQuote: json['parentQuote'],
        category: json['category'],
      );

  get search {
    List<String> strings = [];
    strings.addAll(makeSearchString(number));
    clientInvoices.forEach((element) {
      strings.addAll(makeSearchString(element.number));
      element.credits.forEach((element) {
        strings.addAll(makeSearchString(element.note));
      });
    });
    contractorPo.forEach((po) {
      po.invoices.forEach((element) {
        strings.addAll(makeSearchString(element.number));
        element.credits.forEach((element) {
          strings.addAll(makeSearchString(element.note));
        });
      });
      strings.addAll(makeSearchString(po.number));
    });
    return strings;
  }

  makeSearchString(String text) {
    List<String> returns = [];
    var length = text.length;
    if (text.length >= 3) {
      for (int i = 2; i < length; i++) {
        returns.add(text.substring(2, i).toLowerCase());
      }
      returns.add(text.toLowerCase());
    }

    return returns;
  }

  Map<String, dynamic> toJson() {
    print(receivables);
    return {
      "id": id,
      "number": number,
      "client": client,
      "amount": amount,
      "clientApproval": clientApproval,
      "issuedDate": issuedDate,
      "description": description,
      "approvalStatus": approvalStatus.index,
      "ccmTicketNumber": ccmTicketNumber,
      "completionDate": completionDate,
      "overallStatus": overallStatus.index,
      "currencyCode": currencyCode,
      "parentQuote": parentQuote,
      "category": category,
      "clientInvoices": List<dynamic>.from(clientInvoices.map((x) => x.toJson())),
      "contractorPo": List<dynamic>.from(contractorPo.map((x) => x.toJson())),
      "comments": List<dynamic>.from(comments.map((x) => x.toJson())),
      "search": search,
      "contractorAmount": contractorAmount,
      "receivedAmount": receivedAmount,
      "receivableAmount": receivableAmount,
      "paidAmount": paidAmount,
      "payableAmount": payableAmount,
      "clientCredits": clientCredits,
      "contractorCredits": contractorCredits,
      "payables": payables,
      "receivables": receivables,
      "country": session.country!.code,
      "margin": margin,
    };
  }

  Future<Result> add() {
    return quotations
        .doc(id)
        .set(toJson())
        .then((value) => Result.success("Quote added successfully"))
        .onError((error, stackTrace) => Result.error(error.toString()));
  }

  Future<Result> update() {
    return quotations
        .doc(id)
        .set(toJson())
        .then((value) => Result.success("Quote updated successfully"))
        .onError((error, stackTrace) => Result.error(error.toString()));
  }

  Future<Result> delete() {
    return quotations
        .doc(id)
        .delete()
        .then((value) => Result.success("Quote deleted successfully"))
        .onError((error, stackTrace) => Result.error(error.toString()));
  }

  // addQuote() async {
  //   this.id = await getNextQuotationId();
  //   quotations.doc(id).set(toJson()).then((_) {
  //     List<Future> futures = [];
  //     payables.forEach((element) {
  //       futures.add(payablesRef.add(element));
  //     });
  //     receivables.forEach((element) {
  //       futures.add(receivablesRef.add(element));
  //     });
  //     futures.add(dashboardDataRef.doc(id).set(DashboardData.fromJson(toJson()).toJson()));
  //     return Future.wait(futures);
  //   }).then((value) => Result.success("Quotation added successfully"));
  // }
}

class ContractorPo {
  ContractorPo({
    required this.number,
    required this.contractor,
    required this.amount,
    required this.issuedDate,
    required this.quoteNumber,
    required this.quoteAmount,
    this.workCommence,
    this.workComplete,
    required this.invoices,
  });

  String number;
  String contractor;
  double amount;
  DateTime issuedDate;
  String? quoteNumber;
  double? quoteAmount;
  DateTime? workCommence;
  DateTime? workComplete;
  List<Invoice> invoices;

  double get totalPayables => invoices.fold(0, (previousValue, element) => previousValue + element.remaining);
  double get credits => invoices.fold(0, (previousValue, element) => previousValue + element.creditAmount);
  double get paidAmount => invoices.fold(0, (previousValue, element) => previousValue + element.closedAmount);

  List<ListElement> get payables => invoices.map((e) {
        var listElement = e.listElement;
        listElement.entity = contractor;
        return listElement;
      })
          // .where((element) => element.amount > 0)
          .toList();

  factory ContractorPo.fromJson(Map<String, dynamic> json) => ContractorPo(
        number: json["number"],
        contractor: json["contractor"],
        amount: json["amount"],
        issuedDate: json["issuedDate"].toDate(),
        quoteNumber: json["quoteNumber"],
        quoteAmount: json["quoteAmount"],
        workCommence: json["workCommence"]?.toDate(),
        workComplete: json["workComplete"]?.toDate(),
        invoices: List<Invoice>.from(json["invoices"].map((x) => Invoice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "contractor": contractor,
        "amount": amount,
        "issuedDate": issuedDate,
        "quoteNumber": quoteNumber,
        "quoteAmount": quoteAmount,
        "workCommence": workCommence,
        "workComplete": workComplete,
        "invoices": List<dynamic>.from(invoices.map((x) => x.toJson())),
        "paidAmount": paidAmount,
        "credits": credits,
        "totalPayables": totalPayables,
      };
}

class Invoice {
  Invoice({
    this.id,
    required this.number,
    required this.amount,
    this.taxNumber,
    required this.issuedDate,
    required this.payments,
    required this.credits,
  });

  String? id;
  String number;
  double amount;
  String? taxNumber;
  DateTime issuedDate;
  List<Payment> payments;
  List<Credit> credits;

  DateTime? get lastReceivedDate => payments.isEmpty
      ? null
      : (payments.length == 1)
          ? payments.first.date
          : payments.last.date;

  double get closedAmount => payments.fold(0, (previousValue, element) => previousValue + element.amount);
  double get creditAmount => credits.fold(0, (previousValue, element) => previousValue + element.amount);
  double get remaining {
    var amt = amount - closedAmount - creditAmount;
    return amt > 0 ? amt : 0;
  }

  ListElement get listElement => ListElement(
      closedAmount: closedAmount,
      actualAmount: amount,
      amount: remaining,
      date: issuedDate,
      entity: '',
      credits: creditAmount,
      quote_id: '',
      currency: '',
      country: '',
      client: '');

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        number: json["number"],
        amount: json["amount"],
        taxNumber: json["taxNumber"],
        issuedDate: json["issuedDate"].toDate(),
        payments: List<Payment>.from(json["payments"].map((x) => Payment.fromJson(x))),
        credits: List<Credit>.from(json["credits"].map((x) => Credit.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "amount": amount,
        "taxNumber": taxNumber,
        "issuedDate": issuedDate,
        "payments": List<dynamic>.from(payments.map((x) => x.toJson())),
        "credits": List<dynamic>.from(credits.map((x) => x.toJson())),
        "closedAmount": closedAmount,
        "creditAmount": creditAmount,
        "remaining": remaining
      };
}

class Credit {
  Credit({
    required this.amount,
    required this.note,
    required this.date,
  });

  double amount;
  String note;
  DateTime date;

  factory Credit.fromJson(Map<String, dynamic> json) => Credit(
        amount: json["amount"],
        note: json["note"],
        date: json["date"].toDate(),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "note": note,
        "date": date,
      };
}

class Payment {
  Payment({
    required this.amount,
    required this.date,
  });

  double amount;
  DateTime date;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        amount: json["amount"],
        date: json["date"].toDate(),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "date": date,
      };
}
