import 'package:ccm/auth/auth_route.dart';
import 'package:ccm/auth/login.dart';
import 'package:ccm/controllers/currency_controller.dart';
import 'package:ccm/controllers/getControllers.dart';
import 'package:ccm/controllers/getx_controllers.dart';
import 'package:ccm/firebase_options.dart';
import 'package:ccm/pages/countries_list.dart';
import 'package:ccm/services/firebase.dart';
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

  // FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  // FirebaseDatabase.instance.useDatabaseEmulator('localhost', 9000);

  Get.put(CountryController());
  Get.put(ContractorController());
  Get.put(AuthController());
  Get.put(SessionController());
  Get.put(CurrencyController());
  currencyController.syncResponse();
  Get.put(ClientController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authController.auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            session.loadProfile();
            return GetMaterialApp(
              title: 'Crystal Clear Management',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                secondaryHeaderColor: Color(0xFF29588c),
                cardTheme: CardTheme(color: Color(0xFFE8F3FA)),

                // elevatedButtonTheme : ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: Color(0xFF29588C),))
              ),
              builder: (context, child) {
                return authController.auth.currentUser == null ? SignIn() : LandingPage(child: child ?? CountriesList());
              },
              home: authController.auth.currentUser == null ? SignIn() : CountriesList(),
              // home: Dashboard(),
            );
          } else {
            return GetMaterialApp(
              title: 'Crystal Clear Management',
              home: SignIn(),
            );
          }
        }
        return MaterialApp(home: const Scaffold(body: Center(child: CircularProgressIndicator())), color: Colors.white);
      },
    );
  }
}
