// To parse required this JSON data, do
//
//     final quotation = quotationFromJson(jsonString);

import 'package:ccm/models/client.dart';

// Quotation quotationFromJson(String str) => Quotation.fromJson(json.decode(str));

// String quotationToJson(Quotation data) => json.encode(data.toJson());

class Quotation {
  Quotation({
    required this.qnumber,
    required this.clientname,
    required this.qamount,
    required this.clientApproval,
    required this.dateIssued,
    required this.description,
    required this.approvalStatus,
    required this.ccmTicketNumber,
    required this.jobcompletionDate,
    required this.overallstatus,
    this.parentQuoteId,
    required this.clientInvoices,
    required this.contractorPurchaseOrders,
    required this.isTrash,
    this.comment,
    this.id,
    required this.category,
    required this.search,
    required this.inr,
  });

  String qnumber;
  String clientname;
  double qamount;
  String category;
  String inr;
  String clientApproval;
  DateTime dateIssued;
  String description;
  String approvalStatus;
  String ccmTicketNumber;
  bool isTrash;
  List<String>? comment;
  DateTime jobcompletionDate;
  String overallstatus;
  String? parentQuoteId;
  String? id;
  List<dynamic> search;
  List<ClientInvoice> clientInvoices;
  List<ContractorPurchaseOrder> contractorPurchaseOrders;

  factory Quotation.fromJson(Map<String, dynamic> json, id) => Quotation(
        search: json['search'] ?? [],
        id: id,
        inr: json['inr'] ?? '',
        category: json['category'] ?? '',
        comment: json["comment"] ?? [],
        isTrash: json["isTrash"] ?? '',
        qnumber: json["Qnumber"] ?? '',
        clientname: json["clientname"] ?? '',
        qamount: json["Qamount"] ?? 0.00,
        clientApproval: json["clientApproval"] ?? '',
        dateIssued: json["dateIssued"]?.toDate() ?? DateTime.now(),
        description: json["description"] ?? '',
        approvalStatus: json["approvalStatus"] ?? '',
        ccmTicketNumber: json["ccmTicketNumber"] ?? '',
        jobcompletionDate: json["jobcompletionDate"] != null ? json["jobcompletionDate"]?.toDate() : null,
        overallstatus: json["overallstatus"] ?? '',
        parentQuoteId: json["parentQuoteId"] ?? '',
        clientInvoices: json["clientInvoices"] == null
            ? []
            : List<ClientInvoice>.from(
                json["clientInvoices"].map(
                  (x) => ClientInvoice.fromJson(x),
                ),
              ),
        contractorPurchaseOrders: json["contractorPurchaseOrders"] == null
            ? []
            : List<ContractorPurchaseOrder>.from(
                json["contractorPurchaseOrders"].map(
                  (x) => ContractorPurchaseOrder.fromJson(x),
                ),
              ),
      );

  Map<String, dynamic> toJson() => {
        "search": search,
        "inr": inr,
        "category": category,
        "isTrash": isTrash,
        "Qnumber": qnumber,
        "clientname": clientname,
        "Qamount": qamount,
        "clientApproval": clientApproval,
        "dateIssued": dateIssued,
        "description": description,
        "approvalStatus": approvalStatus,
        "ccmTicketNumber": ccmTicketNumber,
        "jobcompletionDate": jobcompletionDate,
        "overallstatus": overallstatus,
        "parentQuoteId": parentQuoteId ?? '',
        "clientInvoices": List<dynamic>.from(clientInvoices.map((x) => x.toJson())),
        "comment": comment,
        "contractorPurchaseOrders": List<dynamic>.from(contractorPurchaseOrders.map((x) => x.toJson())),
      };
}

// class ClientPurchaseOrder {
//   ClientPurchaseOrder({
//     required this.id,
//     required this.number,
//     required this.date,
//     required this.amount,
//     required this.clientId,
//     required this.invoices,
//   });

//   String id;
//   String number;
//   DateTime date;
//   double amount;
//   String clientId;
//   List<ClientInvoice> invoices;

//   factory ClientPurchaseOrder.fromJson(Map<String, dynamic> json) =>
//       ClientPurchaseOrder(
//         id: json["id"],
//         number: json["number"],
//         date: DateTime.parse(json["date"].toDate()),
//         amount: json["amount"].toDouble(),
//         clientId: json["client_id"],
//         invoices: List<ClientInvoice>.from(
//             json["invoices"].map((x) => ClientInvoice.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "number": number,
//         "date": date,
//         "amount": amount,
//         "client_id": clientId,
//         "invoices": List<dynamic>.from(invoices.map((x) => x.toJson())),
//       };
// }

class ContractorInvoice {
  ContractorInvoice({
    required this.number,
    this.uid,
    required this.receivedDate,
    required this.amount,
    required this.paidDate,
    this.contractorinvoicepayments,
    this.contractorcredits,
    required this.paidamount,
    required this.taxNumber,
  });

  String number;
  DateTime receivedDate;
  double amount;
  String? uid;
  DateTime paidDate;
  List<CreditModel>? contractorcredits;
  List<InvoicePaymentModel>? contractorinvoicepayments;
  double paidamount;
  String? taxNumber;

  factory ContractorInvoice.fromJson(Map<String, dynamic> json) => ContractorInvoice(
        number: json["number"],
        receivedDate: json["received_date"].toDate(),
        amount: json["amount"].toDouble(),
        paidamount: json["paidamount"].toDouble(),
        paidDate: json["paidDate"].toDate(),
        contractorcredits: List<CreditModel>.from(
          json['clientcredits'].map(
            (x) => CreditModel.fromJson(x),
          ),
        ),
        contractorinvoicepayments: List<InvoicePaymentModel>.from(
          json['clientinvoicepayments'].map(
            (x) => InvoicePaymentModel.fromJson(x),
          ),
        ),
        taxNumber: json["tax_number"] == null ? null : json["tax_number"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "received_date": receivedDate,
        "amount": amount,
        "paidDate": paidDate,
        "paidamount": paidamount,
        "clientcredits": List<dynamic>.from(contractorcredits!.map((x) => x.toJson())),
        "clientinvoicepayments": List<dynamic>.from(contractorinvoicepayments!.map((x) => x.toJson())),
        "tax_number": taxNumber,
      };
}

class ClientInvoice {
  ClientInvoice(
      {required this.number,
      this.uid,
      required this.receivedDate,
      required this.amount,
      required this.recievedamount,
      required this.issueDate,
      this.clientcredits,
      this.clientinvoicepayments
      // this.contractorpo,
      });

  String number;
  DateTime receivedDate;
  String? uid;
  double amount;
  double recievedamount;
  DateTime issueDate;
  List<CreditModel>? clientcredits;
  List<InvoicePaymentModel>? clientinvoicepayments;
  // List<ContractorPurchaseOrder>? contractorpo;

  factory ClientInvoice.fromJson(Map<String, dynamic> json) => ClientInvoice(
        number: json["number"],
        receivedDate: json["received_date"].toDate(),
        recievedamount: json["recieved_amount"],
        amount: json["amount"].toDouble(),
        issueDate: json["issueDate"].toDate(),
        clientcredits: List<CreditModel>.from(
          json['clientcredits'].map(
            (x) => CreditModel.fromJson(x),
          ),
        ),
        clientinvoicepayments: List<InvoicePaymentModel>.from(
          json['clientinvoicepayments'].map(
            (x) => InvoicePaymentModel.fromJson(x),
          ),
        ),
        // contractorpo: List<ContractorPurchaseOrder>.from(
        //   json["contractorpo"].map(
        //     (x) => ContractorPurchaseOrder.fromJson(x),
        //   ),
        // ),
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "received_date": receivedDate,
        "amount": amount,
        "issueDate": issueDate,
        "clientcredits": List<dynamic>.from(clientcredits!.map((x) => x.toJson())),
        "clientinvoicepayments": List<dynamic>.from(clientinvoicepayments!.map((x) => x.toJson())),
        // "contractorpo":
        //     List<dynamic>.from(contractorpo!.map((x) => x.toJson())),
        "recieved_amount": recievedamount
      };
}

// class Credit {
//   Credit({
//     required this.note,
//     required this.amount,
//     required this.date,
//   });

//   String note;
//   double amount;
//   DateTime date;

//   factory Credit.fromJson(Map<String, dynamic> json) => Credit(
//         note: json["note"],
//         amount: json["amount"].toDouble(),
//         date: DateTime.parse(json["date"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "note": note,
//         "amount": amount,
//         "date": date,
//       };
// }

// class Payment {
//   Payment({
//     required this.amount,
//     required this.date,
//   });

//   double amount;
//   DateTime date;

//   factory Payment.fromJson(Map<String, dynamic> json) => Payment(
//         amount: json["amount"].toDouble(),
//         date: json["date"].toDate(),
//       );

//   Map<String, dynamic> toJson() => {
//         "amount": amount,
//         "date": date,
//       };
// }

class ContractorPurchaseOrder {
  ContractorPurchaseOrder({
    this.uid,
    required this.poNumber,
    required this.name,
    required this.poAmount,
    required this.issueDate,
    required this.quotationAmount,
    required this.quotationNumber,
    required this.workCommenceDate,
    required this.workCompleteDate,
    required this.invoices,
  });
  String poNumber;
  String? uid;
  String name;
  double poAmount;
  DateTime issueDate;
  String? quotationNumber;
  double? quotationAmount;

  DateTime workCommenceDate;
  DateTime workCompleteDate;
  List<ContractorInvoice> invoices;

  factory ContractorPurchaseOrder.fromJson(Map<String, dynamic> json) => ContractorPurchaseOrder(
        name: json["name"],
        poNumber: json["poNumber"],
        issueDate: json["issueDate"].toDate(),
        poAmount: json["poAmount"].toDouble(),
        quotationNumber: json["quotationNumber"],
        quotationAmount: json["quotationAmount"].toDouble(),
        workCommenceDate: json["workCommenceDate"].toDate(),
        workCompleteDate: json["workCompleteDate"].toDate(),
        invoices: List<ContractorInvoice>.from(
          json["invoices"].map(
            (x) => ContractorInvoice.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "poNumber": poNumber,
        "issueDate": issueDate,
        "poAmount": poAmount,
        "quotationNumber": quotationNumber,
        "quotationAmount": quotationAmount,
        "workCommenceDate": workCommenceDate,
        "workCompleteDate": workCompleteDate,
        "invoices": List<dynamic>.from(invoices.map((x) => x.toJson())),
      };
}
