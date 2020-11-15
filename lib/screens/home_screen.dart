import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/providers/navigation_provider.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/widgets/category_list.dart';
import 'package:helawebdesign_saloon/widgets/saloon_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {

  static String id = 'home-screen';

  int num=0;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  final GlobalKey _bottomNavigationKey = GlobalKey();


  @override
  void initState() {
    print('home init');
   Future.delayed(Duration.zero).then((value){
     Provider.of<SaloonsProvider>(context, listen: false).getSaloonsData(false).then((value){});
   });
    super.initState();
  }
  Future<void> _refreshSaloons(){
    return Provider.of<SaloonsProvider>(context,listen: false).getSaloonsData(true);
  }


  @override
  Widget build(BuildContext context) {
    print("home build");
    final data = Provider.of<SaloonsProvider>(context);
    final saloons = data.getSaloons;
    print("salon array size is ${saloons.length}");
    final appBar = AppBar(
      backgroundColor: Colors.black12.withOpacity(.0),
      elevation: 0,
      actions: [
        Icon(
          Icons.add,
          color: Colors.black,
        )
      ],
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: (){
          return _refreshSaloons();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.3,
                  color: kMainYellowColor,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: LayoutBuilder(builder: (ctx, constraints) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: (constraints.maxHeight -
                                  appBar.preferredSize.height) *
                                  0.1,
                            ),
                            Text(
                              "Find your favourite saloon",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: (constraints.maxHeight -
                                  appBar.preferredSize.height) *
                                  0.1,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.8,
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 5),
                                child: TextField(
                                  autofocus: false,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Icon(Icons.search),
                                      hintText: 'Enter saloon name',
                                      hintStyle: TextStyle(
                                          letterSpacing: 4,
                                          textBaseline: TextBaseline.alphabetic)),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Text(
                    "Top Categories",
                    style: kTitleStyle,
                  ),
                ),
              ),

              CategoryList(),


              Container(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return SaloonCard(saloon: saloons[index],);
                  },
                  itemCount:saloons.length,
                ),
              ),

              RaisedButton(
                child: Text("Click"),
                onPressed: (){
                  setState(() {
                    Provider.of<NavigationProvider>(context,listen: false).changePage(1);
                  });
                },
              ),
              Text(widget.num.toString()),

            ],
          ),


        ),
      ),
    );
  }
}
