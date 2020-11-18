import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/models/saloon.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/screens/saloon_screen.dart';
import 'package:provider/provider.dart';

class SaloonCard extends StatelessWidget {

  final Saloon saloon;

  SaloonCard({this.saloon});


  void setSelectedSaloon(Saloon id,BuildContext context) {
    Provider.of<SaloonsProvider>(context, listen: false).setSelectedSaloon(id,context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .33,
      width: MediaQuery.of(context).size.width * 0.8,
      child: GestureDetector(
        onTap: () {
            setSelectedSaloon(saloon,context);
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) {
                return SaloonScreen(
                  saloonName: saloon.name,
                  saloon: saloon,
                );
              },
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.height * .8,
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
                          tag: saloon.id,
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            placeholder: (ctx, url) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            width: MediaQuery.of(context).size.width,
                            imageUrl: saloon.featuredImageUrl,
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
                            saloon.gender,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        saloon.name, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                       saloon.address,overflow: TextOverflow.ellipsis,
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
                          Text("${saloon.rating.toString()}"),
                          SizedBox(
                            width: 5,
                          ),
                          Text("${saloon.ratingsCount.toString()} Ratings")
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
      )
    );
  }
}
