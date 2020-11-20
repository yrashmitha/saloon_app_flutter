import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/constants.dart';

class MyDrawer extends StatefulWidget {

  final Function func;

  MyDrawer({this.func});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String _gender = "";
  String _location = "";
  String _category = "";

  final ScrollController _scrollController = ScrollController(
      initialScrollOffset: 0);
  final ScrollController _scrollController2 = ScrollController(
      initialScrollOffset: 0);

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView(
        children: [
          Container(

              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(icon: Icon(Icons.clear), onPressed: () {
                    Navigator.pop(context);
                  },),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:15,horizontal: 10),
                    child: Text("Select Gender", style: kSaloonName,),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Radio(
                                value: "MALE",
                                groupValue: _gender,
                                onChanged: (val) {
                                  log(val.toString());
                                  setState(() {
                                    _gender = val;
                                  });
                                }),
                            Text("Male")
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Radio(
                                value: "FEMALE",
                                groupValue: _gender,
                                onChanged: (val) {
                                  log(val.toString());
                                  setState(() {
                                    _gender = val;
                                  });
                                }),
                            Text("Female")
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Radio(
                                value: "BOTH",
                                groupValue: _gender,
                                onChanged: (val) {
                                  log(val.toString());
                                  setState(() {
                                    _gender = val;
                                  });
                                }),
                            Text("Both")
                          ],
                        ),
                      )
                    ],
                  ),


                  SizedBox(height: 10,),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:15,horizontal: 10),
                    child: Text("Select Location", style: kSaloonName,),
                  ),

                  Container(
                    height: 300,
                    child: Scrollbar(
                      controller: _scrollController,
                      isAlwaysShown: true,
                      thickness: 7,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemBuilder: (ctx, index) {
                            return RadioListTile(value: kCityList[index],
                                groupValue: _location,
                                title: Text(kCityList[index]),
                                onChanged: (value) {
                                  setState(() {
                                    _location = value;
                                  });
                                  log(kCityList[index]);
                                });
                          },
                          itemCount: kCityList.length,
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical:15,horizontal: 10),
                    child: Text("Select Category", style: kSaloonName,),
                  ),
                  Container(
                    height: 300,
                    child: Scrollbar(
                      controller: _scrollController2,
                      isAlwaysShown: true,
                      thickness: 7,

                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          controller: _scrollController2,
                          itemBuilder: (ctx, index) {
                            return RadioListTile(value: catList[index].key,
                                groupValue: _category,
                                title: Text(catList[index].title),
                                onChanged: (value) {
                                  setState(() {
                                    _category = value;
                                  });
                                  log(_category);
                                });
                          },
                          itemCount: catList.length,
                        ),
                      ),
                    ),
                  ),

                  Center(child: RaisedButton(onPressed: (){
                    Navigator.pop(context);
                    widget.func(_gender,_category,_location);
                  },child: Text("Filter"),color:kMainYellowColor,))

                ],
              )),
        ],
      ),
    );
  }
}

enum Gender { MALE, FEMALE, BOTH }

