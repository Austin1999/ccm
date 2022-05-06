import 'package:ccm/controllers/getControllers.dart';
import 'package:ccm/models/countries.dart';
import 'package:ccm/models/usermodel.dart';

import 'package:ccm/services/firebase.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  var auth = Auth();
}

class SessionController extends GetxController {
  static SessionController instance = Get.find();

  UserModel? user;

  loadProfile() {
    if (authController.auth.currentUser != null) {
      userscollection.doc(authController.auth.currentUser!.uid).get().then((value) {
        if (value.exists) {
          user = UserModel.fromJson(value.data()!, value.id);

          if (user?.role == "Admin") {
            myCountries = countryController.countrylist.toList();
          } else {
            var list = countryController.countrylist.toList();
            myCountries = user!.country.map((e) => list.firstWhere((element) => element.code == e)).toList();
            print(myCountries);
          }
        }
        update();
      });
    }
  }

  Country? country;
  List<Country> countries = [];

  setCountry(value) {
    country = value;
  }

  List<Country> myCountries = [];

  // void loadClients() {
  //   Client.list().then((value) => clients = value);
  // }
}

SessionController session = SessionController.instance;
ClientController clientController = ClientController.instance;
CountryController countryController = CountryController.instance;
AuthController authController = AuthController.instance;
ContractorController contractorController = ContractorController.instance;
