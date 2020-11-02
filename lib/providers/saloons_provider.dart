import 'dart:wasm';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:helawebdesign_saloon/models/saloon.dart';

class SaloonsProvider with ChangeNotifier {
  List<Saloon> _saloons = [
    // Saloon(
    //     "1",
    //     "Saloon Dmesh Bar",
    //     "https://firebasestorage.googleapis.com/v0/b/saloonapp-c93ca.appspot.com/o/saloon.jpg?alt=media&token=60417afe-6cbc-4933-a5b7-bd2504f687e4",
    //     "Small description",
    //     "Kandana",
    //     "No 170 Batagama South Kandana",
    //     "Male only",
    //     null,
    //     null),
    // Saloon(
    //     "2",
    //     "Saloon Nipuni",
    //     "https://firebasestorage.googleapis.com/v0/b/saloonapp-c93ca.appspot.com/o/image3.jpg?alt=media&token=cad3e4ef-64ee-486c-b64c-7a7e7e927d72",
    //     "Small description for nipuni's saloon",
    //     "Kottawa",
    //     "No 170 Batagama South Kandana",
    //     "Female only",
    //     null,
    //     null)
  ];

  String _name = "Yohan";

  String get name {
    return _name;
  }

  List<Saloon> get getSaloons {
    return _saloons;
  }

  Future<void> getSaloonsData() async {
    List<Saloon> sList = [];
    await Firebase.initializeApp();
    await FirebaseFirestore.instance.collection('saloons').get().then((QuerySnapshot querySnapshot) =>
    {
      querySnapshot.docs.forEach((doc) {
        print(doc.data());
        sList.add(Saloon(
            doc.id,
            doc["name"],
            doc["main-image_url"],
            doc["description"],
            doc["base_location"],
            doc["address"],
            doc["gender"],
            doc["additional_data"],
            doc["services"]));
      })
    });

    _saloons = sList;

    notifyListeners();

  }
}
