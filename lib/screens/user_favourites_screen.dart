import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:helawebdesign_saloon/models/saloon.dart';
import 'package:helawebdesign_saloon/providers/saloons_provider.dart';
import 'package:helawebdesign_saloon/screens/saloon_screen.dart';
import 'package:helawebdesign_saloon/widgets/saloon_card.dart';
import 'package:provider/provider.dart';

class UserFavouritesScreen extends StatelessWidget {
  void setSelectedSaloon(Saloon id, BuildContext context) {
    Provider.of<SaloonsProvider>(context, listen: false)
        .setSelectedSaloon(id, context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SaloonsProvider>(context);
    print(provider.getFavouriteSaloons.length);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
          body: ListView.builder(
              itemCount: provider.getFavouriteSaloons.length,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    setSelectedSaloon(
                        provider.getFavouriteSaloons[index], context);
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return SaloonScreen(
                            saloonName:
                                provider.getFavouriteSaloons[index].name,
                            saloon: provider.getFavouriteSaloons[index],
                          );
                        },
                      ),
                    );
                  },
                  child: SaloonCard(
                    saloon: provider.getFavouriteSaloons[index],
                  ),
                );
              })),
    );
  }
}
