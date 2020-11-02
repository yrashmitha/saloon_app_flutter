import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/widgets/category_list.dart';
import 'package:helawebdesign_saloon/widgets/saloon_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      backgroundColor: Colors.black12.withOpacity(.0),
      elevation: 0,
      actions: [
        Icon(
          Icons.add,
          color: Colors.black,
        )
      ],
    );

    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.3,
                color: kMainYellowColor,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: LayoutBuilder(builder: (ctx, constraints) {
                      return Column(
                        children: [
                          appBar,
                          SizedBox(
                            height: (constraints.maxHeight -
                                    appBar.preferredSize.height) *
                                0.1,
                          ),
                          Text(
                            "Find your favourite saloon",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: (constraints.maxHeight -
                                    appBar.preferredSize.height) *
                                0.1,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: TextField(
                                autofocus: false,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.search),
                                    hintText: 'Enter saloon name',
                                    hintStyle: TextStyle(
                                        letterSpacing: 4,
                                        textBaseline: TextBaseline.alphabetic)),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: Text(
                  "Top Categories",
                  style: kTitleStyle,
                ),
              ),
            ),

            CategoryList(),



            SaloonCard()

          ],
        ),
      ),
    );
  }
}
