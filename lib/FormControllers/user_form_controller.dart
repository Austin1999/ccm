import 'package:ccm/models/countries.dart';
import 'package:ccm/models/usermodel.dart';
import 'package:flutter/cupertino.dart';

class UserFormController {
  final name = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final phone = TextEditingController();
  List<Country> country = [];
  bool isAdmin = false;
  String? docid;
  UserFormController();

  bool invoiceContractor = false;
  bool invoiceClient = false;
  bool quoteClient = false;
  bool quoteContractor = false;

  bool viewClient = false;
  bool viewContractor = false;
  bool viewDashboard = false;

  final formKey = GlobalKey<FormState>();

  factory UserFormController.fromUser(UserModel user) {
    var userform = UserFormController();
    userform.address.text = user.address ?? '';
    userform.email.text = user.email ?? '';
    userform.name.text = user.name;
    userform.phone.text = user.phone ?? '';
    userform.docid = user.docid;
    userform.isAdmin = user.isAdmin;
    userform.country = user.country.map((e) => Country.countries.firstWhere((element) => element.code == e)).toList();

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
        address: address.text,
        isAdmin: isAdmin,
        docid: docid,
        email: email.text,
        fullname: name.text,
        phone: phone.text,
        invoiceClient: isAdmin ? isAdmin : invoiceClient,
        invoiceContractor: isAdmin ? isAdmin : invoiceContractor,
        quoteClient: isAdmin ? isAdmin : quoteClient,
        quoteContractor: isAdmin ? isAdmin : quoteContractor,
        viewClient: isAdmin ? isAdmin : viewClient,
        viewContractor: isAdmin ? isAdmin : viewContractor,
        viewDashboard: isAdmin ? isAdmin : viewDashboard,
        country: country.map((e) => e.code).toList(),
      );
}
