import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/category.dart';
import 'package:helawebdesign_saloon/models/constants.dart';

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
              height: constraints.maxHeight * .5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, kMainYellowColor]),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                  )
                ],
              ),
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: .7,
                  heightFactor: .7,
                  child: Container(
                    child: Image.asset(
                     category.path
                    ),
                  ),
                ),
                widthFactor: 1,
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * .1,
            ),
            Text(
              category.title,
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    });
  }
}
