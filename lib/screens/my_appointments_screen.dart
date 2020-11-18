import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/providers/appointment_provider.dart';
import 'package:helawebdesign_saloon/screens/appointment_details.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';

class MyAppointmentsScreen extends StatefulWidget {
  static String id = 'my-appointments-screen';

  @override
  _MyAppointmentsScreenState createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  int _page = 1;
  GlobalKey _bottomNavigationKey = GlobalKey();
  var loading = false;

  @override
  void initState() {
    setState(() {
      loading = true;
    });
    Future.delayed(Duration.zero).then((_) {
      Provider.of<AppointmentProvider>(context, listen: false)
          .getAppointmentsBelongsToUser(false)
          .then((value) {
        setState(() {
          loading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppointmentProvider>(context);
    final appointments = provider.getUserAppointments;
    const x = 100;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: loading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(kMainYellowColor),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () {
                    return provider
                        .getAppointmentsBelongsToUser(true)
                        .then((value) {
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          behavior:SnackBarBehavior.floating,
                          content: Text("Refreshed!"),
                        ),
                      );
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                      child: appointments.length ==0 ? Center(child: Text("No appointments!"),) :
                      ListView.builder(
                          itemCount: appointments.length,
                          itemBuilder: (ctx, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8.0, right: 8, left: 8),
                              child: Card(
                                borderOnForeground: true,
                                child: Container(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          appointments[index].saloonImage),
                                    ),
                                    title: Text(
                                      "${DateFormat.yMMMMEEEEd().format(appointments[index].dateTime.toDate()).toString()} at ${DateFormat('kk:mm a').format(appointments[index].dateTime.toDate())}",
                                    ),
                                    subtitle: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(appointments[index].saloonName),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              color: getColor(
                                                  appointments[index].status),
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 5),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Icon(
                                                  getIcon(appointments[index]
                                                      .status),
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                Text(
                                                  appointments[index].status,
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            PageRouteTransition(
                                                animationType:
                                                    AnimationType.slide_right,
                                                builder: (ctx) {
                                                  return AppointmentDetailsScreen(
                                                    appointment:
                                                        appointments[index],
                                                  );
                                                }));
                                      },
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: kDeepBlue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                )),
    );
  }

  Color getColor(String status) {
    String s = status.toLowerCase();
    if (s == 'pending') {
      return kMainYellowColor;
    } else if (s == 'accepted') {
      return Colors.greenAccent;
    } else {
      return Colors.redAccent;
    }
  }

  IconData getIcon(String status) {
    String s = status.toLowerCase();
    if (s == 'pending') {
      return Icons.access_time;
    } else if (s == 'accepted') {
      return Icons.thumb_up;
    } else {
      return Icons.clear;
    }
  }
}
