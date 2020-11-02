import 'package:flutter/cupertino.dart';

class Service{
  int id;
  String name;
  String description;
  double price;

  Service({@required this.id,@required this.name,@required this.description,@required this.price});



}

Map<Service, bool> _serviceList = {
  Service(
    id: 1,
    name: 'Personal Hair Cut',
    description: 'This is small description about my service',
    price: 300,
  ): false,
  Service(
    id: 2,
    name: 'Hair Coloring',
    description: 'This is small description about my service',
    price: 800,
  ): false,
  Service(
    id: 3,
    name: 'Happy Ending Massage',
    description: 'This is small description about my service',
    price: 3000,
  ): false,
};