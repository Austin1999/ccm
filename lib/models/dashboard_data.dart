class DashboardData {
  DashboardData({
    this.quoteAmount = 0,
    this.clientCredits = 0,
    this.contractorAmount = 0,
    this.contractorCredits = 0,
    required this.country,
    required this.id,
    this.margin = 0,
    this.paidAmount = 0,
    this.payableAmount = 0,
    this.receivableAmount = 0,
    this.receivedAmount = 0,
    this.clientInvoiceAmount = 0,
    required this.currency,
    this.quoteDate,
  });

  double quoteAmount;
  double clientCredits;
  double contractorAmount;
  double contractorCredits;
  String country;
  String id;
  double margin;
  double paidAmount;
  double payableAmount;
  double receivableAmount;
  double receivedAmount;
  double clientInvoiceAmount;
  String currency;
  DateTime? quoteDate;

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
      quoteAmount: json["quoteAmount"],
      clientCredits: json["clientCredits"],
      contractorAmount: json["contractorAmount"],
      contractorCredits: json["contractorCredits"],
      country: json["country"],
      id: json["id"],
      margin: json["margin"],
      paidAmount: json["paidAmount"],
      payableAmount: json["payableAmount"],
      receivableAmount: json["receivableAmount"],
      receivedAmount: json["receivedAmount"],
      clientInvoiceAmount: json["clientInvoiceAmount"] ?? 0,
      quoteDate: json['quoteDate'] == null ? null : json['quoteDate'].toDate(),
      currency: json["currency"]);

  Map<String, dynamic> toJson() => {
        "currency": currency,
        "quoteAmount": quoteAmount,
        "clientCredits": clientCredits,
        "contractorAmount": contractorAmount,
        "contractorCredits": contractorCredits,
        "country": country,
        "id": id,
        "margin": margin,
        "paidAmount": paidAmount,
        "payableAmount": payableAmount,
        "receivableAmount": receivableAmount,
        "receivedAmount": receivedAmount,
        "clientInvoiceAmount": clientInvoiceAmount,
        "quoteDate": quoteDate,
      };
}

class ListElement {
  ListElement({
    required this.amount,
    required this.date,
    required this.entity,
    this.credits = 0.0,
    required this.quote_id,
    required this.currency,
    required this.actualAmount,
    required this.closedAmount,
    required this.country,
    this.quoteDate,
    required this.client,
  });

  double amount;
  DateTime date;
  String entity;
  double credits;
  String quote_id;
  String currency;
  double actualAmount;
  double closedAmount;
  String country;
  DateTime? quoteDate;
  String client;

  int get daysAged => DateTime.now().difference(date).inDays;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        amount: json["amount"],
        date: DateTime.fromMillisecondsSinceEpoch(json["date"]),
        entity: json["entity"],
        credits: json["credits"] ?? 0,
        quote_id: json["quote_id"] ?? '',
        currency: json["currency"] ?? '',
        actualAmount: json["actualAmount"],
        closedAmount: json["closedAmount"],
        country: json['country'],
        quoteDate: json['quoteDate'] == null ? null : json['quoteDate'].toDate(),
        client: json['client'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "date": date.millisecondsSinceEpoch,
        "entity": entity,
        "credits": credits,
        "quote_id": quote_id,
        "currency": currency,
        "actualAmount": actualAmount,
        "closedAmount": closedAmount,
        "country": country,
        "quoteDate": quoteDate,
        "client": client,
      };
}
