import 'package:ccm/auth/auth_route.dart';
import 'package:ccm/controllers/currency_controller.dart';
import 'package:ccm/controllers/dashboard.dart';
import 'package:ccm/controllers/getControllers.dart';
import 'package:ccm/controllers/getx_controllers.dart' as getxcon;
import 'package:ccm/firebase_options.dart';
// import 'package:ccm/services/firebase.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

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
  Get.put(ClientDashboardController());
  Get.put(getxcon.AuthController());
  Get.put(getxcon.SessionController());
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
        // elevatedButtonTheme : ElevatedButtonThemeData(style: ButtonStyle(backgroundColor: Color(0xFF29588C),))
      ),
      home: AuthRouter(),
      // home: Dashboard(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    Scaffold.of(context).openDrawer();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
