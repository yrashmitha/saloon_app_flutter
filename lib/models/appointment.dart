import 'package:cloud_firestore/cloud_firestore.dart';

class SaloonAppointment {
  String appointmentId;
  String saloonId;
  String saloonName;
  String saloonContactNumber;
  String userId;
  String userName;
  String userContactNumber;
  String status;
  int price;
  String saloonImage;
  String userImage;
  Timestamp dateTime;
  bool isReviewed;
  List<dynamic> bookedServices;

  SaloonAppointment(
      this.appointmentId,
      this.saloonId,
      this.saloonName,
      this.saloonContactNumber,
      this.userId,
      this.userName,
      this.userContactNumber,
      this.status,
      this.price,
      this.userImage,
      this.saloonImage,
      this.dateTime,
      this.isReviewed,
      this.bookedServices);
}
