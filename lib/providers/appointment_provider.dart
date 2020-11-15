import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/appointment.dart';
import 'package:helawebdesign_saloon/models/service.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentProvider with ChangeNotifier{

   List<Service> _userSelectedServices=[];

  List<SaloonAppointment> _appointmentList=[];

  List<SaloonAppointment> get getAppointments{
    return [..._appointmentList];
  }

  List<Service> get getUserSelectedService { return _userSelectedServices;}

  bool isServiceInTheArray(Service s){
    var x= _userSelectedServices.contains(s);
   if(x!=null){
      return x;
   }
   else{
     return x;
   }


  }

  void addService(Service service){
    if(_userSelectedServices.contains(service)){
      print('service added already in the box');
    }
    print('service added');
    _userSelectedServices.add(service);
    print('$_userSelectedServices');
  }

  void removeService(Service s){
    print('we have to remove service id ${s.id}');
    _userSelectedServices.remove(s);
    _userSelectedServices.forEach((element) {
      print('${element.id}');});
  }

  Future<void> getAppointmentsFromDb() async {

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

  Future<void> addAppointment(SaloonAppointment app) async{
    var _id;
    _id = '${app.dateTime.toDate().toString()}@${app.saloonId}';


    List<Map<String,dynamic>> bookedServices=[];
    app.bookedServices.forEach((element) {
      bookedServices.add({
        'name' : element.name,
        'price' : element.price
      });
    });


    //
    // try{
    //   await FirebaseFirestore.instance.collection('appointments').doc(_id)
    //       .set({
    //     'date_time' : app.dateTime,
    //     'saloon_id' : app.saloonId,
    //     'user_id' : app.userId,
    //     'services' : bookedServices,
    //     'price' : app.price,
    //     'status' : 'PENDING'
    //   }).catchError((e)=>print(e));
    // }
    // catch(e){
    //   throw e;
    // }

  }

  void clearServices(){
    _userSelectedServices=[];
  }

}


class ServiceDetails{
  String name;
  int price;

  ServiceDetails(this.name,this.price);

}