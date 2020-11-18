import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/screens/saloon_all_reviews_screen.dart';
import 'package:helawebdesign_saloon/widgets/read_more.dart';
import 'package:helawebdesign_saloon/widgets/saloon_screen/saloon_review_box.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';

class SaloonReviews extends StatelessWidget {
  List<Widget> setReviews(List reviews, BuildContext context) {
    List<Widget> list = [];
    list.add(Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 15),
      child: Text(
        "Reviews",
        style: kSaloonName,
      ),
    ));
    if (reviews.length == 0) {
      list.add(Center(child: Text("No reviews yet!")));
    } else {
      reviews.forEach((element) {
        var x = SaloonReviewBox(
          imageUrl: element['user_profile_avatar'],
          userName: element['user_name'],
          star: element['star'],
          date: element['date'].toDate(),
          review: element['customer_review'],
        );
        list.add(x);
      });
      list.add(FlatButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteTransition(
                animationType: AnimationType.slide_right,
                builder: (context) => SaloonReviewsScreen(),
              ),
            );
          },
          child: Align(
              alignment: Alignment.centerRight,
              child: Text('View all reviews'))));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SaloonsProvider>(context);
    final List reviews = provider.selectedSaloon.reviews;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: setReviews(reviews, context));
  }
}
