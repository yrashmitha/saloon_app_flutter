import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/screens/home_screen.dart';
import 'package:route_transitions/route_transitions.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(onPressed: () {
          Navigator.push(
            context,
            PageRouteTransition(
              animationType: AnimationType.scale,
              builder: (context) => HomeScreen(),)
            );
        },
          child: Text("Sign In with google"),
        ),
      ),
    );
  }
}
