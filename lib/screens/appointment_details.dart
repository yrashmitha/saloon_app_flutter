import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helawebdesign_saloon/common_functions/functions.dart';
import 'package:helawebdesign_saloon/models/appointment.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/providers/appointment_provider.dart';
import 'package:helawebdesign_saloon/widgets/appointent_review.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppointmentDetailsScreen extends StatefulWidget {
  final bool fromBookingPage;
  final SaloonAppointment appointment;

  AppointmentDetailsScreen({this.fromBookingPage = false, this.appointment});

  static String id = "appointment-details-screen";

  @override
  _AppointmentDetailsScreenState createState() =>
      _AppointmentDetailsScreenState();
}

class _AppointmentDetailsScreenState extends State<AppointmentDetailsScreen> {
  var cancelButton = false;
  var localReviewed=false;

  @override
  Widget build(BuildContext context) {

    final media = MediaQuery.of(context).size;
    final provider = Provider.of<AppointmentProvider>(context);

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
                Stack(overflow: Overflow.visible, children: [
                  Container(
                    color: kDeepBlue,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            "${DateFormat.yMMMMEEEEd().format(widget.appointment.dateTime.toDate()).toString()} at ${DateFormat('kk:mm a').format(widget.appointment.dateTime.toDate())}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w700),
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: getColor(widget.appointment.status),
                                    borderRadius: BorderRadius.circular(40)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        getIcon(widget.appointment.status),
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      Text(
                                        widget.appointment.status,
                                        style: const TextStyle(
                                            color: Colors.white),
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
                                  NetworkImage(widget.appointment.saloonImage),
                            ),
                            title: Text(
                              widget.appointment.saloonName,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                                widget.appointment.saloonContactNumber,
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
                                  NetworkImage(widget.appointment.userImage),
                            ),
                            title: Text(
                              widget.appointment.userName,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(widget.appointment.userContactNumber,
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget.appointment.status == "PENDING" ||
                          widget.appointment.status == "ACCEPTED"
                      ? Positioned(
                          bottom: -25,
                          right: 0,
                          child: Container(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(100.0),
                                    border: Border.all(
                                        width: 2, color: Colors.white),
                                  ),
                                  child: Builder(
                                    builder: (ctx) {
                                      return Row(
                                        children: [
                                          widget.appointment.status == "ACCEPTED" ?
                                          FloatingActionButton(
                                            onPressed: () {},
                                            child: Icon(Icons.check),
                                            tooltip: 'Mark as complete',
                                            backgroundColor: Colors.blueAccent,
                                            heroTag: null,
                                          )
                                          :SizedBox(),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          FloatingActionButton(
                                            onPressed: () {
                                              var s = SnackBar(
                                                content: Text(
                                                    "You cancelled the appointment"),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              );
                                              print("pressed");
                                              setState(() {
                                                cancelButton = true;
                                              });
                                              provider
                                                  .cancelAppointment(widget
                                                      .appointment
                                                      .appointmentId)
                                                  .then((_) {
                                                setState(() {
                                                  cancelButton = false;
                                                });
                                                Scaffold.of(ctx)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Appointment cancelled."),
                                                  behavior:
                                                      SnackBarBehavior.floating,
                                                ));
                                              });
                                            },
                                            heroTag: null,
                                            backgroundColor: Colors.redAccent,
                                            tooltip: 'Cancel Appointment',
                                            child: cancelButton
                                                ? CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation(
                                                            Colors.white),
                                                  )
                                                : Icon(Icons.clear),
                                          ),

                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : SizedBox(),

                  widget.appointment.status == "COMPLETED" && widget.appointment.isReviewed==false && localReviewed==false?
                  Positioned(
                    bottom: -25,
                    right: 0,
                    child: Container(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100.0),
                              border: Border.all(
                                  width: 2, color: Colors.white),
                            ),
                            child: Builder(
                              builder: (ctx) {
                                return Row(
                                  children: [
                                    FloatingActionButton(
                                      onPressed: (){
                                        _showAlert(ctx,widget.appointment.appointmentId,widget.appointment.saloonId)
                                        .then((value){
                                          // setState(() {
                                          //   localReviewed = value;
                                          // });
                                        });
                                      },
                                      heroTag: null,
                                      backgroundColor: Colors.redAccent,
                                      tooltip: 'Enter a review about your experience',
                                      child: Icon(Icons.star,color: Color(0XFFFFD700),size: 30,),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                      : SizedBox(),

                ]),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 400,
                  child: ListView.builder(
                      itemCount: widget.appointment.bookedServices.length,
                      itemBuilder: (ctx, index) {
                        return Container(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  widget.appointment.bookedServices[index]
                                      ['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                trailing: Text(
                                    "Rs. ${widget.appointment.bookedServices[index]['price'].toInt().toStringAsFixed(2)}"),
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
          height: MediaQuery.of(context).size.height * .09,
          child: Center(
              child: Text(
            "Rs. ${widget.appointment.price.toInt().toStringAsFixed(2)}",
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ))),
    );
  }
}



Future<bool> _showAlert(BuildContext context,String appointmentId,String saloonId) async {

  return await showDialog<dynamic>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: Text("Tell your experience. This is review time!"),
          content: AppointmentReview(appId: appointmentId,saloonId:saloonId)
        );
      });
}