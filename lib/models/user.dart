// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.name,
    this.fname,
    this.email,
    this.role,
    this.country,
    this.department,
    this.contactPerson,
    this.status,
    this.created,
    this.phone,
    this.address,
    this.roleName,
    this.quotationClientSec,
    this.quotationContSec,
    this.invoiceClientSec,
    this.invoiceContSec,
    this.viewDash,
    this.viewClient,
    this.viewCont,
  });

  String? id;
  String? name;
  String? fname;
  String? email;
  String? role;
  String? country;
  String? department;
  String? contactPerson;
  String? status;
  DateTime? created;
  String? phone;
  String? address;
  String? roleName;
  String? quotationClientSec;
  String? quotationContSec;
  String? invoiceClientSec;
  String? invoiceContSec;
  String? viewDash;
  String? viewClient;
  String? viewCont;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        fname: json["fname"],
        email: json["email"],
        role: json["role"],
        country: json["country"],
        department: json["department"],
        contactPerson: json["contact_person"],
        status: json["status"],
        created: DateTime.parse(json["created"]),
        phone: json["phone"],
        address: json["address"],
        roleName: json["role_name"],
        quotationClientSec: json["quotation_client_sec"],
        quotationContSec: json["quotation_cont_sec"],
        invoiceClientSec: json["invoice_client_sec"],
        invoiceContSec: json["invoice_cont_sec"],
        viewDash: json["view_dash"],
        viewClient: json["view_client"],
        viewCont: json["view_cont"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "fname": fname,
        "email": email,
        "role": role,
        "country": country,
        "department": department,
        "contact_person": contactPerson,
        "status": status,
        "created": created == null ? created : created!.toIso8601String(),
        "phone": phone,
        "address": address,
        "role_name": roleName,
        "quotation_client_sec": quotationClientSec,
        "quotation_cont_sec": quotationContSec,
        "invoice_client_sec": invoiceClientSec,
        "invoice_cont_sec": invoiceContSec,
        "view_dash": viewDash,
        "view_client": viewClient,
        "view_cont": viewCont,
      };
}

Session sessionFromJson(String str) => Session.fromJson(json.decode(str));

String sessionToJson(Session data) => json.encode(data.toJson());

class Session {
  Session({
    this.accessToken,
    this.isLogin,
  });

  String? accessToken;
  bool? isLogin;

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        accessToken: json["access_token"],
        isLogin: json["is_login"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "is_login": isLogin,
      };
}
