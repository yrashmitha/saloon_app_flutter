import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helawebdesign_saloon/models/appointment.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:intl/intl.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final bool fromBookingPage;
  final SaloonAppointment appointment;

  AppointmentDetailsScreen({this.fromBookingPage = false, this.appointment});

  static String id = "appointment-details-screen";

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Appointment Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  color: kDeepBlue,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "${DateFormat.yMMMMEEEEd()
                              .format(appointment.dateTime.toDate())
                              .toString()} at ${DateFormat('kk:mm a').format(
                              appointment.dateTime.toDate())}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w700),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: getColor(appointment.status),
                                  borderRadius: BorderRadius.circular(40)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 5),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.check,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    Text(
                                      appointment.status,
                                      style:
                                      const TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: CircleAvatar(
                            radius: 40,
                            backgroundImage:
                            NetworkImage(appointment.saloonImage),
                          ),
                          title: Text(
                            appointment.saloonName,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(appointment.saloonContactNumber,
                              style: const TextStyle(color: Colors.white)),
                        ),
                        Icon(
                          FontAwesomeIcons.link,
                          color: Colors.white,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          leading: CircleAvatar(
                            radius: 40,
                            backgroundImage:
                            NetworkImage(appointment.userImage),
                          ),
                          title: Text(
                            appointment.userName,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(appointment.userContactNumber,
                              style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 400,
                  child: ListView.builder(
                      itemCount: appointment.bookedServices.length,
                      itemBuilder: (ctx, index) {
                        return Container(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                    appointment.bookedServices[index]['name'],style: const TextStyle(fontWeight: FontWeight.w500),),
                                trailing: Text(
                                    "Rs. ${appointment
                                        .bookedServices[index]['price']
                                        .toInt()
                                        .toStringAsFixed(2)}"),
                              ),
                              Divider(
                                color: kDeepBlue.withOpacity(0.3),
                                indent: 20,
                                thickness: .5,
                              )
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
          color: kDeepBlue.withOpacity(.2),
          height: MediaQuery
              .of(context)
              .size
              .height * .09,
          child: Center(
              child: Text(
                "Rs. ${appointment.price.toInt().toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ))),
    );
  }

  Color getColor(String status){
    String s = status.toLowerCase();
    if(s == 'pending'){
      return kMainYellowColor;
    }
    else if(s == 'accepted'){
      return Colors.greenAccent;
    }
    else{
      return Colors.redAccent;
    }
  }
}
