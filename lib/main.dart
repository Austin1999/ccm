import 'package:ccm/auth/auth_route.dart';
import 'package:ccm/controllers/getControllers.dart';
import 'package:ccm/controllers/getx_controllers.dart' as getxcon;
import 'package:ccm/firebase_options.dart';
import 'package:ccm/models/quote.dart';
import 'package:ccm/widgets/quotation/payments.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/landing_page.dart';
import 'package:firebase_core/firebase_core.dart';

import 'pages/quotation_form.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Get.put(CountryController());
  Get.put(ContractorController());
  Get.put(ClientDashboardController());
  Get.put(getxcon.AuthController());
  Get.put(getxcon.SessionController());
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
      // routes: {
      //   '/': (p0) => AuthRouter(),
      //   // '/QuotationForm': (p0) => QuotationForm(),
      // },
      // home: PaymentForm(
      //   invoice: Invoice(number: 'QT', amount: 250, issuedDate: DateTime.now(), payments: [], credits: []),
      // ),
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
