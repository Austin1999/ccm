import 'package:ccm/controllers/sessionController.dart';
import 'package:ccm/services/firebase.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CurrencyController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    syncResponse();
  }

  Map<String, dynamic> rates = {};

  Future<void> syncResponse() async {
    var url = Uri.parse("https://data.fixer.io/api/latest?access_key=2ed058cc1407cbcf2e365cee5e9ac211");
    var response = await http.get(url);
    var body = jsonDecode(response.body);
    rates = body["rates"];
    update();
    return;
  }

  double convert(double number, String from, String to) {
    double exchangRate = rates[to] / rates[from];
    return number * exchangRate;
  }

  String get sessionCurrency => rates[session.country?.currencyCode];

  List<DropdownMenuItem<String>> get items => rates.keys
      .map((e) => DropdownMenuItem(
            child: Text(e.toString()),
            value: e,
          ))
      .toList();

  static CurrencyController instance = Get.find();
}

CurrencyController currencyController = CurrencyController.instance;

extension CurrencyConversion on double {
  double convert(String fromCode, String toCode) {
    var number = this;
    var convertedNumber = currencyController.convert(number, fromCode, toCode);
    return convertedNumber;
  }
}
