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

  bool invoiceContractor = false;
  bool invoiceClient = false;
  bool quoteClient = false;
  bool quoteContractor = false;

  bool viewClient = false;
  bool viewContractor = false;
  bool viewDashboard = false;

  factory UserFormController.fromUser(UserModel user) {
    var userform = UserFormController();
    userform.address.text = user.address ?? '';
    userform.email.text = user.email ?? '';
    userform.name.text = user.name;
    userform.phone.text = user.phone ?? '';
    userform.docid = user.docid;
    userform.isAdmin = user.role;
    userform.country = user.country;

    userform.invoiceClient = user.invoiceClient;
    userform.invoiceContractor = user.invoiceContractor;
    userform.quoteClient = user.quoteClient;
    userform.quoteContractor = user.quoteContractor;

    userform.viewClient = user.viewClient;
    userform.viewContractor = user.viewContractor;
    userform.viewDashboard = user.viewDashboard;

    return userform;
  }

  UserModel get object => UserModel(
        name: name.text,
        country: country,
        address: address.text,
        role: isAdmin,
        docid: docid,
        email: email.text,
        fullname: name.text,
        phone: phone.text,
        invoiceClient: invoiceClient,
        invoiceContractor: invoiceContractor,
        quoteClient: quoteClient,
        quoteContractor: quoteContractor,
        viewClient: viewClient,
        viewContractor: viewContractor,
        viewDashboard: viewDashboard,
      );
}
