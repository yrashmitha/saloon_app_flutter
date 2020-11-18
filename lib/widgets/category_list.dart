import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/category.dart';
import 'package:helawebdesign_saloon/screens/results_screen.dart';
import 'package:route_transitions/route_transitions.dart';

import 'category_bubble.dart';

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.15,
      child: ListView.builder(
          itemCount: catList.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (ctx, index) {
            var category = catList[index];
            return GestureDetector(
              onTap: () {
                print(category.key);
                Navigator.push(
                  context,
                  PageRouteTransition(
                    animationType: AnimationType.slide_right,
                      builder: (ctx) {
                    return ResultsScreen(
                      category: true,
                      searchKey: category.key,
                    );
                  }),
                );
              },
              child: CategoryBubble(
                category: category,
              ),
            );
          }),
    );
  }
}
