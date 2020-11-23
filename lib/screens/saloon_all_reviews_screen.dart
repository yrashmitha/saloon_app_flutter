import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/widgets/saloon_screen/saloon_review_box.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';

import 'gallery_image.dart';

class SaloonReviewsScreen extends StatelessWidget {
  static String id = 'saloon-reviews-screen';
  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SaloonsProvider>(context);
    final selectedSaloon = provider.selectedSaloon;
    return Scaffold(
      appBar: AppBar(
        title: Text('${provider.selectedSaloon.name} reviews'),
      ),
      body: Container(
        child: RefreshIndicator(
          child: PaginateFirestore(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            itemsPerPage: 5,
            itemBuilderType: PaginateBuilderType.listView,
            itemBuilder: (index,ctx,snapshot){
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SaloonReviewBox(
                    imageUrl: snapshot.data()['user_profile_avatar'],
                    userName: snapshot.data()['user_name'],
                    star: snapshot.data()['star'],
                    date: snapshot.data()['date'].toDate(),
                    review: snapshot.data()['customer_review'],
                  ),
                ),
              );
            },
            query: FirebaseFirestore.instance
                .collection('saloons/${selectedSaloon.id}/all_reviews').orderBy('date',descending: true),
            listeners: [
              refreshChangeListener,
            ],
          ),
          onRefresh: () async {
            refreshChangeListener.refreshed = true;
          },
        )
      ),
    );
  }
}
