import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/screens/saloon_all_reviews_screen.dart';
import 'package:helawebdesign_saloon/widgets/read_more.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';

class SaloonReviewBox extends StatelessWidget {

  final String imageUrl;
  final String userName;
  final int star;
  final String date;
  final String review;


  SaloonReviewBox({this.imageUrl, this.userName, this.star, this.date, this.review});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Container(
                  child: Row(
                    children: [
                      CircleAvatar(
                        child: ClipRRect(
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        radius: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userName,
                              style: TextStyle(fontSize: 18),
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                            Text(date.toString().split(" ")[0])
                          ],
                        ),
                      )
                    ],
                  ),
                )),
            RatingBarIndicator(
              rating: star.toDouble(),
              itemBuilder: (context, index) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 20.0,
              direction: Axis.horizontal,
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        ReadMoreText(
          review,
          trimLines: 2,
          textAlign: TextAlign.justify,
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}

