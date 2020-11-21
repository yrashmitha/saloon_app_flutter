import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helawebdesign_saloon/models/constants.dart';

class SaloonPrimaryData extends StatelessWidget {
  final String saloonName;
  final String address;
  final int ratingsCount;
  final double ratings;

  SaloonPrimaryData({@required this.saloonName,@required this.address,@required this.ratingsCount,@required this.ratings});

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
          address,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width ,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                FontAwesomeIcons.solidStar,
                size: 16,
                color: Color(0xFFDAA520),
              ),
              SizedBox(width: 10,),
              Text(
                "${ratings.toStringAsFixed(3)} Ratings",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              SizedBox(width: 10,),
              Text("(${ratingsCount.toString()})"),
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
