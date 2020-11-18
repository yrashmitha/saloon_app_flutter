import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/saloon.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/screens/saloon_screen.dart';
import 'package:helawebdesign_saloon/widgets/saloon_card.dart';
import 'package:provider/provider.dart';

class ResultsScreen extends StatelessWidget {
  static String id = 'results-page';

  final String searchKey;
  final bool category;


  ResultsScreen({this.searchKey, this.category = false});

  void setSelectedSaloon(Saloon id, BuildContext context) {
    Provider.of<SaloonsProvider>(context, listen: false)
        .setSelectedSaloon(id, context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SaloonsProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("'${searchKey.trim()}'")),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:
            FutureBuilder(
              future: category==false ? provider.searchByName(searchKey) : provider.searchByCategory(searchKey),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if(snapshot.data.size == 0){
                  return Column(
                    children: [
                      Image.asset("assets/images/empty.png"),
                      SizedBox(height: 30,),
                      Text("No results")
                    ],
                  );
                }
                // print(snapshot.data.docs[0]['id']);
                return ListView.builder(
                    itemCount: snapshot.data.size,
                    itemBuilder: (ctx, index) {
                      Saloon s = Saloon(
                          snapshot.data.docs[index].id,
                          snapshot.data.docs[index]['name'],
                          snapshot.data.docs[index]['main-image_url'],
                          "",
                          snapshot.data.docs[index]['base_location'],
                          snapshot.data.docs[index]['address'],
                          snapshot.data.docs[index]['gender'],
                          "",
                          {},
                          0,
                          0,
                          snapshot.data.docs[index]['rating'],
                          snapshot.data.docs[index]['ratings_count'],
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
                                  saloonName: snapshot.data.docs[index]['name'],
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
                    });

              },
            )
          ),
        ),
      ),
    );
  }
}
