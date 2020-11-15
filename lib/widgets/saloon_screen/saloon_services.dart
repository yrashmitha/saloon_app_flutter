import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/models/service.dart';
import 'package:helawebdesign_saloon/providers/appointment_provider.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/screens/saloon_services_screen.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';

class SaloonServices extends StatefulWidget {
  Function selectionChange;

  SaloonServices({this.selectionChange});

  @override
  _SaloonServicesState createState() => _SaloonServicesState();
}

class _SaloonServicesState extends State<SaloonServices> {

  AppointmentProvider appointmentProvider;


  Map<Service,bool> createServiceList(List<Service> list){
    Map<Service,bool> map={};
    list.forEach((element) {
      map.addAll({element:false});
    });
    return map;
  }


  List<Service> selectedServices;

  void selectedServicesFunc(Service s) {
    bool x= appointmentProvider.isServiceInTheArray(s);
    if(x){
      print('item already in the array');
      appointmentProvider.removeService(s);
    }
    else{
      print('item not in the array so we added');
      appointmentProvider.addService(s);
    }
  }



  List<Service> get userSelectedServices {
    return [...selectedServices];
  }
  Map<Service,bool> _serviceList={};
  @override
  void initState() {
     appointmentProvider = Provider.of<AppointmentProvider>(context,listen: false);
    selectedServices = appointmentProvider.getUserSelectedService;
    Future.delayed(Duration.zero).then((_) {
      _serviceList = createServiceList(Provider.of<SaloonsProvider>(context,listen: false).selectedSaloon.services);
    });
    super.initState();
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
                new ListTile(
                  leading: Icon(FontAwesomeIcons.cut,
                    color: kDeepBlue,),
                  title: Text(key.name),
                  subtitle:Text(key.description),
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
                    maintainState: true,
                      animationType: AnimationType.slide_right,
                      builder: (context) => SaloonServicesScreen(),
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

