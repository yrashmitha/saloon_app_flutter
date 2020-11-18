import 'package:flutter/material.dart';
import 'package:helawebdesign_saloon/models/constants.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/widgets/saloon_screen/saloon_image_slider.dart';
import 'package:helawebdesign_saloon/widgets/saloon_screen/saloon_reviews.dart';
import 'package:helawebdesign_saloon/widgets/saloon_screen/saloon_secondary_data.dart';
import 'package:helawebdesign_saloon/widgets/saloon_screen/saloon_services.dart';
import 'package:provider/provider.dart';

class SaloonScreenData extends StatefulWidget {
  @override
  _SaloonScreenDataState createState() => _SaloonScreenDataState();
}

class _SaloonScreenDataState extends State<SaloonScreenData> {
  var loading = false;

  @override
  void initState() {
    setState(() {
      loading = true;
    });

    Future.delayed(Duration.zero).then((_) {
      Provider.of<SaloonsProvider>(context, listen: false)
          .getSelectedSaloonData()
          .then((_) {
        setState(() {
          loading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SaloonsProvider>(context);
    return loading
        ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(kMainYellowColor),
            ),
          )
        : Column(
            children: [
              SaloonSecondaryData(
                additionalData: provider.selectedSaloon.additionalData,
                description: provider.selectedSaloon.description,
              ),
              SizedBox(
                height: 20,
              ),
              SaloonServices(),
              SizedBox(
                height: 20,
              ),
              SaloonImageSlider(),
              SaloonReviews(),
            ],
          );
  }
}
