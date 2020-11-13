import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:helawebdesign_saloon/main.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/providers/auth_provider.dart';
import 'package:helawebdesign_saloon/providers/user_provider.dart';
import 'package:provider/provider.dart';

class MyAccountScreen extends StatefulWidget {
  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  final _form = GlobalKey<FormState>();
  String mobileNumber;
  bool loading = false;

  bool isInit = true;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    print("init state");
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<bool> saveForm(val) async {
    final isValid = _form.currentState.validate();
    if (isValid) {
      await Provider.of<UserProvider>(context, listen: false).updateUser(val).then((value){
        final snackBar = SnackBar(
          content: Text(
            'Updated successfully!',
          ),
          backgroundColor: kMainYellowColor,
          duration: Duration(seconds: 2),
        );
        Scaffold.of(context)
            .showSnackBar(snackBar);
      }).catchError((onError){
        final snackBar = SnackBar(
          content: Text(
            'Update Failed!',
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        );

        Scaffold.of(context)
            .showSnackBar(snackBar);
      });
    }
    return false;
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      setState(() {
        loading = true;
      });
      Provider.of<UserProvider>(context).getUser().then((_) {
        setState(() {
          loading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("account build");
    final userProvider = Provider.of<UserProvider>(context);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = userProvider.accountUser;

    return loading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    height: 250,
                    width: double.infinity,
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      placeholder: (ctx, url) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      width: MediaQuery.of(context).size.width,
                      imageUrl: user.photoUrl,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(16.0),
                              margin: EdgeInsets.only(top: 16.0),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [kMainYellowColor, Colors.white]),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.only(left: 96.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          user.name,
                                          style:
                                              Theme.of(context).textTheme.title,
                                        ),
                                        ListTile(
                                          contentPadding: EdgeInsets.all(0),
                                          title: const Text("Member Since"),
                                          subtitle: Text(
                                              "${user.memberSince.year}-${user.memberSince.month}-${user.memberSince.day}"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Icon(FontAwesomeIcons.smile),
                                            Text("Welcome ${user.name}"),
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Icon(FontAwesomeIcons.clock),
                                            Text(
                                                "Last sign in on ${user.lastSignInTime.year}-${user.lastSignInTime.month}-${user.lastSignInTime.day} | ${user.lastSignInTime.hour}:${user.lastSignInTime.minute}"),
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 2, color: Colors.white),
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                      image: NetworkImage(user.photoUrl),
                                      fit: BoxFit.cover)),
                              margin: EdgeInsets.only(left: 16.0),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text("User information"),
                              ),
                              Divider(),
                              ListTile(
                                title: Text("Email"),
                                subtitle: Text(user.email),
                                leading: Icon(Icons.email),
                              ),
                              ListTile(
                                title: Text("Phone"),
                                subtitle: Text(
                                    user.phoneNumber != null
                                        ? user.phoneNumber
                                        : "Oopz please enter your phone number",
                                    style: user.phoneNumber != null
                                        ? TextStyle(color: Colors.black)
                                        : TextStyle(color: Colors.red)),
                                leading: Icon(Icons.phone),
                              ),
                              user.phoneNumber == null
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Form(
                                        key: _form,
                                        child: TextFormField(
                                          textInputAction: TextInputAction.done,
                                          onSaved: (val) {
                                            print("i m form on saver $val");
                                            mobileNumber = val;
                                          },
                                          validator: (val) {
                                            if (val.isEmpty ||
                                                val.length < 10) {
                                              return 'Enter valid mobile number';
                                            }

                                            return null;
                                          },
                                          onFieldSubmitted: (val) {
                                            saveForm(val);
                                          },
                                          keyboardType: TextInputType.phone,
                                          decoration: new InputDecoration(
                                            isDense: true,
                                            hintText: "Enter mobile number",
                                            contentPadding:
                                                const EdgeInsets.all(0),
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(),
                              OutlineButton(
                                onPressed: () {
                                  auth.signOutGoogle();
                                },
                                child: Text("Log Out"),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
