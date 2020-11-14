import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/screens/gallery_image.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';

class SaloonGalleryScreen extends StatelessWidget {
  static String id = 'saloon-gallery-screen';
  @override
  Widget build(BuildContext context) {
    final provider =Provider.of<SaloonsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('${provider.selectedSaloon.name} gallery'),
      ),
      body: Container(
        child: FutureBuilder(
          future: provider.getAllSaloonGallery(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(kMainYellowColor),));
            }

            return
              GridView.builder(
                  itemCount: snapshot.data.length,
                  gridDelegate:
                  new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(context, PageRouteTransition(
                              animationType: AnimationType.scale,
                              fullscreenDialog: true,
                              builder: (context){
                                return GalleryImage(url: snapshot.data[index]);
                              }
                            ));
                          },
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            placeholder: (ctx, url) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(kMainYellowColor),
                                ),
                              );
                            },
                            imageUrl: snapshot.data[index],
                          ),
                        ),
                      ),
                    );
                  });
          },
        ),
      ),
    );
  }
}
