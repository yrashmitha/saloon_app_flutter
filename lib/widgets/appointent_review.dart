import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/providers/appointment_provider.dart';
import 'package:provider/provider.dart';

class AppointmentReview extends StatefulWidget {
  final String appId;
  final String saloonId;
  AppointmentReview({this.appId,this.saloonId});
  @override
  _AppointmentReviewState createState() => _AppointmentReviewState();
}

class _AppointmentReviewState extends State<AppointmentReview> {
  final _form = GlobalKey<FormState>();
  bool loading=false;

  Future<bool> saveForm() async {
    final isValid = _form.currentState.validate();
    if (isValid) {
      if(star>0){
        setState(() {
          loading=true;
        });
        Provider.of<AppointmentProvider>(context,listen: false).postReview(context, star, review, widget.appId,widget.saloonId).
        then((value){
          setState(() {
            loading=false;
          });
          Navigator.pop(context,true);
        });
      }

      // await Provider.of<UserProvider>(context, listen: false).updateUser(val).then((value){
      //   final snackBar = SnackBar(
      //     content: Text(
      //       'Updated successfully!',
      //     ),
      //     backgroundColor: kMainYellowColor,
      //     duration: Duration(seconds: 2),
      //   );
      //   Scaffold.of(context)
      //       .showSnackBar(snackBar);
      // }).catchError((onError){
      //   final snackBar = SnackBar(
      //     content: Text(
      //       'Update Failed!',
      //     ),
      //     backgroundColor: Colors.redAccent,
      //     duration: Duration(seconds: 2),
      //   );
      //
      //   Scaffold.of(context)
      //       .showSnackBar(snackBar);
      // });
    }
    return false;
  }

  int star = 0;
  String review;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingBar.builder(
          initialRating: 0,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
            size: 2,
          ),
          onRatingUpdate: (rating) {
            star=rating.toInt();
          },
        ),
        Form(
          key: _form,
          child: TextFormField(
            decoration: InputDecoration(
              hintText: 'Enter your review here',
            ),
            maxLines: 5,
            validator: (val) {
              if (val.isEmpty || val.length < 3) {
                return 'Please enter enough review';
              }
              review = val;
              return null;
            },
          ),
        ),
        loading ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(kMainYellowColor),),)
            :
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RaisedButton(
              onPressed: () {
                saveForm();
              },
              child: Text("Send"),
              color: kMainYellowColor,
            ),
            RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            )
          ],
        )
      ],
    ));
  }
}
