import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/screens/saloon_screen.dart';
import 'package:provider/provider.dart';

class SaloonCard extends StatefulWidget {
  var init = false;

  @override
  _SaloonCardState createState() => _SaloonCardState();
}

class _SaloonCardState extends State<SaloonCard> {
  var init = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) => {
          Provider.of<SaloonsProvider>(context, listen: false).getSaloonsData()
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<SaloonsProvider>(context);
    final saloons = data.getSaloons;
    print(saloons.length);
    return Container(
      height: MediaQuery.of(context).size.height * .33,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return SaloonScreen(
                      saloonName: saloons[index].name,
                      id: saloons[index].id,
                      saloon: saloons[index],
                    );
                  },
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.8,
              child: LayoutBuilder(builder: (ctx, constraints) {
                return Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      // width: MediaQuery.of(context).size.width * 0.8,
                      width: constraints.maxWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Hero(
                              tag: saloons[index].id,
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                placeholder: (ctx, url) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                width: MediaQuery.of(context).size.width,
                                imageUrl: saloons[index].featuredImageUrl,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 20,
                            child: Container(
                              padding: EdgeInsets.all(6.5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3)),
                              child: Text(
                                saloons[index].gender,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            saloons[index].name,
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            saloons[index].address,
                            style: TextStyle(color: kSubTitleColor),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.solidStar,
                                size: 15,
                                color: Color(0xFFDAA520),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text("4.7"),
                              SizedBox(
                                width: 5,
                              ),
                              Text("30 Ratings")
                            ],
                            crossAxisAlignment: CrossAxisAlignment.center,
                          )
                        ],
                      ),
                    )
                  ],
                );
              }),
            ),
          );
        },
        itemCount: saloons.length,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
