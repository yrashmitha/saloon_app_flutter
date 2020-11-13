import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/screens/home_screen.dart';
import 'package:helawebdesign_saloon/screens/my_appointments_screen.dart';

class EntryPoint extends StatefulWidget {
  @override
  _EntryPointState createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  @override
  Widget build(BuildContext context) {

    dynamic list = [HomeScreen(),MyAppointmentsScreen()];
    int _page =0;
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 50.0,
        items: <Widget>[
          Icon(Icons.add, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.compare_arrows, size: 30),
        ],
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: Colors.blueAccent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = list[index];
          });
        },
      ),
    );
  }
}
