// To parse this JSON data, do
//
//     final client = clientFromJson(jsonString);

import 'dart:convert';
import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/models/response.dart';
import 'package:ccm/services/firebase.dart';

Client clientFromJson(String str) => Client.fromJson(json.decode(str), '');

String clientToJson(Client data) => json.encode(data.toJson());

class Client {
  Client({required this.name, this.address, this.country, this.email, this.phone, this.contactPerson, this.docid, this.cwr});

  String name;
  String? address;
  String? country;
  String? email;
  String? phone;
  String? cwr;
  String? contactPerson;
  String? docid;

  factory Client.fromJson(Map<String, dynamic> json, doc_id) => Client(
      name: json["name"],
      address: json["address"],
      country: json["country"],
      email: json["email"],
      phone: json["phone"],
      cwr: json["cwr"] ?? '',
      docid: doc_id,
      contactPerson: json["contactPerson"] ?? '');

  Map<String, dynamic> toJson() =>
      {"name": name, "address": address, "country": country, "email": email, "phone": phone, "cwr": cwr, "contactPerson": contactPerson};

  Future<dynamic> add() async {
    return await clients(country)
        .doc(name)
        .set(toJson())
        .then((value) => Result.success("Client Added successfully"))
        .onError((error, stackTrace) => Result.error(error));
  }

  static Future<List<Client>> list() async {
    return clients(session.country!.code).get().then((value) {
      return value.docs.map((e) => Client.fromJson(e.data(), '')).toList();
    });
  }
}

InvoicePaymentModel clientCreditModelFromJson(String str) => InvoicePaymentModel.fromJson(json.decode(str));

String clientCreditModelToJson(InvoicePaymentModel data) => json.encode(data.toJson());

class InvoicePaymentModel {
  InvoicePaymentModel({
    this.invoiceamount,
    this.invoicenumber,
    this.issueddate,
    this.paymentdate,
    this.recievedamount,
  });

  double? invoiceamount;
  String? invoicenumber;
  String? issueddate;
  String? paymentdate;
  double? recievedamount;

  factory InvoicePaymentModel.fromJson(Map<String, dynamic> json) => InvoicePaymentModel(
        invoiceamount: json["invoiceamount"],
        invoicenumber: json["invoicenumber"],
        issueddate: json["issueddate"],
        paymentdate: json["paymentdate"],
        recievedamount: json["recievedamount"],
      );

  Map<String, dynamic> toJson() => {
        "invoiceamount": invoiceamount,
        "invoicenumber": invoicenumber,
        "issueddate": issueddate,
        "paymentdate": paymentdate,
        "recievedamount": recievedamount,
      };
}

CreditModel clientInvoiePaymentModelFromJson(String str) => CreditModel.fromJson(json.decode(str));

String clientInvoiePaymentModelToJson(CreditModel data) => json.encode(data.toJson());

class CreditModel {
  CreditModel({
    this.invoiceamount,
    this.invoicenumber,
    this.issueddate,
    this.creditRecieveDate,
    this.creditamount,
    this.creditnoteno,
  });

  double? invoiceamount;
  String? invoicenumber;
  String? issueddate;
  String? creditRecieveDate;
  double? creditamount;
  String? creditnoteno;

  factory CreditModel.fromJson(Map<String, dynamic> json) => CreditModel(
        invoiceamount: json["invoiceamount"],
        invoicenumber: json["invoicenumber"],
        issueddate: json["issueddate"],
        creditRecieveDate: json["creditRecieveDate"],
        creditamount: json["creditamount"],
        creditnoteno: json["creditnoteno"],
      );

  Map<String, dynamic> toJson() => {
        "invoiceamount": invoiceamount,
        "invoicenumber": invoicenumber,
        "issueddate": issueddate,
        "creditRecieveDate": creditRecieveDate,
        "creditamount": creditamount,
        "creditnoteno": creditnoteno,
      };
}

// // ClientTotalModel clientInvoiePaymentModelFromJson(String str) => CreditModel.fromJson(json.decode(str));

// // String clientInvoiePaymentModelToJson(ClientTotalModel data) => json.encode(data.toJson());

// class ClientTotalModel {
//     ClientTotalModel({
//         this.invoiceamount,
//         this.invoicenumber,
//         this.issueddate,
//         this.creditRecieveDate,
//         this.creditamount,
//         this.creditnoteno,
//     });

//     double? invoiceamount;
//     String? invoicenumber;
//     String? issueddate;
//     String? creditRecieveDate;
//     double? creditamount;
    
//     String? creditnoteno;
//     double? 1;

//     factory ClientTotalModel.fromJson(Map<String, dynamic> json) => ClientTotalModel(
//         invoiceamount: json["invoiceamount"],
//         invoicenumber: json["invoicenumber"],
//         issueddate: json["issueddate"],
//         creditRecieveDate: json["creditRecieveDate"],
//         creditamount: json["creditamount"],
//         creditnoteno: json["creditnoteno"],
//     );

//     Map<String, dynamic> toJson() => {
//         "invoiceamount": invoiceamount,
//         "invoicenumber": invoicenumber,
//         "issueddate": issueddate,
//         "creditRecieveDate": creditRecieveDate,
//         "creditamount": creditamount,
//         "creditnoteno": creditnoteno,
//     };
// }