import 'package:ccm/controllers/getControllers_list.dart';
import 'package:ccm/models/countries.dart';
import 'package:ccm/models/usermodel.dart';

import 'package:ccm/services/firebase.dart';
import 'package:get/get.dart';

class SessionController extends GetxController {
  static SessionController instance = Get.find();
  @override
  onInit() {
    super.onInit();
    syncCountries();
    listenAuth();
  }

  UserModel? user;

  listenAuth() {
    auth.authStateChanges().listen((event) {
      if (event != null) {
        loadProfile(event);
      } else {
        user = null;
      }
      update();
    });
  }

  var auth = Auth();

  syncCountries() {
    getCountries().listen((event) {
      sessionCountries = event;
      update();
    });
  }

  loadProfile(User authUser) {
    userscollection.doc(authUser.uid).get().then((value) {
      if (value.exists) {
        user = UserModel.fromJson(value.data()!, value.id);
        setmyCountries();
      }
      update();
    });
  }

  Country? country;
  List<Country> sessionCountries = [];

  setCountry(value) {
    country = value;
  }

  setmyCountries() {
    myCountries =
        (user?.isAdmin ?? false) ? sessionCountries : sessionCountries.where((element) => (user?.country ?? []).contains(element.code)).toList();
    print(myCountries);
  }

  List<Country> myCountries = [];

  static Stream<List<Country>> getCountries() {
    var countrieslist = countries.snapshots().map((query) => query.docs.map((e) => Country.fromJson(e.data())).toList());
    return countrieslist;
  }
}

SessionController session = SessionController.instance;
ClientController clientController = ClientController.instance;
ContractorController contractorController = ContractorController.instance;
