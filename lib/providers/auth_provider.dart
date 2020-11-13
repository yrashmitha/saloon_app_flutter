import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:helawebdesign_saloon/models/app_user.dart';

class AuthProvider with ChangeNotifier {
  AppUser _appUser;
  bool _isAuth = false;


  AppUser get currentUserx {
    return _appUser;
  }



  User get isAuth {
   if(_auth.currentUser!=null){
     _appUser = AppUser(_auth.currentUser.uid, _auth.currentUser.displayName, _auth.currentUser.email
         , _auth.currentUser.photoURL, _auth.currentUser.phoneNumber,false, _auth.currentUser.metadata.creationTime, _auth.currentUser.metadata.lastSignInTime);
   }
    return  _auth.currentUser;
  }

  // Future<bool> isLoggedIn() async {
  //   bool x = false;
  //   await _auth.authStateChanges().listen((User user) {
  //     if (user == null) {
  //       print('User is currently signed out!');
  //     } else {
  //       x = true;
  //       _appUser = AppUser(
  //           user.uid, user.displayName, user.email, user.photoURL, user.phoneNumber, false,user.metadata.creationTime,user.metadata.lastSignInTime);
  //       print('User is signed in!');
  //       // currentUser=AppUser(user.uid,user.displayName,user.photoURL,user.phoneNumber,user)
  //     }
  //   });
  //   return x;
  // }

  UserCredential _user;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fire = Firestore.instance;


  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> handleSignIn() async {

    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      _user = await _auth.signInWithCredential(credential);


      _appUser = AppUser(
          _user.user.uid,
          _user.user.displayName,
          _user.user.email,
          _user.user.photoURL,
          _user.user.phoneNumber,
          _user.additionalUserInfo.isNewUser,
        _user.user.metadata.lastSignInTime,
        _user.user.metadata.lastSignInTime
      );


      if(_user.additionalUserInfo.isNewUser){
        await addUser(_user.user.uid, _user.user.displayName, _user.user.photoURL, _user.user.phoneNumber,_user.user.email);
      }

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> signOutGoogle() async {
    await _googleSignIn.signOut().then((GoogleSignInAccount acc) => print(acc));
    await _auth.signOut();
    _appUser = null;
    _isAuth = false;
    notifyListeners();
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');


  Future<void> addUser(String uid, String name, String photoUrl,String phoneNumber,String email) {
    return users
        .doc(uid)
        .set({
      'id': uid,
      'name': name,
      'email' :email,
      'photo_url' : photoUrl,
      'phone_number' : phoneNumber
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateUser(number) async{
    String id= currentUserx.uId;
    await users
        .doc(id)
        .update({'phone_number': number})
        .then((value) => print("User Updated"))
        .catchError((error) => throw error);

    notifyListeners();
  }


}
