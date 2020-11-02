import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/models/service.dart';
import 'package:helawebdesign_saloon/screens/home_screen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class AppointmentBookingScreen extends StatefulWidget {
  List<Service> serviceList;
  double price;

  AppointmentBookingScreen(this.serviceList, this.price);

  @override
  _AppointmentBookingScreenState createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  var meetings = <Meeting>[];

  List<Meeting> _getDataSource() {
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 1));
    meetings.add(
        Meeting('Booked', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }

  Future<dynamic> _showAlert(CalendarTapDetails details) async {
    return showDialog<dynamic>(
        context: context,
        barrierDismissible: false,
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
                  child: Text("I am sure!"))
            ],
          );
        }).then((_) {
      print(details.date);
      setState(() {
        addNewAppointment(details);
      });
      Navigator.push(context, MaterialPageRoute(builder: (ctx){
        return HomeScreen();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.serviceList.length);
    final contextSize = MediaQuery
        .of(context)
        .size;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("Select date and time"),
          ),
          body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SfCalendar(
                headerStyle: CalendarHeaderStyle(
                    textStyle: TextStyle(
                  fontFamily: 'Montserrat',
                )),
                dataSource: MeetingDataSource(_getDataSource()),
                onTap: (CalendarTapDetails details) {
                  _showAlert(details);
                },
                view: CalendarView.workWeek,
                timeSlotViewSettings: TimeSlotViewSettings(
                    startHour: 9,
                    endHour: 16,
                    nonWorkingDays: <int>[DateTime.sunday, DateTime.saturday]),
              ),
              SizedBox(
                height: contextSize.height * 0.1,
              ),
              Container(
                height: contextSize.height * 0.2,
                width: contextSize.width * .7,
                decoration: BoxDecoration(
                    color: kMainYellowColor,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text("Rs. ${widget.price.toStringAsFixed(2)}",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
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
