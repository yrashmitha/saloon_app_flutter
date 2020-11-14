import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/providers/appointment_provider.dart';
import 'package:helawebdesign_saloon/providers/auth_provider.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/providers/user_provider.dart';
import 'package:helawebdesign_saloon/screens/appointment_book.dart';
import 'package:helawebdesign_saloon/screens/home_screen.dart';

import 'package:helawebdesign_saloon/screens/login_screen.dart';
import 'package:helawebdesign_saloon/screens/my_account_screen.dart';
import 'package:helawebdesign_saloon/screens/my_appointments_screen.dart';
import 'package:helawebdesign_saloon/screens/saloon_all_reviews_screen.dart';
import 'package:helawebdesign_saloon/screens/saloon_gallery_screen.dart';
import 'package:helawebdesign_saloon/screens/saloon_screen.dart';
import 'package:helawebdesign_saloon/screens/saloon_services_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => SaloonsProvider(),
        ),
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(
          create: (ctx) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AppointmentProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx,auth,_){
          return MaterialApp(
            title: 'Hela Saloon',
            theme: ThemeData(
              primaryColor: kDeepBlue,
              primarySwatch: Colors.blueGrey,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'Montserrat',
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: <TargetPlatform, PageTransitionsBuilder>{
                  TargetPlatform.android: ZoomPageTransitionsBuilder(),
                },
              ),
            ),
            home:  auth.isAuth!=null ?  Scaffold(body: BottomNavBar(page: 0,)) : LoginScreen(),
            routes: {
              SaloonScreen.id: (ctx) => SaloonScreen(),
              LoginScreen.id: (ctx) => LoginScreen(),
              HomeScreen.id: (ctx) => HomeScreen(),
              SaloonServicesScreen.id: (ctx) => SaloonServicesScreen(),
              MyAppointmentsScreen.id: (ctx) => MyAppointmentsScreen(),
              AppointmentBookingScreen.id: (ctx) => AppointmentBookingScreen(),
              SaloonGalleryScreen.id : (ctx) => SaloonGalleryScreen(),
              SaloonReviewsScreen.id : (ctx) => SaloonReviewsScreen()
            },
          );
        },

      ),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  var page;

  BottomNavBar({this.page});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  final _bottomNavigationKey = GlobalKey<CurvedNavigationBarState>();





  final pageOptions = [
    HomeScreen(),
    MyAppointmentsScreen(),
    MyAccountScreen(),
  ];

  int _page = 0;

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    // Provider.of<AuthProvider>(context)
    //     .isLoggedIn()
    //     .then((value) => print(value));
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: widget.page,
        height: 50.0,
        key: _bottomNavigationKey,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.account_circle_sharp, size: 30),
        ],
        color: kMainYellowColor,
        buttonBackgroundColor: kMainYellowColor,
        backgroundColor: Colors.white,
        animationCurve: Curves.ease,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            widget.page = index;
          });
        },
      ),
      body: pageOptions[widget.page],
    );
  }
}
