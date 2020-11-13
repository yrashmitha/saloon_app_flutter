import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/models/service.dart';
import 'package:helawebdesign_saloon/providers/appointment_provider.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentBookingScreen extends StatefulWidget {
   static String id = 'appointmentBookingScreen';
  List<Service> serviceList;
  double price;

  AppointmentBookingScreen({this.serviceList, this.price});

  @override
  _AppointmentBookingScreenState createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) => {
          Provider.of<AppointmentProvider>(context, listen: false)
              .getAppoinmentsFromDb()
        });
    super.initState();
  }

  var meetings = <Meeting>[];

  List<Meeting> _getDataSource() {
    meetings = [];
    final appointments =
        Provider.of<AppointmentProvider>(context).getAppointments;
    for (var i = 0; i < appointments.length; i++) {
      var date = DateTime.fromMicrosecondsSinceEpoch(
          appointments[i].dateTime.microsecondsSinceEpoch);
      final DateTime today = DateTime.now();
      final DateTime startTime = DateTime(
          date.year, date.month, date.day, date.hour, date.minute, date.second);
      final DateTime endTime = startTime.add(const Duration(hours: 1));
      meetings.add(Meeting(
          'Booked', startTime, endTime, kMainYellowColor, false));
    }
    return meetings;
  }

  Future<dynamic> _showAlert(CalendarTapDetails details) async {
    return showDialog<dynamic>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text("Are you sure?"),
            content: SingleChildScrollView(
              child: Text(
                  "Are you sure to book a appointment in ${details.date.year}-${details.date.month}-${details.date.day}"
                  " at ${details.date.hour} to ${details.date.add(Duration(hours: 1))}?"),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
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
        }).then((_) {
      setState(() {
        addNewAppointment(details);
      });
      // Navigator.push(context, MaterialPageRoute(builder: (ctx) {
      //   return HomeScreen();
      // }));
    });
  }

  DateTime _minDate=DateTime.now();
  DateTime _maxDate = DateTime.now().add(Duration(days: 30),);


  @override
  Widget build(BuildContext context) {
    final contextSize = MediaQuery.of(context).size;
    final selectedSaloon = Provider.of<SaloonsProvider>(context).selectedSaloon;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Select date and time"),
          ),
          body: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .7,
                child: SfCalendar(
                  minDate: DateTime(_minDate.year, _minDate.month, _minDate.day, 12 , 0, 0),
                  maxDate: _maxDate,
                  showNavigationArrow: true,
                  headerStyle: CalendarHeaderStyle(
                    textStyle: TextStyle(
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  dataSource: MeetingDataSource(_getDataSource()),
                  onTap: (CalendarTapDetails details) {
                    _showAlert(details);
                  },
                  view: CalendarView.week,
                  timeSlotViewSettings: TimeSlotViewSettings(
                    timeInterval: Duration(minutes: selectedSaloon.appointmentInterval),
                      timeFormat: 'hh:mm',
                      startHour: 9,
                      endHour: 16,
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
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ))),
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
