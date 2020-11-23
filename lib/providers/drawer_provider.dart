import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DrawerProvider with ChangeNotifier {

  String location="";
  String gender="";
  String category="";
  String searchByName="";


  Query searchQuery(String city, String category, String gender){
    log("$city $category $gender from search query");

    if (city == "") {
          city = null;
        }
        if (category == "") {
          category = null;
        }
        if (gender == "") {
          gender = null;
        }
    return FirebaseFirestore.instance
        .collection('saloons')
        .where('base_location', isEqualTo: city).
    where('gender', isEqualTo: gender).
    where(
        'categories', arrayContainsAny: category == null ? null : [category]).orderBy('rating',descending: true);
  }

  Query nameSearch(String name){
    return FirebaseFirestore.instance
        .collection('saloons') .orderBy('rating', descending: true)
        .where('lower_case', isEqualTo: name);
  }

  void clearDefaults(){
    location="";
    gender="";
    category="";
  }

}