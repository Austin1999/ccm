import 'package:ccm/controllers/getControllers.dart';
import 'package:ccm/models/countries.dart';

import 'package:ccm/services/auth.dart';
import 'package:get/get.dart';

import '../models/client.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  var auth = Auth();
}

AuthController authController = AuthController.instance;

class SessionController extends GetxController {
  static SessionController instance = Get.find();
  Country? country;
  List<Country> countries = [];
  // List<Client> clients = [];
  setCountry(value) {
    country = value;
    // loadClients();
  }

  // void loadClients() {
  //   Client.list().then((value) => clients = value);
  // }
}

SessionController session = SessionController.instance;
ClientController clientController = ClientController.instance;
CountryController countryController = CountryController.instance;
QuotationController quotationController = QuotationController.instance;
ContractorController contractorController = ContractorController.instance;
ClientDashboardController clientDashboardController =
    ClientDashboardController.instance;
