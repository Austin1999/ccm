import 'dart:convert';
import 'package:ccm/models/response.dart';
import 'package:ccm/services/firebase.dart';

Contractor clientFromJson(String str) => Contractor.fromJson(json.decode(str));

String clientToJson(Contractor data) => json.encode(data.toJson());

class Contractor {
  Contractor({
    required this.name,
    this.address,
    this.country,
    this.email,
    this.phone,
  });

  String name;
  String? address;
  String? country;
  String? email;
  String? phone;

  factory Contractor.fromJson(Map<String, dynamic> json) => Contractor(
        name: json["name"],
        address: json["address"],
        country: json["country"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "country": country,
        "email": email,
        "phone": phone,
      };

  Future<dynamic> add() async {
    return await contractors
        .doc(name)
        .set(toJson())
        .then((value) => Response.success("Contractor Added successfully"))
        .onError((error, stackTrace) => Response.error(error));
  }

  get quotations => clients(country).doc(name).collection("quotations");
  get invoices => clients(country).doc(name).collection("invoices");
}
