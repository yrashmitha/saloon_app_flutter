import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/models/service.dart';
import 'package:helawebdesign_saloon/screens/saloon_services_screen.dart';
import 'package:route_transitions/route_transitions.dart';

class SaloonServices extends StatefulWidget {
  Function selectionChange;

  SaloonServices({this.selectionChange});

  @override
  _SaloonServicesState createState() => _SaloonServicesState();
}

class _SaloonServicesState extends State<SaloonServices> {
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

  List<Service> selectedServices = [];

  List<Service> get userSelectedServices {
    return [...selectedServices];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Services',
            style: kSaloonName,
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            children: _serviceList.keys.map((Service key) {
              return Column(children: [
                new CheckboxListTile(
                  secondary: Icon(
                    FontAwesomeIcons.cut,
                    color: kDeepBlue,
                  ),
                  subtitle: Text(key.description),
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                  title: new Text(key.name),
                  value: _serviceList[key],
                  onChanged: (bool value) {
                    print(value);

                    if (value == false && selectedServices.contains(key)) {
                      print("have ready to remove");
                      selectedServices.remove(key);
                      widget.selectionChange(selectedServices);
                    } else if (value == true &&
                        !selectedServices.contains(key)) {
                      print("no ready to add");
                      selectedServices.add(key);
                      widget.selectionChange(selectedServices);
                    }

                    setState(() {
                      _serviceList[key] = value;
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 1.5,
                ),
                SizedBox(
                  height: 10,
                ),
              ]);
            }).toList(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteTransition(
                      animationType: AnimationType.slide_right,
                      builder: (context) => SaloonServicesScreen(selectedServices:userSelectedServices,),
                  ),
                );
              },
              child: Text(
                "View all services",
                textAlign: TextAlign.end,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

