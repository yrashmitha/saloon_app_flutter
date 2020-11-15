import 'package:cloud_firestore/cloud_firestore.dart';

class SaloonAppointment{
  String appointmentId;
  String saloonId;
  String userId;
  String status;
  int price;
  Timestamp dateTime;
  List<dynamic> bookedServices;

  SaloonAppointment(this.appointmentId, this.saloonId, this.userId, this.dateTime,
      this.bookedServices);

}