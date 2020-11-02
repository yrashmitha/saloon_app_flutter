import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/screens/gallery_image.dart';

class SaloonImageSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {

              Navigator.of(context).push(
                PageRouteBuilder(
                  // opaque: false,
                  transitionDuration: Duration(milliseconds: 800),
                  pageBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation) {
                    return GalleryImage(index: index,);
                  },
                  fullscreenDialog: true,
                  reverseTransitionDuration: Duration(milliseconds: 800),

                ),
              );

            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Hero(
                tag: imageList[index],
                child: new Image.asset(
                  imageList[index],
                  fit: BoxFit.fill,
                ),
              ),
            ),
          );
        },
        itemCount: imageList.length,
        viewportFraction: 0.8,
        scale: 0.9,
        pagination: SwiperPagination(),
      ),
    );
  }
}
