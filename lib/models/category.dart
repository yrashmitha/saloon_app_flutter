import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Category{
  final String title;
  final IconData iconDta;
  final Color color;

  Category({this.title,this.iconDta,this.color});
}
List<Category> catList=[
  Category(title:"Hair Cut",iconDta: Icons.accessibility,color: Colors.green),
  Category(title:"Hair Cut",iconDta: Icons.eleven_mp,color: Colors.yellowAccent),
  Category(title:"Hair Cut",iconDta: Icons.account_balance,color: Colors.green),
  Category(title:"Hair Cut",iconDta: Icons.access_alarm,color: Colors.yellowAccent),
  Category(title:"Hair Cut",iconDta: Icons.threesixty_sharp,color: Colors.green),
  Category(title:"Hair Cut",iconDta: Icons.ac_unit_sharp,color: Colors.yellowAccent),
  Category(title:"Hair Cut",iconDta: Icons.add,color: Colors.green),
  Category(title:"Hair Cut",iconDta: Icons.eco_sharp,color: Colors.yellowAccent),
];