import 'package:ccm/auth/login.dart';
import 'package:ccm/controllers/currency_controller.dart';
import 'package:ccm/controllers/getControllers_list.dart';
import 'package:ccm/controllers/sessionController.dart';
import 'package:ccm/firebase_options.dart';
import 'package:ccm/pages/countries_list.dart';
// import 'package:ccm/services/firebase.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'pages/landing_page.dart';

void printWarning(String text) {
  print('\x1B[33m$text\x1B[0m');
}

void printNormal(String text) {
  print('\x1B[36m$text\x1B[0m');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(SessionController());
  Get.put(ContractorController());
  Get.put(CurrencyController());
  currencyController.syncResponse();
  Get.put(ClientController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Crystal Clear Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        secondaryHeaderColor: Color(0xFF29588c),
        cardTheme: CardTheme(color: Color(0xFFE8F3FA)),
      ),
      builder: (context, child) {
        return LandingPage(child: child ?? CountriesList());
      },
      home: GetBuilder(
          init: session,
          builder: (context) {
            if (session.auth.currentUser == null) {
              return SignIn();
            } else {
              return CountriesList();
            }
          }),
    );
  }
}
