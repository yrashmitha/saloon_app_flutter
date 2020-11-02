import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/category.dart';

class CategoryBubble extends StatelessWidget {
  final Category category;

  CategoryBubble({this.category});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (ctx, constraints) {
      return Container(
        margin: EdgeInsets.only(top: 5),
        width: MediaQuery.of(context).size.width * 0.25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: constraints.maxHeight*.5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                  )
                ],
              ),
              child: Center(child: Icon(category.iconDta)),
            ),
            SizedBox(
              height: constraints.maxHeight * .1,
            ),
            Text(category.title)
          ],
        ),
      );
    });
  }
}
