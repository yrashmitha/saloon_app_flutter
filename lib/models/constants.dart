import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/category.dart';

var kSubTitleColor= Colors.grey;
var kTextBoldWeight=FontWeight.w600;

var kTitleStyle= TextStyle(fontSize: 20);
var kMainYellowColor=Color(0xFFfcd581);
var kSaloonName = TextStyle(fontSize: 25,fontWeight: FontWeight.w600);
var kDeepBlue= Color(0xFF101928);
var  imageList = [
'assets/images/saloon_gallery/image1.jpg',
'assets/images/saloon_gallery/image2.jpg',
'assets/images/saloon_gallery/image3.jpg',
'assets/images/saloon_gallery/image4.jpg',
'assets/images/saloon_gallery/image5.jpg',
];

var kCityList = [
  'Kandana','Colombo','Kottawa','Nuwara Eliya','Kandy','Kolonnawa','Peradeniya','Kotte','Anuradhapura','Jaffna'
];

List<Category> catList=[
  Category(title:"Hair Cutting",path: "assets/images/categories/hair_cut.png",color: Colors.green,key: "HAIR CUT"),
  Category(title:"Makeup",path: "assets/images/categories/makeup.png",color: Colors.green,key: "MAKEUP"),
  Category(title:"Cleaning",path: "assets/images/categories/cleaning.png",color: Colors.green,key: "CLEANING"),
  Category(title:"Waxing",path: "assets/images/categories/waxing.png",color: Colors.green,key: "WAXING"),
  Category(title:"Nail Care",path: "assets/images/categories/nail.png",color: Colors.green,key: "NAILCARE"),
  Category(title:"Eye Care",path: "assets/images/categories/eyecare.png",color: Colors.green,key: "EYECARE"),
];