export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:cloud_functions/cloud_functions.dart';
export 'package:firebase_auth/firebase_auth.dart';

export 'dart:convert';
export './auth.dart';

import 'dart:io';

import 'package:ccm/controllers/getx_controllers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

final databaseRef = FirebaseDatabase.instance.ref();
// final databaseRef = FirebaseDatabase.instance.refFromURL("http://localhost:9000/?ns=ccm-web-4cd3d");
final FirebaseFunctions functions = FirebaseFunctions.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

// CollectionReference<Map<String, dynamic>> users = firestore.collection('Users');
// CollectionReference<Map<String, dynamic>> clients = firestore.collection('Clients');
CollectionReference<Map<String, dynamic>> contractors = firestore.collection('Contractors');
CollectionReference<Map<String, dynamic>> countries = firestore.collection('Countries');
CollectionReference<Map<String, dynamic>> userscollection = firestore.collection('Users');
CollectionReference<Map<String, dynamic>> payablesRef = firestore.collection('Payables');
CollectionReference<Map<String, dynamic>> receivablesRef = firestore.collection('Receivables');
CollectionReference<Map<String, dynamic>> dashboardDataRef = firestore.collection('DashboardData');
CollectionReference<Map<String, dynamic>> clients(code) => countries.doc(code).collection("clients");
DocumentReference<Map<String, dynamic>> counters = firestore.collection('Dashboard').doc('counters');

CollectionReference<Map<String, dynamic>> get quotations => countries.doc(session.country!.code).collection('quotations');

// countries
//                             .doc(session.country!.code)
//                             .collection('quotations')

Future<String> uploadFile(File file) async {
  var url = await storage.ref("pics").child(basename(file.path)).putBlob(file.readAsBytes()).snapshot.ref.getDownloadURL();
  return url;
}

Future<String> getNextQuotationId() async {
  int id = 0;
  await firestore.runTransaction((transaction) async {
    var counter = (await transaction.get(counters)).data();
    id = (counter?['quotation'] ?? 0) + 1;
    transaction.update(counters, {'quotation': id});
    return transaction;
  });
  return id.toString();
}

Future<String> getNextClientId() async {
  int id = 0;
  await firestore.runTransaction((transaction) async {
    var counter = (await transaction.get(counters)).data();
    id = (counter?['client'] ?? 0) + 1;
    transaction.update(counters, {'client': id});
    return transaction;
  });
  return id.toString();
}

Future<String> getNextContractorID() async {
  int id = 0;
  await firestore.runTransaction((transaction) async {
    var counter = (await transaction.get(counters)).data();

    id = (counter?['contractor'] ?? 0) + 1;
    transaction.update(counters, {'contractor': id});
    return transaction;
  });
  return id.toString();
}
