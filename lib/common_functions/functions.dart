import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/constants.dart';

Color getColor(String status) {
  String s = status.toLowerCase();
  if (s == 'pending') {
    return kMainYellowColor;
  } else if (s == 'accepted') {
    return Colors.greenAccent;
  }
  else if (s == 'completed') {
    return Colors.blueAccent;
  }
  else if (s == 'cancelled') {
    return Colors.orangeAccent;
  }else {
    return Colors.redAccent;
  }
}

IconData getIcon(String status) {
  String s = status.toLowerCase();
  if (s == 'pending') {
    return Icons.access_time;
  } else if (s == 'accepted') {
    return Icons.thumb_up;
  }
  else if (s == 'completed') {
    return Icons.check;
  } else {
    return Icons.clear;
  }
}