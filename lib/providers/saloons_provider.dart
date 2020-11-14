import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helawebdesign_saloon/models/saloon.dart';
import 'package:helawebdesign_saloon/models/service.dart';

class SaloonsProvider with ChangeNotifier {
  List<Saloon> _saloons = [];

  Saloon _selectedSaloon;

  List<Service> allServices = [];

  List<Saloon> get getSaloons {
    return _saloons;
  }

  Saloon get selectedSaloon => _selectedSaloon;

  void setSelectedSaloon(Saloon value) {
    print("saloon setted");
    _selectedSaloon = value;
  }

  List<Service> get getAllService => allServices;

  void setAllService(List<dynamic> value) {
    print("saloon setted");
    allServices = value;
  }

  List<Service> returnMyServicesArray(List arr) {
    List<Service> sList = [];
    arr.forEach((element) {
      sList.add(Service(
          id: element['id'],
          name: element['name'],
          description: element['description'],
          price: element['price']));
    });
    return sList;
  }

  Future<void> getSaloonsData(bool refresh) async {
    print("get saloon runnig");
    List<Saloon> sList = [];
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection('saloons')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              print("getting saloon finished"),
              querySnapshot.docs.forEach((doc) {
                sList.add(
                  Saloon(
                      doc.id,
                      doc.data()["name"],
                      doc.data()["main-image_url"],
                      doc.data()["description"],
                      doc.data()["base_location"],
                      doc.data()["address"],
                      doc.data()["gender"],
                      doc.data()["additional_data"],
                      doc.data()['appointment_interval'],
                      returnMyServicesArray(doc.data()["services"]),
                      doc.data()['gallery'] == null
                          ? []
                          : doc.data()['gallery'],
                      doc.data()['reviews'] == null
                          ? []
                          : doc.data()['reviews']),
                );
              })
            });

    _saloons = sList;

    notifyListeners();
  }

  Future<void> getAllServicesFromThisSaloon(String saloonId) async {
    List<Service> sList = [];
    await Firebase.initializeApp();
    try {
      await FirebaseFirestore.instance
          .collection('saloons/$saloonId/all_services')
          .get()
          .then((QuerySnapshot querySnapshot) => {
                querySnapshot.docs.forEach((doc) {
                  sList.add(Service(
                      id: doc.id,
                      name: doc['name'],
                      description: doc['description'],
                      price: doc['price']));
                })
              })
          .catchError((onError) {
        print(onError);
      });
      allServices = sList;
      notifyListeners();
    } on PlatformException catch (e) {
      print(e.code);
    }
  }

  Future getAllSaloonGallery() async {
    List<String> list = [];
    try {
      return await FirebaseFirestore.instance
          .collection('saloons/${selectedSaloon.id}/all_images')
          .get()
          .then((value) {
        value.docs.forEach((e) {
          list.add(e['url']);
        });
        return list;
      }).catchError((err) {
        throw err;
      });
    } catch (err) {
      throw err;
    }
  }

  Future getAllReviews() async {
    List<dynamic> list = [];
    try {
      return await FirebaseFirestore.instance
          .collection('saloons/${selectedSaloon.id}/all_reviews')
          .get()
          .then((value) {
        value.docs.forEach((e) {
          list.add(e);
        });
        return list;
      }).catchError((err) {
        throw err;
      });
    } catch (err) {
      throw err;
    }
  }
}
