// To parse required this JSON data, do
//
//     final quotation = quotationFromJson(jsonString);

import 'dart:convert';

Quotation quotationFromJson(String str) => Quotation.fromJson(json.decode(str));

String quotationToJson(Quotation data) => json.encode(data.toJson());

class Quotation {
  Quotation({
    required this.number,
    required this.amount,
    required this.approvalStatus,
    required this.date,
    required this.client,
    required this.clientId,
    required this.country,
    required this.parentQuoteId,
    required this.description,
    required this.ccmTicketNumber,
    required this.jobStatus,
    required this.clientPurchaseOrders,
    required this.contractorPurchaseOrders,
  });

  String number;
  double amount;
  int approvalStatus;
  DateTime date;
  String client;
  String clientId;
  String country;
  String parentQuoteId;
  String description;
  String ccmTicketNumber;
  int jobStatus;
  List<ClientPurchaseOrder> clientPurchaseOrders;
  List<ContractorPurchaseOrder> contractorPurchaseOrders;

  factory Quotation.fromJson(Map<String, dynamic> json) => Quotation(
        number: json["number"],
        amount: json["amount"].toDouble(),
        approvalStatus: json["approval_status"],
        date: DateTime.parse(json["date"].toDate()),
        client: json["client"],
        clientId: json["client_id"],
        country: json["country"],
        parentQuoteId: json["parent_quote_id"],
        description: json["description"],
        ccmTicketNumber: json["ccm_ticket_number"],
        jobStatus: json["job_status"],
        clientPurchaseOrders: json["clientPurchaseOrders"] == null
            ? []
            : List<ClientPurchaseOrder>.from(json["clientPurchaseOrders"].map((x) => ClientPurchaseOrder.fromJson(x))),
        contractorPurchaseOrders: json["contractorPurchaseOrders"] == null
            ? []
            : List<ContractorPurchaseOrder>.from(json["contractorPurchaseOrders"].map((x) => ContractorPurchaseOrder.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "amount": amount,
        "approval_status": approvalStatus,
        "date": date,
        "client": client,
        "client_id": clientId,
        "country": country,
        "parent_quote_id": parentQuoteId,
        "description": description,
        "ccm_ticket_number": ccmTicketNumber,
        "job_status": jobStatus,
        "clientPurchaseOrders": List<dynamic>.from(clientPurchaseOrders.map((x) => x.toJson())),
        "contractorPurchaseOrders": List<dynamic>.from(contractorPurchaseOrders.map((x) => x.toJson())),
      };
}

class ClientPurchaseOrder {
  ClientPurchaseOrder({
    required this.id,
    required this.number,
    required this.date,
    required this.amount,
    required this.clientId,
    required this.invoices,
  });

  String id;
  String number;
  DateTime date;
  double amount;
  String clientId;
  List<Invoice> invoices;

  factory ClientPurchaseOrder.fromJson(Map<String, dynamic> json) => ClientPurchaseOrder(
        id: json["id"],
        number: json["number"],
        date: DateTime.parse(json["date"].toDate()),
        amount: json["amount"].toDouble(),
        clientId: json["client_id"],
        invoices: List<Invoice>.from(json["invoices"].map((x) => Invoice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "date": date,
        "amount": amount,
        "client_id": clientId,
        "invoices": List<dynamic>.from(invoices.map((x) => x.toJson())),
      };
}

class Invoice {
  Invoice({
    required this.number,
    required this.receivedDate,
    required this.amount,
    required this.received,
    required this.payments,
    required this.credits,
    required this.taxNumber,
  });

  String number;
  DateTime receivedDate;
  double amount;
  double received;
  List<Payment> payments;
  List<Credit> credits;
  String? taxNumber;

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        number: json["number"],
        receivedDate: json["received_date"].toDate(),
        amount: json["amount"].toDouble(),
        received: json["received"].toDouble(),
        payments: List<Payment>.from(json["payments"].map((x) => Payment.fromJson(x))),
        credits: List<Credit>.from(json["credits"].map((x) => Credit.fromJson(x))),
        taxNumber: json["tax_number"] == null ? null : json["tax_number"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "received_date": receivedDate,
        "amount": amount,
        "received": received,
        "payments": List<dynamic>.from(payments.map((x) => x.toJson())),
        "credits": List<dynamic>.from(credits.map((x) => x.toJson())),
        "tax_number": taxNumber,
      };
}

class Credit {
  Credit({
    required this.note,
    required this.amount,
    required this.date,
  });

  String note;
  double amount;
  DateTime date;

  factory Credit.fromJson(Map<String, dynamic> json) => Credit(
        note: json["note"],
        amount: json["amount"].toDouble(),
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "note": note,
        "amount": amount,
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
        amount: json["amount"].toDouble(),
        date: json["date"].toDate(),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "date": date,
      };
}

class ContractorPurchaseOrder {
  ContractorPurchaseOrder({
    required this.id,
    required this.number,
    required this.date,
    this.quotationAmount,
    this.quotationNumber,
    required this.amount,
    required this.clientId,
    required this.workCommenceDate,
    required this.workCompleteDate,
    required this.invoices,
  });

  String id;
  String number;
  String? quotationNumber;
  double? quotationAmount;
  DateTime date;
  double amount;
  String clientId;
  DateTime workCommenceDate;
  DateTime workCompleteDate;
  List<Invoice> invoices;

  factory ContractorPurchaseOrder.fromJson(Map<String, dynamic> json) => ContractorPurchaseOrder(
        id: json["id"],
        number: json["number"],
        date: json["date"].toDate(),
        amount: json["amount"].toDouble(),
        quotationNumber: json["quotationNumber"],
        quotationAmount: json["quotationAmount"].toDouble(),
        clientId: json["client_id"],
        workCommenceDate: DateTime.parse(json["work_commence_date"]),
        workCompleteDate: DateTime.parse(json["work_complete_date"]),
        invoices: List<Invoice>.from(json["invoices"].map((x) => Invoice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "number": number,
        "date": date,
        "amount": amount,
        "quotationNumber": quotationNumber,
        "quotationAmount": quotationAmount,
        "client_id": clientId,
        "work_commence_date": workCommenceDate,
        "work_complete_date": workCompleteDate,
        "invoices": List<dynamic>.from(invoices.map((x) => x.toJson())),
      };
}
