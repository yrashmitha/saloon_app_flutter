import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/appointment.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/models/service.dart';
import 'package:helawebdesign_saloon/providers/appointment_provider.dart';
import 'package:helawebdesign_saloon/providers/navigation_provider.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/screens/appointment_details.dart';
import 'package:helawebdesign_saloon/screens/home_screen.dart';
import 'package:helawebdesign_saloon/screens/my_account_screen.dart';
import 'package:helawebdesign_saloon/screens/saloon_screen.dart';
import 'package:helawebdesign_saloon/screens/saloon_services_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentBookingScreen extends StatefulWidget {
  static String id = 'appointmentBookingScreen';

  final double price;

  AppointmentBookingScreen({this.price});

  @override
  _AppointmentBookingScreenState createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  var loading = false;
  List<Service> serviceList;
  List<Route> arrayRoutes = [];

  SaloonsProvider _saloonsProvider;

  @override
  void initState() {

    setState(() {
      loading = true;
    });

    Future.delayed(Duration.zero).then((_) {
      _saloonsProvider = Provider.of<SaloonsProvider>(context, listen: false);
      Provider.of<AppointmentProvider>(context, listen: false)
          .getAppointmentsFromDb(_saloonsProvider.selectedSaloon.id)
          .then((value) {
        setState(() {
          loading = false;
        });
      });
      serviceList = Provider.of<AppointmentProvider>(context, listen: false)
          .getUserSelectedService;
    });

    super.initState();
  }

  var meetings = <Meeting>[];

  List<Meeting> _getDataSource() {
    meetings = [];
    final appointments =
        Provider.of<AppointmentProvider>(context, listen: false)
            .getAppointments;

    for (var i = 0; i < appointments.length; i++) {
      var date = DateTime.fromMicrosecondsSinceEpoch(
          appointments[i].dateTime.microsecondsSinceEpoch);
      final DateTime today = DateTime.now();
      final DateTime startTime = DateTime(
          date.year, date.month, date.day, date.hour, date.minute, date.second);
      final interval = _saloonsProvider.selectedSaloon.appointmentInterval;
      final DateTime endTime = startTime.add(Duration(minutes: interval));
      meetings
          .add(Meeting('Booked', startTime, endTime, kMainYellowColor, false));
    }
    return meetings;
  }

  List<TimeRegion> _getTimeRegions() {
    List<Meeting> list = _getDataSource();
    final List<TimeRegion> regions = <TimeRegion>[];
    list.forEach((Meeting element) {
      regions.add(TimeRegion(
          startTime: element.from,
          endTime: element.to,
          enablePointerInteraction: false,
          color: kMainYellowColor.withOpacity(0.8),
          text: 'Booked'));
    });

    return regions;
  }

  Future<dynamic> _showAlert(CalendarTapDetails details,
      AppointmentProvider provider, SaloonsProvider saloonProvider) async {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final DateFormat timeFormat = DateFormat('kk:mm a');
    return showDialog<dynamic>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Are you sure?"),
            content: SingleChildScrollView(
              child: Text(
                  "Are you sure to book a appointment on ${dateFormat.format(details.date)} at"
                  " ${timeFormat.format(details.date)} to "
                  "${timeFormat.format(details.date.add(Duration(minutes: saloonProvider.selectedSaloon.appointmentInterval)))} ?"),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  Navigator.pop(context);

                  final user = FirebaseAuth.instance.currentUser;
                  var app = SaloonAppointment(
                      null,
                      saloonProvider.selectedSaloon.id,
                      null,
                      null,
                      user.uid,
                      null,
                      null,
                      'PENDING',
                      widget.price.toInt(),
                      user.photoURL,
                      _saloonsProvider.selectedSaloon.featuredImageUrl,
                      Timestamp.fromDate(details.date),
                      false,
                      serviceList);

                  final fbm = FirebaseMessaging();
                  final token = await fbm.getToken();




                   await provider.addAppointment(app, saloonProvider,token).then((value) {
                     setState(() {
                       loading=false;
                     });
                    afterSuccessfulAppointment(value);
                    // Navigator.pushNamed(context, AppointmentDetailsScreen.id);
                  }).catchError((err) {
                    print(err);
                  });
                },
                child: Text("I am sure!"),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancel"))
            ],
          );
        });
  }

  DateTime _minDate = DateTime.now();
  DateTime _maxDate = DateTime.now().add(
    Duration(days: 30),
  );

  void popUpLogic() {
    for (var i = 0; i < 2; i++) {
      Navigator.pop(context);
    }
    // bool x = Navigator.canPop(context);
    // while(x){
    //   Navigator.pop(context);
    //   x = Navigator.canPop(context);
    // }
  }

  void afterSuccessfulAppointment(SaloonAppointment app) {
    // SnackBar snack =  SnackBar(
    //   elevation: 5,
    //   behavior: SnackBarBehavior.floating,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
    //   duration: Duration(seconds: 20),
    //   action: SnackBarAction(
    //     label: 'Ok',
    //     textColor: kMainYellowColor,
    //     onPressed: (){
    //       Scaffold.of(context).hideCurrentSnackBar();
    //     },
    //   ),
    //   content: const Text("Appointment added successfully",),
    // );
    // Scaffold.of(context).showSnackBar(snack);

    popUpLogic();

    Navigator.push(
      context,
      PageRouteTransition(
        animationType: AnimationType.slide_up,
        fullscreenDialog: true,
        builder: (ctx) {
          return AppointmentDetailsScreen(
            fromBookingPage: true,
            appointmentId: app.appointmentId,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final contextSize = MediaQuery.of(context).size;
    final provider = Provider.of<SaloonsProvider>(context);
    final appProvider = Provider.of<AppointmentProvider>(context);
    final selectedSaloon = provider.selectedSaloon;
    print(selectedSaloon.appointmentInterval);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Select date and time"),
          ),
          body: loading
              ? Center(
                  child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(kMainYellowColor),
                ))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * .7,
                          child: SfCalendar(
                            specialRegions: _getTimeRegions(),
                            minDate: DateTime(_minDate.year, _minDate.month,
                                _minDate.day, 12, 0, 0),
                            maxDate: _maxDate,
                            showNavigationArrow: true,
                            headerStyle: CalendarHeaderStyle(
                              textStyle: TextStyle(
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            // dataSource: MeetingDataSource(_getDataSource()),
                            onTap: (CalendarTapDetails details) {
                              _showAlert(details, appProvider, provider);
                            },
                            view: CalendarView.workWeek,
                            timeSlotViewSettings: TimeSlotViewSettings(
                                timeInterval: Duration(
                                    minutes:
                                        selectedSaloon.appointmentInterval),
                                timeFormat: 'hh:mm',
                                startHour: selectedSaloon.openTime.toDouble(),
                                endHour: selectedSaloon.closeTime.toDouble(),
                                nonWorkingDays: <int>[
                                  DateTime.sunday,
                                  DateTime.saturday
                                ]),
                          ),
                        ),
                        // SizedBox(
                        //   height: contextSize.height * 0.1,
                        // ),
                        Expanded(
                          child: Container(
                            width: contextSize.width * .7,
                            decoration: BoxDecoration(
                                color: kMainYellowColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: Text(
                                "Rs. ${widget.price.toStringAsFixed(2)}",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
    );
  }

  void addNewAppointment(CalendarTapDetails details) {
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(
        details.date.year,
        details.date.month,
        details.date.day,
        details.date.hour,
        details.date.minute,
        details.date.second);
    final DateTime endTime = startTime.add(const Duration(hours: 1));
    meetings.add(Meeting('Booked', startTime, endTime, kDeepBlue, false));
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
