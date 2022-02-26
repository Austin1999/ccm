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
  Client(
      {required this.name,
      this.address,
      this.country,
      this.email,
      this.phone,
      this.contactPerson,
      this.docid,
      this.cwr});

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

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "country": country,
        "email": email,
        "phone": phone,
        "cwr": cwr,
        "contactPerson": contactPerson
      };

  Future<dynamic> add() async {
    return await clients(country)
        .doc(name)
        .set(toJson())
        .then((value) => Response.success("Client Added successfully"))
        .onError((error, stackTrace) => Response.error(error));
  }

  static Future<List<Client>> list() async {
    return clients(session.country!.code).get().then((value) {
      return value.docs.map((e) => Client.fromJson(e.data(), '')).toList();
    });
  }
}
