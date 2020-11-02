import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../read_more.dart';

class SaloonSecondaryData extends StatelessWidget {

  final Map<dynamic,dynamic> additionalData;
  final String description;

  SaloonSecondaryData({this.additionalData,this.description});

  @override
  Widget build(BuildContext context) {
    print(additionalData['open_hours']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          backgroundColor: Colors.grey.withOpacity(0.1),
          title: Text("Opening hours"),
          subtitle: Text(
            "Closed Now",
            style: TextStyle(color: Colors.grey),
          ),
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
                    children: [
                      Row(
                        children: [
                          Text(
                            "Mon",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "9:00 AM - 6:00 PM",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "Mon",
                      //       style: TextStyle(fontSize: 16),
                      //     ),
                      //     Text(
                      //       "9:00 AM - 6:00 PM",
                      //       style: TextStyle(fontSize: 16),
                      //     ),
                      //   ],
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "Mon",
                      //       style: TextStyle(fontSize: 16),
                      //     ),
                      //     Text(
                      //       "9:00 AM - 6:00 PM",
                      //       style: TextStyle(fontSize: 16),
                      //     ),
                      //   ],
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "Mon",
                      //       style: TextStyle(fontSize: 16),
                      //     ),
                      //     Text(
                      //       "9:00 AM - 6:00 PM",
                      //       style: TextStyle(fontSize: 16),
                      //     ),
                      //   ],
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "Mon",
                      //       style: TextStyle(fontSize: 16),
                      //     ),
                      //     Text(
                      //       "9:00 AM - 6:00 PM",
                      //       style: TextStyle(fontSize: 16),
                      //     ),
                      //   ],
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "Mon",
                      //       style: TextStyle(fontSize: 16),
                      //     ),
                      //     Text(
                      //       "9:00 AM - 6:00 PM",
                      //       style: TextStyle(fontSize: 16),
                      //     ),
                      //   ],
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Row(
                      //   children: [
                      //     Text(
                      //       "Mon",
                      //       style: TextStyle(fontSize: 16),
                      //     ),
                      //     Text(
                      //       "9:00 AM - 6:00 PM",
                      //       style: TextStyle(fontSize: 16),
                      //     ),
                      //   ],
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
        Tooltip(
          message: 'This saloon is verified by HelaWeb Company. ',
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Tooltip(
              child: Icon(
                FontAwesomeIcons.checkCircle,
                color: Colors.black,
              ),
              message: 'This saloon is verified by HelaWeb Company. ',
            ),
            title: Text("Verified"),
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