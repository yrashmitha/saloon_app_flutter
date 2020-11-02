import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/models/saloon.dart';
import 'package:helawebdesign_saloon/models/service.dart';

import 'package:helawebdesign_saloon/screens/saloon_services_screen.dart';
import 'package:helawebdesign_saloon/widgets/saloon_screen/saloon_image_slider.dart';
import 'package:helawebdesign_saloon/widgets/saloon_screen/saloon_primary_data.dart';
import 'package:helawebdesign_saloon/widgets/saloon_screen/saloon_secondary_data.dart';
import 'package:helawebdesign_saloon/widgets/saloon_screen/saloon_services.dart';
import 'package:route_transitions/route_transitions.dart';

class SaloonScreen extends StatefulWidget {
  final String saloonName;
  final String id;
  final Saloon saloon;

  SaloonScreen({this.saloonName, this.id,this.saloon});

  @override
  _SaloonScreenState createState() => _SaloonScreenState();
}

class _SaloonScreenState extends State<SaloonScreen>
    with SingleTickerProviderStateMixin {
  List<Service> _selectedServices = [];

  void selectedServicesFunc(List<Service> list) {
    _selectedServices = list;
    print("I am from parent widget  $_selectedServices");
  }

  int currentIndex = 0;
  int prevIndex = 0;
  final SwiperController _swiperController = SwiperController();
  AnimationController _controller;

  ScrollController _scrollController = new ScrollController();

  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (200 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              elevation: 1,
              title: isShrink
                  ? Text(
                      "${widget.saloon.name}",
                      style: TextStyle(color: kDeepBlue),
                    )
                  : Text(""),
              forceElevated: true,
              actionsIconTheme: isShrink == true
                  ? IconThemeData(color: Colors.black87)
                  : IconThemeData(color: Colors.white),
              iconTheme: isShrink == true
                  ? IconThemeData(color: Colors.black87)
                  : IconThemeData(color: Colors.white),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    FontAwesomeIcons.solidHeart,
                  ),
                )
              ],
              backgroundColor: Colors.white,
              pinned: true,
              snap: false,
              floating: false,
              expandedHeight: MediaQuery.of(context).size.height * .35,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Hero(
                  tag: widget.id,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    placeholder: (ctx, url) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    width: MediaQuery.of(context).size.width,
                    imageUrl: widget.saloon.featuredImageUrl,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SaloonPrimaryData(
                      saloonName: widget.saloonName,
                    ),
                    SaloonSecondaryData(additionalData: widget.saloon.additionalData,description: widget.saloon.description,),
                    SizedBox(
                      height: 20,
                    ),
                    SaloonServices(selectionChange: selectedServicesFunc),
                    SizedBox(
                      height: 20,
                    ),
                    SaloonImageSlider()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.withOpacity(.5), width: 1),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .09,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteTransition(
                      animationType: AnimationType.slide_right,
                      builder: (context) => SaloonServicesScreen(selectedServices: _selectedServices,),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: kDeepBlue, borderRadius: BorderRadius.circular(5)),
                  width: MediaQuery.of(context).size.width * .3,
                  child: Center(
                    child: Text(
                      "Book Now",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}