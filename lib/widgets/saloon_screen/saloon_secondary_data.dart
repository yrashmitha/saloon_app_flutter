import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../read_more.dart';

class SaloonSecondaryData extends StatelessWidget {
  final Map<String, dynamic> additionalData;
  final String description;

  SaloonSecondaryData({this.additionalData, this.description});

  List<Widget> getOpenDays(List arr) {
    // print(arr);
    List<Widget> x = [];
    arr.forEach((element) {
      List<String> list = getDayAndTime(element);
      x.add(
        Column(
          children: [
            Row(
              children: [
                Text(
                  list[0],
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  list[1],
                  style: TextStyle(fontSize: 16),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    });
    return x;
  }

  List<String> getDayAndTime(Map<String, dynamic> x) {
    List<String> l = [];
    String day = x.keys.first;
    String time = x[x.keys.first];
    l.add(day);
    l.add(time);
    return l;
  }

  @override
  Widget build(BuildContext context) {
    getOpenDays(additionalData['open_hours']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          backgroundColor: Colors.grey.withOpacity(0.1),
          title: Text("Opening hours"),
          // subtitle: Text(
          //   DateTime.now().weekday == additionalData['open_hours']['${DateTime.now().weekday}'] ? "Open Today" : "Closed Now!",
          //   style: TextStyle(color: Colors.grey),
          // ),
          tilePadding: EdgeInsets.only(left: 0),
          leading: Icon(
            FontAwesomeIcons.clock,
            color: Colors.black,
          ),
          children: [
            Column(
              children: [
                Container(
                  child: Column(
                      children: getOpenDays(additionalData['open_hours'])),
                ),
              ],
            )
          ],
        ),
        Tooltip(
          message: additionalData['is_verified'] ==true ? 'This saloon is verified by HelaWeb Company. ' : 'This saloon is still not verified by HelaWeb Company',
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Tooltip(
              child: Icon(
                additionalData['is_verified'] == true ? FontAwesomeIcons.checkCircle : Icons.highlight_remove_sharp,
                color: Colors.black,
              ),
              message: 'This saloon is verified by HelaWeb Company. ',
            ),
            title:additionalData['is_verified'] ==true ? Text("Verified") : Text("Not Verified"),
          ),
        ),
        ListTile(
          contentPadding: EdgeInsets.all(0),
          leading: Icon(
            FontAwesomeIcons.car,
            color: Colors.black,
          ),
          title: additionalData['parking'] == true ? Text("Parking Available") : Text("Parking Unavailable"),
        ),
        ReadMoreText(
         description,
          trimLines: 4,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 16),
        )
      ],
    );
  }
}

// Column(
// children: [
// Row(
// children: [
// Text(
// key,
// style: TextStyle(fontSize: 16),
// ),
// Text(
// additionalData['open_hours'][key],
// style: TextStyle(fontSize: 16),
// ),
// ],
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// ),
// SizedBox(
// height: 10,
// ),
// ],
// ),
