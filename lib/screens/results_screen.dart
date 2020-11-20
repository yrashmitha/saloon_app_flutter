import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/models/saloon.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/screens/saloon_screen.dart';
import 'package:helawebdesign_saloon/widgets/my_drawer.dart';
import 'package:helawebdesign_saloon/widgets/saloon_card.dart';
import 'package:provider/provider.dart';

class ResultsScreen extends StatefulWidget {
  static String id = 'results-page';

  final String searchKey;
  final bool category;
  final String city;

  ResultsScreen({this.searchKey, this.category = false, this.city});

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  String categoryData = null;

  String gender = null;
  bool advanceMode = false;

  void setSelectedSaloon(Saloon id, BuildContext context) {
    Provider.of<SaloonsProvider>(context, listen: false)
        .setSelectedSaloon(id, context);
  }

  void advanceSearch(String gender, String category, String city) {
    log("advance search called from results screen");
    Provider.of<SaloonsProvider>(context, listen: false)
        .search(city, category, gender);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SaloonsProvider>(context);
    final list = provider.list;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("'${widget.searchKey.trim()}'")),
        endDrawer: MyDrawer(
          func: advanceSearch,
        ),
        body: list.length >0 ? ListView.builder(
            itemCount: list.length,
            itemBuilder: (ctx, index) {
              Saloon s = Saloon(
                  list[index].id,
                  list[index]['name'],
                  list[index]['main-image_url'],
                  "",
                  list[index]['base_location'],
                  list[index]['address'],
                  list[index]['gender'],
                  "",
                  {},
                  0,
                  0,
                  list[index]['rating'],
                  list[index]['ratings_count'],
                  0,
                  [],
                  [],
                  []);
              return GestureDetector(
                onTap: () {
                  setSelectedSaloon(s, context);
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return SaloonScreen(
                          saloonName: list[index]['name'],
                          saloon: s,
                        );
                      },
                    ),
                  );
                },
                child: SaloonCard(
                  saloon: s,
                ),
              );
            }) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(kMainYellowColor),),),
      ),
    );
  }
}
