import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helawebdesign_saloon/models/constants.dart';

class SaloonPrimaryData extends StatelessWidget {
  final String saloonName;

  SaloonPrimaryData({this.saloonName});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          saloonName,
          style: kSaloonName,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "No 170 Batagama South Kandana",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width * .4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                FontAwesomeIcons.solidStar,
                size: 16,
                color: Color(0xFFDAA520),
              ),
              Text(
                "4.9 Ratings",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Text("(53)"),
            ],
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey.withOpacity(.4),
        ),
      ],
    );
  }
}