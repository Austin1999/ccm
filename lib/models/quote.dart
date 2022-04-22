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
  List<String> comments;

  double get margin => (amount - clientCredits) - (contractorAmount - contractorAmount);
  double get percent => margin * 100 / (contractorPo.fold(0, (previousValue, element) => previousValue + element.amount));
  double get receivables => clientInvoices.fold(0, (previousValue, element) => previousValue + element.receivables);
  double get payables => contractorPo.fold(0, (previousValue, element) => previousValue + element.payables);
  double get clientCredits => clientInvoices.fold(0, (previousValue, element) => previousValue + element.creditAmount);
  double get contractorCredits => contractorPo.fold(0, (previousValue, element) => previousValue + element.credits);
  double get contractorAmount => contractorPo.fold(0, (previousValue, element) => previousValue + element.amount);

  factory Quotation.fromJson(Map<String, dynamic> json) => Quotation(
        id: json["id"],
        number: json["number"],
        client: json["client"],
        amount: json["amount"],
        clientApproval: json["clientApproval"],
        issuedDate: json["issuedDate"].toDate(),
        description: json["description"],
        approvalStatus: ApprovalStatus.values.elementAt(json["approvalStatus"]),
        ccmTicketNumber: json["ccmTicketNumber"],
        completionDate: json["completionDate"].toDate(),
        overallStatus: OverallStatus.values.elementAt(json["overallStatus"]),
        clientInvoices: List<Invoice>.from(json["clientInvoices"].map((x) => Invoice.fromJson(x))),
        contractorPo: List<ContractorPo>.from(json["contractorPo"].map((x) => ContractorPo.fromJson(x))),
        comments: List<String>.from(json["comments"].map((x) => x)),
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

  Map<String, dynamic> toJson() => {
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
        "comments": List<dynamic>.from(comments.map((x) => x)),
        "search": search
      };

  Map<String, dynamic> toRTDBJson() => {
        "id": id,
        "number": number,
        "client": client,
        "amount": amount,
        "approvalStatus": approvalStatus.index,
        "currencyCode": currencyCode,
        "margin": margin,
        "receivables": receivables,
        "payables": payables,
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

  double get receivedAmount => payments.fold(0, (previousValue, element) => previousValue + element.amount);
  double get creditAmount => credits.fold(0, (previousValue, element) => previousValue + element.amount);
  double get receivables => amount - receivedAmount - creditAmount;

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
  String quoteNumber;
  double quoteAmount;
  DateTime? workCommence;
  DateTime? workComplete;
  List<Invoice> invoices;

  double get payables => invoices.fold(0, (previousValue, element) => previousValue + element.receivables);
  double get credits => invoices.fold(0, (previousValue, element) => previousValue + element.creditAmount);

  factory ContractorPo.fromJson(Map<String, dynamic> json) => ContractorPo(
        number: json["number"],
        contractor: json["contractor"],
        amount: json["amount"],
        issuedDate: json["issuedDate"].toDate(),
        quoteNumber: json["quoteNumber"],
        quoteAmount: json["quoteAmount"],
        workCommence: json["workCommence"].toDate(),
        workComplete: json["workComplete"].toDate(),
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
      };
}
