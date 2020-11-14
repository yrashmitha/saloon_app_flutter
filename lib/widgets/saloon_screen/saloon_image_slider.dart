import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/screens/gallery_image.dart';
import 'package:helawebdesign_saloon/screens/saloon_gallery_screen.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';

class SaloonImageSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List imageList = Provider.of<SaloonsProvider>(context).selectedSaloon.smallGallery;
    return imageList.length>0 ?Column(
      children: [
        Container(
          height: 200,
          child: new Swiper(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context,  PageRouteTransition(
                      builder: (context){
                        return GalleryImage(url: imageList[index],);
                      },
                      fullscreenDialog: true,
                      curves: Curves.easeInOutBack,
                      animationType: AnimationType.slide_up
                  ));

                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    placeholder: (ctx, url) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(kMainYellowColor),
                        ),
                      );
                    },
                    imageUrl: imageList[index],
                  ),
                ),
              );
            },
            itemCount: imageList.length,
            viewportFraction: 0.8,
            scale: 0.9,
            pagination: SwiperPagination(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical:8.0),
          child: Align(
            alignment: Alignment.centerRight,
              child: FlatButton(onPressed: (){
                Navigator.pushNamed(context, SaloonGalleryScreen.id);
              }, child: Text('View all images'),),),
        )
      ],
    )
    : Column(
      children: [
        Image.asset('assets/images/oopz.png',fit: BoxFit.cover,),
        Text("No images!"),
      ],
    )
    ;
  }
}
