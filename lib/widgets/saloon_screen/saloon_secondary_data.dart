import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../read_more.dart';

class SaloonSecondaryData extends StatelessWidget {

  final Map<String,dynamic> additionalData;
  final String description;

  SaloonSecondaryData({this.additionalData,this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExpansionTile(
          backgroundColor: Colors.grey.withOpacity(0.1),
          title: Text("Opening hours"),
          subtitle: Text(
            DateTime.now().weekday == additionalData['open_hours']['${DateTime.now().weekday}'] ? "Open Today" : "Closed Now!",
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
                    children: additionalData['open_hours'].keys.map<Widget>((String key){
                      return Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  key,
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text(
                                  additionalData['open_hours'][key],
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
                    }).toList()
                  ),
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