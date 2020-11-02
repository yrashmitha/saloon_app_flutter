import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class SaloonGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MyHomePage(
      title: "Gallery",
    ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _image = [
    'assets/images/saloon_gallery/image1.jpg',
    'assets/images/saloon_gallery/image2.jpg',
    'assets/images/saloon_gallery/image3.jpg',
    'assets/images/saloon_gallery/image4.jpg',
    'assets/images/saloon_gallery/image5.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        height: 200,
        child: new Swiper(
          itemBuilder: (BuildContext context, int index) {
            print(index);
            print("items arr ${_image[index]}");
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: new Image.asset(
                _image[index],
                fit: BoxFit.fill,
              ),
            );
          },
          itemCount: _image.length,
          viewportFraction: 0.8,
          scale: 0.9,
          pagination: SwiperPagination(),
        ),
      ),
    );
  }
}
