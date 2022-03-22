import 'package:ccm/models/client.dart';
import 'package:ccm/models/contractor.dart';
import 'package:ccm/models/countries.dart';
import 'package:ccm/models/quotation.dart';
import 'package:ccm/models/user.dart' as userval;
import 'package:ccm/services/firebase.dart';
import 'package:get/get.dart';

import 'getx_controllers.dart';

class UserController extends GetxController {
  static UserController instance = Get.find();
  userval.User? user;
}

UserController userController = UserController.instance;

class SessionController extends GetxController {
  static SessionController instance = Get.find();
  userval.Session? session;

  Rx<bool?> get isLogin => session!.isLogin.obs;
}

SessionController sessionController = SessionController.instance;

class CountryController extends GetxController {
  static CountryController instance = Get.find();
  RxList<Country> countrylist = RxList<Country>([]);

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    countrylist.bindStream(getCountries());
  }

  Stream<List<Country>> getCountries() => countries.snapshots().map(
      (query) => query.docs.map((e) => Country.fromJson(e.data())).toList());
}

class ClientController extends GetxController {
  static ClientController instance = Get.find();
  RxList<Client> clientlist = RxList<Client>([]);

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    print('ready');
    clientlist.bindStream(getClients());
  }

  Stream<List<Client>> getClients() {
    print('ready');
    print(session.country);
    return countries
        .doc(session.country!.code)
        .collection('clients')
        .snapshots()
        .map((query) => query.docs.map((e) {
              print(session.country!.code);
              print(e.data());
              return Client.fromJson(e.data(), e.id);
            }).toList());
  }
}

class ContractorController extends GetxController {
  static ContractorController instance = Get.find();
  RxList<Contractor> contractorlist = RxList<Contractor>([]);

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    contractorlist.bindStream(getContractor());
  }

  Stream<List<Contractor>> getContractor() {
    return contractors
        .where('country', isEqualTo: session.country!.code)
        .snapshots()
        .map((query) => query.docs.map((e) {
              return Contractor.fromJson(e.data(), e.id);
            }).toList());
  }
}

class QuotationController extends GetxController {
  static QuotationController instance = Get.find();
  RxList<Quotation> quotionlist = RxList<Quotation>([]);

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    print('ready');
    quotionlist.bindStream(getQuotations());
  }

  Stream<List<Quotation>> getQuotations() {
    print('ready');
    print(session.country);
    return countries
        .doc(session.country!.code)
        .collection('quotations')
        .snapshots()
        .map((query) => query.docs.map((e) {
              print(session.country!.code);
              print(e.data());
              return Quotation.fromJson(e.data());
            }).toList());
  }
}
