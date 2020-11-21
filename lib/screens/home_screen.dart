import 'dart:developer';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/providers/navigation_provider.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/screens/results_screen.dart';
import 'package:helawebdesign_saloon/widgets/category_list.dart';
import 'package:helawebdesign_saloon/widgets/saloon_card.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home-screen';

  int num = 0;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  final GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    print('home init');
    Future.delayed(Duration.zero).then((value) {
      Provider.of<SaloonsProvider>(context, listen: false)
          .getSaloonsData(false)
          .then((value) {});
    });
    super.initState();
  }

  Future<void> _refreshSaloons() {
    print('refresh');
    return Provider.of<SaloonsProvider>(context, listen: false)
        .getSaloonsData(true);
  }

  @override
  Widget build(BuildContext context) {
    print("home build");
    final data = Provider.of<SaloonsProvider>(context);
    final saloons = data.getSaloons;
    print("salon array size is ${saloons.length}");
    final appBar = AppBar(
      backgroundColor: Colors.black12.withOpacity(.5),
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
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          onRefresh: () {
            return Provider.of<SaloonsProvider>(context, listen: false)
                .getSaloonsData(true);
          },
          child: ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Align(
                                child: MaterialButton(
                                  child: Icon(Icons.filter_list,),
                                  onPressed: () {
                                    _settingModalBottomSheet(context);
                                  },
                                  color: Colors.white.withOpacity(.9),
                                  padding: EdgeInsets.all(16),
                                  shape: CircleBorder(),
                                  elevation: 0.5,
                                  splashColor: kMainYellowColor,

                                ),
                                alignment: Alignment.centerRight,
                              ),
                              SizedBox(height: 5,),
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
                                child: Center(
                                  child: TextField(
                                    autofocus: false,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.search),
                                        hintText: 'Enter saloon name',
                                        hintStyle: TextStyle(
                                            letterSpacing: 4,
                                            textBaseline:
                                                TextBaseline.alphabetic)),
                                    textAlign: TextAlign.start,
                                    onSubmitted: (value) {
                                      Provider.of<SaloonsProvider>(context,listen: false).searchByName(value);
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (ctx) {
                                        return ResultsScreen(
                                          searchKey: value,
                                        );
                                      }));
                                    },
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
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Top Rated Saloons",
                    style: kSaloonName,
                  ),
                ),
                Container(
                  height: 250,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      return SaloonCard(
                        saloon: saloons[index],
                      );
                    },
                    itemCount: saloons.length,
                  ),
                ),
                RaisedButton(
                  child: Text("Add a saloon"),
                  onPressed: () {
                    data.addReview().then((value) {
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text("review Added")));
                    });
                  },
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

void _settingModalBottomSheet(context) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * .4,
          decoration: BoxDecoration(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  "Select your City",
                  style: kSaloonName,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * .4,
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          Provider.of<SaloonsProvider>(context,listen: false).search(kCityList[index], '', '');
                          Navigator.pop(ctx);
                          Navigator.push(context,
                              PageRouteTransition(builder: (ctx) {
                            return ResultsScreen(searchKey: kCityList[index],city:  kCityList[index],);
                          }));
                        },
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(kCityList[index]),
                              trailing: Icon(Icons.arrow_forward_sharp),
                              contentPadding: EdgeInsets.all(0),
                            ),
                            Divider()
                          ],
                        ),
                      );
                    },
                    itemCount: kCityList.length,
                  ),
                )
              ]),
            ),
          ),
        );
      });
}
