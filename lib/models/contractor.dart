import 'package:ccm/models/response.dart';
import 'package:ccm/services/firebase.dart';

Contractor clientFromJson(String str) => Contractor.fromJson(json.decode(str), '');

String clientToJson(Contractor data) => json.encode(data.toJson());

class Contractor {
  Contractor(
      {required this.name, this.address, this.country, this.email, this.phone, this.contactPerson, this.payable, this.docid, this.countryName});

  String name;
  String? address;
  String? country;
  String? email;
  String? phone;
  int? payable;
  String? countryName;
  String? contactPerson;
  String? docid;

  factory Contractor.fromJson(Map<String, dynamic> json, docId) => Contractor(
      name: json["name"],
      address: json["address"],
      country: json["country"],
      email: json["email"],
      payable: json['payable'] ?? 0,
      phone: json["phone"],
      countryName: json["countryName"] ?? '',
      docid: docId,
      contactPerson: json["contactPerson"] ?? '');

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "country": country,
        "payable": payable,
        "email": email,
        "phone": phone,
        "countryName": countryName,
        "contactPerson": contactPerson,
        "docId": docid,
      };

  Future<dynamic> add() async {
    docid = await getNextContractorID();
    return await contractors
        .doc(docid)
        .set(toJson())
        .then((value) => Result.success("Contractor Added successfully"))
        .onError((error, stackTrace) => Result.error(error));
  }

  Future<dynamic> update() async {
    return await contractors
        .doc(docid)
        .set(toJson())
        .then((value) => Result.success("Contractor Added successfully"))
        .onError((error, stackTrace) => Result.error(error));
  }

  get quotations => clients(country).doc(name).collection("quotations");
  get invoices => clients(country).doc(name).collection("invoices");
}
