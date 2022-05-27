import 'package:ccm/models/response.dart';
import 'package:ccm/services/firebase.dart';

UserModel clientFromJson(String str) => UserModel.fromJson(json.decode(str), '');

String clientToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.name,
    this.address,
    this.email,
    this.phone,
    this.fullname,
    this.docid,
    required this.isAdmin,
    required this.country,
    this.invoiceClient = false,
    this.invoiceContractor = false,
    this.quoteClient = false,
    this.quoteContractor = false,
    this.viewClient = false,
    this.viewContractor = false,
    this.viewDashboard = false,
  });

  String name;
  String? address;
  String? email;
  String? phone;
  bool isAdmin;
  String? fullname;
  String? docid;
  List<dynamic> country;
  bool invoiceContractor;
  bool invoiceClient;
  bool quoteClient;
  bool quoteContractor;
  bool viewClient;
  bool viewContractor;
  bool viewDashboard;

  factory UserModel.fromJson(Map<String, dynamic> json, docId) => UserModel(
        name: json["name"],
        address: json["address"],
        email: json["email"],
        phone: json["phone"],
        isAdmin: json["role"],
        docid: docId,
        fullname: json["fullname"] ?? '',
        invoiceContractor: json["invoiceContractor"] ?? true,
        invoiceClient: json["invoiceClient"] ?? true,
        quoteClient: json["quoteClient"] ?? true,
        quoteContractor: json["quoteContractor"] ?? true,
        country: (json["country"] ?? []),
        viewClient: json["viewClient"] ?? false,
        viewContractor: json["viewContractor"] ?? false,
        viewDashboard: json["viewDashboard"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "address": address,
        "email": email,
        "phone": phone,
        "role": isAdmin,
        "fullname": fullname,
        "country": country,
        "invoiceContractor": invoiceContractor,
        "invoiceClient": invoiceClient,
        "quoteClient": quoteClient,
        "quoteContractor": quoteContractor,
        "viewClient": viewClient,
        "viewContractor": viewContractor,
        "viewDashboard": viewDashboard
      };

  Future<dynamic> add() async {
    return await contractors
        .doc(name)
        .set(toJson())
        .then((value) => Result.success("User Added successfully"))
        .onError((error, stackTrace) => Result.error(error));
  }
}
