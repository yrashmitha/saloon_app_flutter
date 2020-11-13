import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/app_user.dart';

class UserProvider with ChangeNotifier {

  AppUser _appUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');


  Future<void> getUser() async{
    await users.doc(_auth.currentUser.uid).get().then((DocumentSnapshot value) {
      _appUser= AppUser(_auth.currentUser.uid, _auth.currentUser.displayName, _auth.currentUser.email
          , _auth.currentUser.photoURL, value['phone_number'],false, _auth.currentUser.metadata.creationTime, _auth.currentUser.metadata.lastSignInTime);
    });


    //print("app user ${_appUser.photoUrl}");

  }

  Future<void> updateUser(number) async{
    print('update user called');
    String id= _auth.currentUser.uid;
    await users
        .doc(id)
        .update({'phone_number': number})
        .then((value) {
          _appUser.phoneNumber = number;
    })
        .catchError((error) => throw error);

    notifyListeners();

  }

  AppUser get accountUser{
    return _appUser;
  }
}