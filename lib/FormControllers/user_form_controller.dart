import 'package:ccm/models/usermodel.dart';
import 'package:flutter/cupertino.dart';

class UserFormController {
  final name = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final phone = TextEditingController();
  List<dynamic> country = [];
  var isAdmin;
  String? docid;
  UserFormController();

  factory UserFormController.fromUser(UserModel user) {
    var userform = UserFormController();
    userform.address.text = user.address ?? '';
    userform.email.text = user.email ?? '';
    userform.name.text = user.name;
    userform.phone.text = user.phone ?? '';
    userform.docid = user.docid;
    userform.isAdmin = user.role == "Admin";
    userform.country = user.country;

    return userform;
  }

  UserModel get object => UserModel(
        name: name.text,
        country: country,
        address: address.text,
        role: isAdmin ? "Admin" : "User",
        docid: docid,
        email: email.text,
        fullname: name.text,
        phone: phone.text,
      );
}
