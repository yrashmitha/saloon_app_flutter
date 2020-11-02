import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/category.dart';

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
            return CategoryBubble(
              category: category,
            );
          }),
    );
  }
}
