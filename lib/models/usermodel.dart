import 'dart:convert';
import 'package:ccm/models/response.dart';
import 'package:ccm/services/firebase.dart';

UserModel clientFromJson(String str) => UserModel.fromJson(json.decode(str), '');

String clientToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({required this.name, this.address, this.email, this.phone, this.fullname, this.docid, this.role});

  String name;
  String? address;
  String? email;
  String? phone;
  String? role;
  String? fullname;
  String? docid;

  factory UserModel.fromJson(Map<String, dynamic> json, doc_id) => UserModel(
      name: json["name"],
      address: json["address"],
      email: json["email"],
      phone: json["phone"],
      role: json["role"] ?? '',
      docid: doc_id,
      fullname: json["fullname"] ?? '');

  Map<String, dynamic> toJson() => {"name": name, "address": address, "email": email, "phone": phone, "role": role, "fullname": fullname};

  Future<dynamic> add() async {
    return await contractors
        .doc(name)
        .set(toJson())
        .then((value) => Result.success("User Added successfully"))
        .onError((error, stackTrace) => Result.error(error));
  }
}
