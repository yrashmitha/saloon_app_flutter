import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/providers/appointment_provider.dart';
import 'package:helawebdesign_saloon/providers/auth_provider.dart';
import 'package:helawebdesign_saloon/providers/drawer_provider.dart';
import 'package:helawebdesign_saloon/providers/navigation_provider.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/providers/user_provider.dart';
import 'package:helawebdesign_saloon/screens/appointment_book.dart';
import 'package:helawebdesign_saloon/screens/appointment_details.dart';
import 'package:helawebdesign_saloon/screens/home_screen.dart';

import 'package:helawebdesign_saloon/screens/login_screen.dart';
import 'package:helawebdesign_saloon/screens/my_account_screen.dart';
import 'package:helawebdesign_saloon/screens/my_appointments_screen.dart';
import 'package:helawebdesign_saloon/screens/results_screen.dart';
import 'package:helawebdesign_saloon/screens/saloon_all_reviews_screen.dart';
import 'package:helawebdesign_saloon/screens/saloon_gallery_screen.dart';
import 'package:helawebdesign_saloon/screens/saloon_screen.dart';
import 'package:helawebdesign_saloon/screens/saloon_services_screen.dart';
import 'package:helawebdesign_saloon/screens/user_favourites_screen.dart';
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
        ChangeNotifierProvider(create: (ctx) => NavigationProvider()),
        ChangeNotifierProvider(create: (ctx) => DrawerProvider())
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx,auth,_){
          return MaterialApp(
            // initialRoute: HomeScreen.id,
            title: 'Hela Saloon',
            theme: ThemeData(
              snackBarTheme: SnackBarThemeData(contentTextStyle: TextStyle(fontFamily: "Montserrat")),
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
              SaloonReviewsScreen.id : (ctx) => SaloonReviewsScreen(),
              MyAccountScreen.id : (ctx) =>MyAccountScreen(),
              AppointmentDetailsScreen.id : (ctx) =>AppointmentDetailsScreen(),
              ResultsScreen.id : (ctx) => ResultsScreen()
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
    UserFavouritesScreen(),
    MyAccountScreen(),
  ];

  int _page ;

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    print('bottm called');
    NavigationProvider provider = Provider.of<NavigationProvider>(context);
    _page = provider.page;
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: _page,
        height: 50.0,
        key: _bottomNavigationKey,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.favorite, size: 30),
          Icon(Icons.account_circle_sharp, size: 30),
        ],
        color: kMainYellowColor,
        buttonBackgroundColor: kMainYellowColor, 
        backgroundColor: Colors.white,
        animationCurve: Curves.ease,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {

          setState(() {
            provider.changePage(index);
            _page = index;
          });
        },
      ),
      body: pageOptions[_page],
    );
  }
}
