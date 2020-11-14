import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helawebdesign_saloon/models/constants.dart';

class GalleryImage extends StatelessWidget {
  final String url;

  GalleryImage({this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              ClipRRect(
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
                  imageUrl: url,
                ),
              ),

            ],

          ),
        ),
      ),
      appBar: AppBar(),
    );
  }
}
