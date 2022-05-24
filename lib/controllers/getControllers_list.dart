import 'package:ccm/models/client.dart';
import 'package:ccm/models/contractor.dart';
import 'package:ccm/services/firebase.dart';
import 'package:get/get.dart';

import 'sessionController.dart';

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
  List<Contractor> get contractorlist {
    var list = overAllContractorList.where((element) => element.country == session.country?.code).toList();
    return list;
  }

  List<Contractor> overAllContractorList = [];

  Iterable<Contractor> filteredcontractors(String? country) {
    if (country == null) {
      return overAllContractorList;
    } else {
      return overAllContractorList.where((element) => element.country == country);
    }
  }

  Contractor getIdByName(String name) {
    var contractor = contractorlist.firstWhere((element) => element.name == name);

    return contractor;
  }

  @override
  void onInit() {
    listenAllcontractors();
    super.onInit();
  }

  listenAllcontractors() {
    contractors.snapshots().listen((event) {
      overAllContractorList = event.docs.map((e) => Contractor.fromJson(e.data(), e.id)).toList();
    });
  }

  String getName(String id) {
    return overAllContractorList.firstWhere((element) => element.docid == id).name;
  }
}
