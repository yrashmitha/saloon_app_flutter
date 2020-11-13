import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/appointment.dart';
import 'package:helawebdesign_saloon/models/service.dart';

class AppointmentProvider with ChangeNotifier{

  List<Service> _userSelectedServices=[];

  List<SaloonAppointment> _appointmentList=[];

  List<SaloonAppointment> get getAppointments{
    return [..._appointmentList];
  }

  Future<void> getAppoinmentsFromDb() async {
    List<SaloonAppointment> appList = [];
    await Firebase.initializeApp();
    await FirebaseFirestore.instance.collection('appointments').where('date_time',isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days: 1)))
        .get().then((QuerySnapshot querySnapshot) =>
    {
      querySnapshot.docs.forEach((doc) {
        appList.add(SaloonAppointment(doc.id, doc.data()['saloon_id'], doc.data()['user_id'], doc.data()['date_time'], doc.data()['services']));
      })
    }).catchError((err){
      print(err);
    });

    _appointmentList = appList;

    notifyListeners();
  }

  List<Service> get getUserSelectedService { return _userSelectedServices;}

  void addService(Service service){
    _userSelectedServices.add(service);
  }

  void removeService(Service s){
    _userSelectedServices.remove(s);
  }

}