import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/widgets/saloon_screen/saloon_review_box.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';

import 'gallery_image.dart';

class SaloonReviewsScreen extends StatelessWidget {
  static String id = 'saloon-reviews-screen';
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SaloonsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${provider.selectedSaloon.name} reviews'),
      ),
      body: Container(
        child: FutureBuilder(
          future: provider.getAllReviews(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(kMainYellowColor),));
            }

            return
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                    itemBuilder: (ctx,index){
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SaloonReviewBox(
                        imageUrl: snapshot.data[index]['user_profile_avatar'],
                        userName: snapshot.data[index]['user_name'],
                        star: snapshot.data[index]['star'],
                        date: snapshot.data[index]['date'],
                        review: snapshot.data[index]['customer_review'],
                      ),
                    ),
                  );
                }),
              );
          },
        ),
      ),
    );
  }
}
