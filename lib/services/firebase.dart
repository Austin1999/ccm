export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:cloud_functions/cloud_functions.dart';
export 'package:firebase_auth/firebase_auth.dart';

export 'dart:convert';
export './auth.dart';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

final databaseRef = FirebaseDatabase.instance.refFromURL(
    "https://ccm-web-4cd3d-default-rtdb.asia-southeast1.firebasedatabase.app/");
final FirebaseFunctions functions = FirebaseFunctions.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage.instance;
final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

CollectionReference<Map<String, dynamic>> users = firestore.collection('Users');
// CollectionReference<Map<String, dynamic>> clients = firestore.collection('Clients');
CollectionReference<Map<String, dynamic>> contractors =
    firestore.collection('Contractors');
CollectionReference<Map<String, dynamic>> countries =
    firestore.collection('Countries');
CollectionReference<Map<String, dynamic>> userscollection =
    firestore.collection('Users');
CollectionReference<Map<String, dynamic>> clients(code) =>
    countries.doc(code).collection("clients");
DocumentReference<Map<String, dynamic>> counters =
    firestore.collection('globalData').doc('counters');

Future<String> uploadFile(File file) async {
  var url = await storage
      .ref("pics")
      .child(basename(file.path))
      .putBlob(file.readAsBytes())
      .snapshot
      .ref
      .getDownloadURL();
  return url;
}
