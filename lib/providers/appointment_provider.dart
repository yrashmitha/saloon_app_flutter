import 'dart:developer';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helawebdesign_saloon/models/appointment.dart';
import 'package:helawebdesign_saloon/models/service.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/providers/user_provider.dart';


class AppointmentProvider with ChangeNotifier {
  List<Service> _userSelectedServices = [];

  List<SaloonAppointment> _appointmentList = [];

  List<SaloonAppointment> _userAppointments = [];

  List<SaloonAppointment> get getAppointments {
    return [..._appointmentList];
  }

  List<SaloonAppointment> get getUserAppointments {
    return [..._userAppointments];
  }

  List<Service> get getUserSelectedService {
    return _userSelectedServices;
  }

  bool isServiceInTheArray(Service s) {
    var x = _userSelectedServices.contains(s);
    if (x != null) {
      return x;
    } else {
      return x;
    }
  }

  void addService(Service service) {
    if (_userSelectedServices.contains(service)) {}
    _userSelectedServices.add(service);
  }

  void removeService(Service s) {
    _userSelectedServices.remove(s);
    _userSelectedServices.forEach((element) {});
  }

  Future<void> getAppointmentsFromDb(String saloonId) async {
    List<SaloonAppointment> appList = [];
    await Firebase.initializeApp();
    await FirebaseFirestore.instance
        .collection('appointments')
        .orderBy('date_time')
        .where('date_time',
        isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 1)))
        .where('saloon_id', isEqualTo: saloonId)
        .get()
        .then((QuerySnapshot querySnapshot) =>
    {
      querySnapshot.docs.forEach((doc) {
        appList.add(SaloonAppointment(
            doc.id,
            doc.data()['saloon_id'],
            doc.data()['saloon_name'],
            doc.data()['saloon_contact_number'],
            doc.data()['user_id'],
            doc.data()['user_name'],
            doc.data()['user_contact_number'],
            doc.data()['status'],
            doc.data()['price'],
            doc.data()['user_image'],
            doc.data()['saloon_image'],
            doc.data()['date_time'],
            doc.data()['is_reviewed'] != null
                ? doc.data()['is_reviewed']
                : false,
            doc.data()['services']));
      })
    })
        .catchError((err) {
      print(err);
    });

    _appointmentList = appList;

    notifyListeners();
  }

  Future<SaloonAppointment> addAppointment(SaloonAppointment app,
      SaloonsProvider saloonsProvider,String token) async {
    var _id;
    _id = '${app.dateTime.toDate().toString()}@${app.saloonId}';

    List<Map<String, dynamic>> bookedServices = [];
    app.bookedServices.forEach((element) {
      bookedServices.add({'name': element.name, 'price': element.price});
    });

    try {
      UserProvider user = UserProvider();
      await user.getUser();
      String number = user.accountUser.phoneNumber == null
          ? 'Not Provided'
          : user.accountUser.phoneNumber;

      await FirebaseFirestore.instance.collection('appointments').doc(_id).set({
        'date_time': app.dateTime,
        'saloon_id': app.saloonId,
        'user_id': app.userId,
        'services': bookedServices,
        'price': app.price,
        'status': 'PENDING',
        'user_image': app.userImage,
        'saloon_image': app.saloonImage,
        'saloon_contact_number': saloonsProvider.selectedSaloon.contactNumber,
        'user_contact_number': number,
        'user_email': user.accountUser.email,
        'user_name': user.accountUser.name,
        'saloon_name': saloonsProvider.selectedSaloon.name,
        "user_token" : token,
      });

      SaloonAppointment s = SaloonAppointment(
          _id,
          app.saloonId,
          saloonsProvider.selectedSaloon.name,
          saloonsProvider.selectedSaloon.contactNumber,
          app.userId,
          user.accountUser.name,
          number,
          'PENDING',
          app.price,
          app.userImage,
          app.saloonImage,
          app.dateTime,
          app.isReviewed,
          bookedServices);
      clearServices();
      return s;
    } on PlatformException catch (e) {
      print("i got err from fb ${e.message}");
      return null;
    }
  }

  void clearServices() {
    _userSelectedServices = [];
  }

  Future<bool> getAppointmentsBelongsToUser(bool refresh) async {
    if (refresh) {
      print('i am running');
      runThisFunction();
      return true;
    }
    else {
      if (_userAppointments.length > 0) {
        return false;
      }
      else {
        runThisFunction();
        return false;
      }
    }
  }


  Future<void> runThisFunction() async {
    List<SaloonAppointment> appList = [];
    print('appointment getting');
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('appointments')
        .orderBy('date_time')
        .where('user_id', isEqualTo: user.uid)
        .get()
        .then((QuerySnapshot querySnapshot) =>
    {
      querySnapshot.docs.forEach((doc) {
        print(doc.id);
        appList.add(SaloonAppointment(
            doc.id,
            doc.data()['saloon_id'],
            doc.data()['saloon_name'],
            doc.data()['saloon_contact_number'],
            doc.data()['user_id'],
            doc.data()['user_name'],
            doc.data()['user_contact_number'],
            doc.data()['status'],
            doc.data()['price'],
            doc.data()['user_image'],
            doc.data()['saloon_image'],
            doc.data()['date_time'],
            doc.data()['is_reviewed'] != null
                ? doc.data()['is_reviewed']
                : false,
            doc.data()['services']));
      })
    })
        .catchError((err) {
      print(err);
    });

    _userAppointments = appList;
    print(_userAppointments.length);

    notifyListeners();
  }


  Future<bool> cancelAppointment(String id) async {
    log("hi");
    try {
      await FirebaseFirestore.instance.collection('appointments')
          .doc(id)
          .update({'status': 'CANCELLED'})
          .then((_) {
        return true;
      })
          .catchError((e) {
        throw e;
      });
    } on PlatformException catch (e) {
      throw e;
    }
    return false;
  }

  Future<bool> markAsCompleteAppointment(String id) async {
    try {
      var res = await FirebaseFirestore.instance.collection('appointments')
          .doc(id)
          .update({'status': 'COMPLETED'})
          .then((_) {
        return true;
      })
          .catchError((e) {
        throw e;
      });

      if(res){
        return true;
      }
      else {
        return false;
      }
    } on PlatformException catch (e) {
      throw e;
    }

  }


  Future<void> postReview(BuildContext context, int star, String review,
      String appointmentId, String saloonId) async {

    final db = FirebaseFirestore.instance;

    var appointmentRef= db.collection("appointments/").doc(appointmentId);
    var saloonRef = db.collection("saloons").doc(saloonId);

    try {

      var res = await FirebaseFirestore.instance.collection("appointments/")
          .doc(appointmentId)
          .update({
        'review': {
          'user_name': FirebaseAuth.instance.currentUser.displayName,
          'user_profile_avatar': FirebaseAuth.instance.currentUser.photoURL,
          'date': Timestamp.now(),
          'star': star,
          'customer_review': review,
          'appointment_id': appointmentId
        },
        'is_reviewed': true
      });

      var second = await FirebaseFirestore.instance.collection("saloons/$saloonId/all_reviews")
          .add({
        'user_name': FirebaseAuth.instance.currentUser.displayName,
        'user_profile_avatar': FirebaseAuth.instance.currentUser.photoURL,
        'date': Timestamp.now(),
        'star': star,
        'customer_review': review,
        'appointment_id': appointmentId
      });


      db.runTransaction((transaction){
        return transaction.get(saloonRef).then((saloon){
          var newNumRatings = saloon.data()['ratings_count'] + 1;

          // Compute new average rating
          var oldRatingTotal = saloon.data()['rating'] * saloon.data()['ratings_count'];
          var newAvgRating = (oldRatingTotal + star) / newNumRatings;


          transaction.update(saloonRef, {
            "ratings_count": newNumRatings,
            "rating": newAvgRating
          });
        });
      }).then((value) => print('transaction ok')).catchError((e){
        print(e);
          });

    } on PlatformException catch (e) {
      throw e;
    }
  }


  SaloonAppointment dummyAppointment = SaloonAppointment(
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      0,
      "",
      "",
      null,
      false,
      []);
  Future<void> getThisAppointmentDetails(String id) async {
    log("Appointment getting running");

    var res = await FirebaseFirestore.instance.collection('appointments').doc(id).get().then((doc) {
      dummyAppointment.appointmentId = doc.id;
      dummyAppointment.saloonId = doc.data()['saloon_id'];
      dummyAppointment.saloonName = doc.data()['saloon_name'];
      dummyAppointment.saloonContactNumber = doc.data()['saloon_contact_number'];
      dummyAppointment.userId = doc.data()['user_id'];
      dummyAppointment.userName = doc.data()['user_name'];
      dummyAppointment.userContactNumber = doc.data()['user_contact_number'];
      dummyAppointment.status = doc.data()['status'];
      dummyAppointment.price = doc.data()['price'];
      dummyAppointment.userImage = doc.data()['user_image'];
      dummyAppointment.saloonImage = doc.data()['saloon_image'];
      dummyAppointment.dateTime = doc.data()['date_time'];
      dummyAppointment.isReviewed = doc.data()['is_reviewed'] != null ? doc.data()['is_reviewed'] : false;
      dummyAppointment.bookedServices = doc.data()['services'];

      notifyListeners();
    }).catchError((err) {
    print(err);
    });
  }

}


class ServiceDetails {
  String name;
  int price;

  ServiceDetails(this.name, this.price);
}
