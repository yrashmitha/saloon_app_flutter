import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helawebdesign_saloon/models/constants.dart';

class GalleryImage extends StatelessWidget {
  final index;

  GalleryImage({this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Hero(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    imageList[index],
                    fit: BoxFit.cover,
                  ),
                ),
                tag: imageList[index],
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(icon: Icon(Icons.cancel), onPressed: (){
                  Navigator.pop(context);
                }),
              )
            ],
            fit: StackFit.expand,
          ),
        ),
      ),
    );
  }
}
