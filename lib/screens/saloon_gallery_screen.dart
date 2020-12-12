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
    final gallery = provider.selectedSaloon.smallGallery;
    return Scaffold(
      appBar: AppBar(
        title: Text('${provider.selectedSaloon.name} gallery'),
      ),
      body: Container(
        child: GridView.builder(
            itemCount: gallery.length,
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
                            return GalleryImage(url: gallery[index]['url']);
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
                      imageUrl: gallery[index]['url'],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
