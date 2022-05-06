import 'package:ccm/main.dart';
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

  Stream<List<Country>> getCountries() {
    var countrieslist = countries.snapshots().map((query) => query.docs.map((e) => Country.fromJson(e.data())).toList());
    session.countries = countrylist;
    return countrieslist;
  }
}

class ClientController extends GetxController {
  static ClientController instance = Get.find();
  List<Client> get clientlist {
    var list = overAllClientList.where((element) => element.country == session.country?.code).toList();

    return list;
  }

  List<Client> overAllClientList = [];

  Iterable<Client> filteredClients(String? country) {
    if (country == null) {
      return overAllClientList;
    } else {
      return overAllClientList.where((element) => element.country == country);
    }
  }

  Client getIdByName(String name) {
    var client = clientlist.firstWhere((element) => element.name == name);

    return client;
  }

  @override
  void onInit() {
    listenAllClients();
    super.onInit();
  }

  listenAllClients() {
    firestore.collectionGroup('clients').snapshots().listen((event) {
      overAllClientList = event.docs.map((e) => Client.fromJson(e.data(), e.id)).toList();
    });
  }

  String getName(String id) {
    return overAllClientList.firstWhere((element) => element.docid == id).name;
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
        // .where('country', isEqualTo: session.country!.code)
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
    quotionlist.bindStream(getQuotations());
  }

  Stream<List<Quotation>> getQuotations() {
    return countries
        .doc(session.country!.code)
        .collection('quotations')
        // .where('isTrash', isEqualTo: false)
        .snapshots()
        .map((query) => query.docs.map((e) {
              return Quotation.fromJson(e.data(), e.id);
            }).toList());
  }
}

class ClientDashboardController extends GetxController {
  static ClientDashboardController instance = Get.find();
  RxMap<String, dynamic> clientpayment = RxMap<String, dynamic>();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    clientpayment.bindStream(getClientvalues());
  }

  Stream<Map<String, dynamic>> getClientvalues() {
    return firestore.collection('payments').doc('clienttotals').snapshots().map((event) => event.data()!);
  }
}
