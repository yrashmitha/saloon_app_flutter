import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/models/saloon.dart';
import 'package:helawebdesign_saloon/providers/drawer_provider.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/screens/saloon_screen.dart';
import 'package:helawebdesign_saloon/widgets/my_drawer.dart';
import 'package:helawebdesign_saloon/widgets/saloon_card.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

class ResultsScreen extends StatefulWidget {
  static String id = 'results-page';

  final String searchKey;
  final bool category;
  final String city;
  final bool isThisName;

  ResultsScreen({this.searchKey, this.category = false, this.city,this.isThisName=false});

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  String categoryData = null;

  String _gender;
  String _location;
  String _category;
  bool advanceMode = false;

  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  void setSelectedSaloon(Saloon id, BuildContext context) {
    Provider.of<SaloonsProvider>(context, listen: false)
        .setSelectedSaloon(id, context);
  }

  void advanceSearch(String gender, String category, String city) {
    log("advance search called from results screen");

    setState(() {
      Provider.of<DrawerProvider>(context, listen: false).clearDefaults();
      Provider.of<DrawerProvider>(context, listen: false).category = category;
      Provider.of<DrawerProvider>(context, listen: false).gender = gender;
      Provider.of<DrawerProvider>(context, listen: false).location = city;
    });

    // Provider.of<SaloonsProvider>(context, listen: false)
    //     .search(city, category, gender);
  }

  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<SaloonsProvider>(context);
    final provider = Provider.of<DrawerProvider>(context);
    log(provider.location);
    log(provider.gender);
    log(provider.category);

    // final list = provider.list;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("'${widget.searchKey.trim()}'")),
        endDrawer: MyDrawer(
          func: advanceSearch,
        ),
        body: Container(
            child: RefreshIndicator(
          child: PaginateFirestore(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            itemsPerPage: 5,
            itemBuilderType: PaginateBuilderType.listView,
            itemBuilder: (index, ctx, snapshot) {
              Saloon s = Saloon(
                  snapshot.id,
                  snapshot.data()['name'],
                  snapshot.data()['main-image_url'],
                  "",
                  snapshot.data()['base_location'],
                  snapshot.data()['address'],
                  snapshot.data()['gender'],
                  "",
                  {},
                  0,
                  0,
                  [],
                  snapshot.data()['rating'].toDouble(),
                  snapshot.data()['ratings_count'],
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
                          saloonName: snapshot.data()['name'],
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
            },
            query: widget.isThisName? provider.nameSearch(widget.searchKey) : provider.searchQuery(provider.location, provider.category, provider.gender),
            listeners: [
              refreshChangeListener,
            ],
          ),
          onRefresh: () async {
            refreshChangeListener.refreshed = true;
          },
        )
        ),
      ),
    );
  }
}

// provider.isDataReady ? (list.length> 0 ?
// ListView.builder(
// itemCount: list.length,
// itemBuilder: (ctx, index) {
// Saloon s = Saloon(
// list[index].id,
// list[index]['name'],
// list[index]['main-image_url'],
// "",
// list[index]['base_location'],
// list[index]['address'],
// list[index]['gender'],
// "",
// {},
// 0,
// 0,
// list[index]['rating'],
// list[index]['ratings_count'],
// 0,
// [],
// [],
// []);
// return
// }) : Center(child: Text("No results",style: kSaloonName,))):
// Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(kMainYellowColor),),),
