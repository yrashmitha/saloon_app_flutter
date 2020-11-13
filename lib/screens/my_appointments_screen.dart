import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class MyAppointmentsScreen extends StatefulWidget {
  static String id = 'my-appointments-screen';

  @override
  _MyAppointmentsScreenState createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  int _page = 1;
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("appointment screen init state");
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUserx;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text("hi"),),
    );
  }
}
