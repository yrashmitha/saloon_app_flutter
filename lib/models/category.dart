import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Category{
  final String title;
  final String path;
  final String key;
  final Color color;

  Category({this.title,this.path,this.color,this.key});
}
List<Category> catList=[
  Category(title:"Hair Cutting",path: "assets/images/categories/hair_cut.png",color: Colors.green,key: "HAIR CUT"),
  Category(title:"Makeup",path: "assets/images/categories/makeup.png",color: Colors.green,key: "MAKEUP"),
  Category(title:"Cleaning",path: "assets/images/categories/cleaning.png",color: Colors.green,key: "CLEANING"),
  Category(title:"Waxing",path: "assets/images/categories/waxing.png",color: Colors.green,key: "WAXING"),
  Category(title:"Nail Care",path: "assets/images/categories/nail.png",color: Colors.green,key: "NAILCARE"),
  Category(title:"Eye Care",path: "assets/images/categories/eyecare.png",color: Colors.green,key: "EYECARE"),
];