// To parse this JSON data, do
//
//     final dashboardData = dashboardDataFromJson(jsonString);

import 'dart:convert';

DashboardData dashboardDataFromJson(String str) => DashboardData.fromJson(json.decode(str));

String dashboardDataToJson(DashboardData data) => json.encode(data.toJson());

class DashboardData {
  DashboardData({
    required this.id,
    this.amount = 0,
    required this.client,
    required this.issuedDate,
    required this.currencyCode,
    required this.country,
    this.clientInvoiceAmount = 0,
    this.receivedAmount = 0,
    this.receivableAmount = 0,
    this.clientCredits = 0,
    this.contractorInvoiceAmount = 0,
    this.paidAmount = 0,
    this.payableAmount = 0,
    this.contractorCredits = 0,
    this.contractorAmount = 0,
    this.margin = 0,
  });

  String id;
  double amount;
  String client;
  DateTime issuedDate;
  String currencyCode;
  String country;
  double clientInvoiceAmount;
  double receivedAmount;
  double receivableAmount;
  double clientCredits;
  double contractorInvoiceAmount;
  double paidAmount;
  double payableAmount;
  double contractorCredits;
  double contractorAmount;
  double margin;

  factory DashboardData.fromJson(Map<String, dynamic> json) => DashboardData(
        id: json["id"],
        amount: json["amount"],
        client: json["client"],
        issuedDate: json["issuedDate"].toDate(),
        currencyCode: json["currencyCode"],
        country: json["country"],
        clientInvoiceAmount: json["clientInvoiceAmount"] ?? 0,
        receivedAmount: json["receivedAmount"] ?? 0,
        receivableAmount: json["receivableAmount"] ?? 0,
        clientCredits: json["clientCredits"] ?? 0,
        contractorInvoiceAmount: json["contractorInvoiceAmount"] ?? 0,
        paidAmount: json["paidAmount"] ?? 0,
        payableAmount: json["payableAmount"] ?? 0,
        contractorCredits: json["contractorCredits"] ?? 0,
        contractorAmount: json["contractorAmount"] ?? 0,
        margin: json["margin"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "client": client,
        "issuedDate": issuedDate.toIso8601String(),
        "currencyCode": currencyCode,
        "country": country,
        "clientInvoiceAmount": clientInvoiceAmount,
        "receivedAmount": receivedAmount,
        "receivableAmount": receivableAmount,
        "clientCredits": clientCredits,
        "contractorInvoiceAmount": contractorInvoiceAmount,
        "paidAmount": paidAmount,
        "payableAmount": payableAmount,
        "contractorCredits": contractorCredits,
        "contractorAmount": contractorAmount,
        "margin": margin,
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
