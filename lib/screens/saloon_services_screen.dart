import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/models/service.dart';
import 'package:helawebdesign_saloon/screens/appointment_book.dart';
import 'package:route_transitions/route_transitions.dart';

class SaloonServicesScreen extends StatefulWidget {
  List<Service> selectedServices;

  SaloonServicesScreen({@required this.selectedServices});

  @override
  _SaloonServicesScreenState createState() => _SaloonServicesScreenState();
}

class _SaloonServicesScreenState extends State<SaloonServicesScreen> {

  double finalPrice=0;

  List<Service> selectedServices=[];

  void filterServices(
      List<Service> selectedServices, Map<Service, bool> allServices) {
    selectedServices.forEach((element) {
      print("my id is ${(element.id)} and name is ${element.name}");
      allServices.forEach((key, value) {
        if (element.id == key.id) {
          finalPrice=finalPrice+key.price;
          allServices[key] = true;
        }
      });
    });
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

  List<Service> getSelectedServices(){
    _serviceList.forEach((key, value) {
      if(value ==true){
        selectedServices.add(key);
      }
    });
    return selectedServices;
  }


  @override
  void initState() {
    super.initState();
    filterServices(widget.selectedServices, _serviceList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Services"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
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
                      setState(() {
                        _serviceList[key] = value;
                        finalPrice= finalPrice + key.price;
                      });
                    },
                  ),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Rs. ${key.price.toString()}",
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
                ]);
              }).toList(),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.grey.withOpacity(.5), width: 1),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .09,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text("Rs. ${finalPrice.toStringAsFixed(2)}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteTransition(
                      animationType: AnimationType.slide_right,
                      builder: (context) => AppointmentBookingScreen(getSelectedServices(),finalPrice),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: kDeepBlue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: MediaQuery.of(context).size.width * .3,
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
    );
  }
}
