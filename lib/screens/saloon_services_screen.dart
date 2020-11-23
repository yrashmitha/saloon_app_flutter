import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/models/service.dart';
import 'package:helawebdesign_saloon/providers/appointment_provider.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/screens/appointment_book.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:route_transitions/route_transitions.dart';

class SaloonServicesScreen extends StatefulWidget {
  static String id = 'saloon-service-screen';

  @override
  _SaloonServicesScreenState createState() => _SaloonServicesScreenState();
}

class _SaloonServicesScreenState extends State<SaloonServicesScreen> {
  AppointmentProvider appointmentProvider;
  double finalPrice = 0;

  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();

  var loading = false;

  List<Service> selectedServices;

  void filterServices(List<Service> selectedServices,
      Map<Service, bool> allServices) {
    selectedServices.forEach((element) {
      allServices.forEach((key, value) {
        if (element.id == key.id) {
          finalPrice = finalPrice + key.price;
          allServices[key] = true;
        }
      });
    });
  }

  void selectedServicesFunc(Service s) {
    bool x = appointmentProvider.isServiceInTheArray(s);
    if (x) {
      appointmentProvider.removeService(s);
    } else {
      appointmentProvider.addService(s);
    }
  }

  Map<Service, bool> _serviceList = {};

  List<Service> getSelectedServices() {
    _serviceList.forEach((key, value) {
      if (value == true) {
        selectedServices.add(key);
      }
    });
    return selectedServices;
  }

  Map<Service, bool> createServiceMap(List<Service> list) {
    Map<Service, bool> map = {};
    list.forEach((element) {
      map.addAll({element: false});
    });
    return map;
  }





  Map<Service,bool> serviceMap={};

  void createObjectAndInsertToMap(DocumentSnapshot snapshot){
    Service s = Service(id:snapshot.id,name: snapshot.data()['name'],description: snapshot.data()['description'],price: snapshot.data()['price']);
    serviceMap.addAll({s:false});
  }





  @override
  void initState() {

    super.initState();
    Future.delayed(Duration.zero).then((_) {
      final saloonProvider =
      Provider.of<SaloonsProvider>(context, listen: false);
      final saloonId = saloonProvider.selectedSaloon.id;
      setState(() {
        _serviceList=createServiceMap(saloonProvider.selectedSaloon.services);
      });
      // saloonProvider.getAllServicesFromThisSaloon(saloonId).then((value) {
      //   setState(() {
      //     _serviceList = createServiceMap(saloonProvider.getAllService);
      //     filterServices(selectedServices, _serviceList);
      //     loading = false;
      //   });
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    final globalKey = GlobalKey<ScaffoldState>();
    appointmentProvider = Provider.of<AppointmentProvider>(context);
    final saloonProvider= Provider.of<SaloonsProvider>(context);
    final saloonId= saloonProvider.selectedSaloon.id;
    return WillPopScope(
      onWillPop: () async {
        appointmentProvider.clearServices();
        Navigator.pop(context);
        return;
      },
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(
          title: Text("Select Services"),
        ),
        body: loading
            ? Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: _serviceList.keys.map((Service key){
                  return Column(
                    children: [
                      CheckboxListTile(
                        secondary: Icon(
                          FontAwesomeIcons.cut,
                          color: kDeepBlue,
                        ),
                        subtitle: Text(key.name),
                        contentPadding: EdgeInsets.symmetric(horizontal: 0),
                        title: new Text(key.name),
                        value: _serviceList[key],
                        onChanged: (bool value) {
                          selectedServicesFunc(key);
                          setState(() {
                            _serviceList[key] = value;
                            finalPrice = finalPrice +
                                (value == true ? key.price : (-key.price));
                          });
                        },
                      ),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            "Rs. ${key.price.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: kDeepBlue),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 1.5,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                }).toList(),
              )
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.withOpacity(.5), width: 1),
            ),
          ),
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height * .09,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Rs. ${finalPrice.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (appointmentProvider.getUserSelectedService.length > 0) {
                      Navigator.push(
                        context,
                        PageRouteTransition(
                          maintainState: true,
                          animationType: AnimationType.slide_right,
                          builder: (context) =>
                              AppointmentBookingScreen(price: finalPrice),
                        ),
                      );
                    }
                    else {
                      globalKey.currentState.showSnackBar(
                        SnackBar(
                            content: Text('Please select at least one service',style: TextStyle(fontFamily: 'Montserrat'),),
                            backgroundColor: Colors.redAccent,
                            elevation: 5,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(5))
                            )
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: kDeepBlue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * .3,
                    child: Center(
                      child: Text(
                        "Next",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// CheckboxListTile(
// secondary: Icon(
// FontAwesomeIcons.cut,
// color: kDeepBlue,
// ),
// subtitle: Text(snapshot.data()['name']),
// contentPadding: EdgeInsets.symmetric(horizontal: 0),
// title: new Text(key.name),
// value: _serviceList[key],
// onChanged: (bool value) {
// selectedServicesFunc(key);
// setState(() {
// _serviceList[key] = value;
// finalPrice = finalPrice +
// (value == true ? key.price : (-key.price));
// });
// },
// ),