import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:helawebdesign_saloon/models/saloon.dart';
import 'package:helawebdesign_saloon/models/service.dart';
import 'package:helawebdesign_saloon/providers/appointment_provider.dart';
import 'package:provider/provider.dart';

class SaloonsProvider with ChangeNotifier {
  List<Saloon> _saloons = [];

  Saloon _selectedSaloon;

  bool _fromDrawer = false;

  bool get drawer {
    return _fromDrawer;
  }

  List<Saloon> _favouriteSaloons = [];


  List<Saloon> get getFavouriteSaloons {
    return _favouriteSaloons;
  }

  List<Service> allServices = [];

  List<Saloon> get getSaloons {
    return _saloons;
  }

  Saloon get selectedSaloon => _selectedSaloon;

  void setSelectedSaloon(Saloon value, BuildContext context) {
    print("saloon setted");
    _selectedSaloon = value;
    Provider.of<AppointmentProvider>(context, listen: false).clearServices();
  }

  List<Service> get getAllService => allServices;

  void setAllService(List<dynamic> value) {
    print("saloon setted");
    allServices = value;
  }

  List<Service> returnMyServicesArray(List arr) {
    List<Service> sList = [];
    arr.forEach((element) {
      sList.add(Service(
          id: element['id'],
          name: element['name'],
          description: element['description'],
          price: element['price']));
    });
    return sList;
  }

  Future<void> getSaloonsData(bool refresh) async {
    print("get saloon running");
    List<Saloon> sList = [];
    try {
      var r = await FirebaseFirestore.instance
          .collection('saloons')
          .orderBy('rating', descending: true).limit(5)
          .get()
          .then((QuerySnapshot querySnapshot) async {
        print("getting saloon finished");
        querySnapshot.docs.forEach((doc) {
          sList.add(Saloon(
            doc.id,
            doc.data()["name"],
            doc.data()["main-image_url"],
            "",
            doc.data()["base_location"],
            doc.data()["address"],
            doc.data()["gender"],
            "doc.data()['contact_number']",
            {},
            00,
            00,
            doc.data()['rating'].toDouble(),
            doc.data()['ratings_count'],
            00,
            [],
            [],
            [],
          ));
        });
      }).catchError((e) {
        print(e);
        throw e;
      });

      _saloons = sList;

      var f = await getMyFavourites();

      notifyListeners();
    } on PlatformException catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> getMyFavourites() async {
    print('favo saloons getting started from saloon providerrrr');
    final user = FirebaseAuth.instance.currentUser;
    List<Saloon> list = [];
    try {
      await FirebaseFirestore.instance
          .collection('users/${user.uid}/favourites')
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          list.add(Saloon(
            doc.id,
            doc.data()["name"],
            doc.data()["main-image_url"],
            "",
            doc.data()["base_location"],
            doc.data()["address"],
            doc.data()["gender"],
            "doc.data()['contact_number']",
            {},
            00,
            00,
            doc.data()['rating'],
            doc.data()['ratings_count'],
            00,
            [],
            [],
            [],
          ));
        });
        _favouriteSaloons = list;
      }).catchError((e) {
        print("err");
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> getSelectedSaloonData() async {
    try {
      await FirebaseFirestore.instance
          .collection('saloons/${selectedSaloon.id}/data')
          .doc(selectedSaloon.id)
          .get()
          .then((doc) {
        _selectedSaloon.description = doc.data()['description'];
        _selectedSaloon.additionalData = doc.data()["additional_data"];
        _selectedSaloon.contactNumber = doc.data()['contact_number'].toString();
        _selectedSaloon.openTime = doc.data()['open_time'];
        _selectedSaloon.closeTime = doc.data()['close_time'];
        _selectedSaloon.appointmentInterval =
        doc.data()['appointment_interval'];
        _selectedSaloon.services =
            returnMyServicesArray(doc.data()["services"]);
        selectedSaloon.smallGallery =
        doc.data()['gallery'] == null ? [] : doc.data()['gallery'];
        _selectedSaloon.reviews =
        doc.data()['reviews'] == null ? [] : doc.data()['reviews'];

        print(selectedSaloon.name);

        notifyListeners();
      }).catchError((e) {
        print(e);
        throw e;
      });
    } on PlatformException catch (e) {
      throw e;
    }
  }

  bool hasMore = true;
  DocumentSnapshot lastServicesSnapshot;

  Future<void> getMoreServices(String saloonId) async {
    List<Service> sList = [];
    if(hasMore){
      try {
        await FirebaseFirestore.instance
            .collection('saloons/$saloonId/all_services').
        orderBy('name',descending: true).startAfterDocument(lastServicesSnapshot).
        limit(5)
            .get()
            .then((QuerySnapshot querySnapshot) =>
        {
        if (querySnapshot.docs.length < 5) {
            hasMore = false,
            },
            lastServicesSnapshot= querySnapshot.docs[querySnapshot.size-1],
          querySnapshot.docs.forEach((doc) {
            sList.add(Service(
                id: doc.id,
                name: doc['name'],
                description: doc['description'],
                price: doc['price']));
          })
        })
            .catchError((onError) {
          print(onError);
        });
        allServices.addAll(sList);

        notifyListeners();
      } on PlatformException catch (e) {
        print(e.code);
      }
    }

    else{
      print('no services');
    }


  }


  Future<void> getAllServicesFromThisSaloon(String saloonId) async {
    List<Service> sList = [];
    await Firebase.initializeApp();
    try {
      await FirebaseFirestore.instance
          .collection('saloons/$saloonId/all_services').
          orderBy('name',descending: true).
      limit(5)
          .get()
          .then((QuerySnapshot querySnapshot) =>
      {
        lastServicesSnapshot= querySnapshot.docs[querySnapshot.size-1],
        querySnapshot.docs.forEach((doc) {
          sList.add(Service(
              id: doc.id,
              name: doc['name'],
              description: doc['description'],
              price: doc['price']));
        })
      })
          .catchError((onError) {
        print(onError);
      });
      allServices = sList;

      notifyListeners();
    } on PlatformException catch (e) {
      print(e.code);
    }
  }

  Future getAllSaloonGallery() async {
    List<String> list = [];
    try {
      return await FirebaseFirestore.instance
          .collection('saloons/${selectedSaloon.id}/all_images')
          .get()
          .then((value) {
        value.docs.forEach((e) {
          list.add(e['url']);
        });
        return list;
      }).catchError((err) {
        throw err;
      });
    } catch (err) {
      throw err;
    }
  }

  Future getAllReviews() async {
    List<dynamic> list = [];
    try {
      return await FirebaseFirestore.instance
          .collection('saloons/${selectedSaloon.id}/all_reviews').orderBy('date',descending: true)
          .get()
          .then((value) {
        value.docs.forEach((e) {
          list.add(e);
        });
        return list;
      }).catchError((err) {
        throw err;
      });
    } catch (err) {
      throw err;
    }
  }

  bool isThisFavourite() {
    bool x = false;
    _favouriteSaloons.forEach((element) {
      if (selectedSaloon.id == element.id) {
        print('this is a favourite saloon ${element.id}');
        x = true;
      }
    });
    return x;
  }


  Future<void> deleteSaloonFromFavourites() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
      return await FirebaseFirestore.instance
          .collection('users/${user.uid}/favourites/')
          .doc(selectedSaloon.id)
          .delete()
          .then((value) => print('Saloon deleted from favourites'))
          .catchError((e) {
        print('error occurred when deleting from favourites');
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> addToFavourites() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      await FirebaseFirestore.instance
          .collection('users/${user.uid}/favourites')
          .doc(selectedSaloon.id)
          .set({
        'id': selectedSaloon.id,
        'name': selectedSaloon.name,
        'main-image_url': selectedSaloon.featuredImageUrl,
        'base_location': selectedSaloon.baseLocation,
        'address': selectedSaloon.address,
        'rating': selectedSaloon.rating,
        'ratings_count': selectedSaloon.ratingsCount,
        // 'description': selectedSaloon.description,
        'gender': selectedSaloon.gender,
        // 'contact_number': selectedSaloon.contactNumber,
        // 'additional_data': selectedSaloon.additionalData,
        // 'open_time': selectedSaloon.openTime,
        // 'close_time': selectedSaloon.closeTime,
        // 'appointment_interval': selectedSaloon.appointmentInterval,
        //
        // 'services': services,
        // 'gallery': selectedSaloon.smallGallery,
        // 'reviews': selectedSaloon.reviews
      });
    } on PlatformException catch (e) {
      print(e.message);
    }

    // Saloon(
    //     doc.id,
    //     doc.data()["name"],
    //     doc.data()["main-image_url"],
    //     doc.data()["description"],
    //     doc.data()["base_location"],
    //     doc.data()["address"],
    //     doc.data()["gender"],
    //     doc.data()['contact_number'],
    //     doc.data()["additional_data"],
    //     doc.data()['open_time'],
    //     doc.data()['close_time'],
    //     doc.data()['appointment_interval'],
    //     returnMyServicesArray(doc.data()["services"]),
    //     doc.data()['gallery'] == null
    //         ? []
    //         : doc.data()['gallery'],
    //     doc.data()['reviews'] == null
    //         ? []
    //         : doc.data()['reviews']),
    return "added to favo";
  }

  void heartIconTapped() {
    bool favo = isThisFavourite();
    if (favo) {
      deleteSaloonFromFavourites().then((value) {
        _favouriteSaloons.removeWhere((element) {
          return element.id == selectedSaloon.id;
        });
        notifyListeners();
      });
    } else {
      addToFavourites().then((value) {
        _favouriteSaloons.add(selectedSaloon);
        notifyListeners();
      });
    }
  }



  Future<void> searchByCategory(String key) async {
    print('categori search');
    try {
      return await FirebaseFirestore.instance
          .collection('saloons')
          .where('categories', arrayContainsAny: [key]).get();
    } on PlatformException catch (e) {
      print(e.message);
    }
  }


  List<QueryDocumentSnapshot> list = [];
  bool isDataReady=false;

  // Future<void> search(String city, String category, String gender) async {
  //   list=[];
  //   isDataReady=false;
  //   notifyListeners();
  //   if (city == "") {
  //     city = null;
  //   }
  //   if (category == "") {
  //     category = null;
  //   }
  //   if (gender == "") {
  //     gender = null;
  //   }
  //
  //   try {
  //     log("data getting search");
  //     return await FirebaseFirestore.instance
  //         .collection('saloons')
  //         .where('base_location', isEqualTo: city).
  //     where('gender', isEqualTo: gender).
  //     where(
  //         'categories', arrayContainsAny: category == null ? null : [category]).
  //     get().then((value) {
  //       value.docs.forEach((element) {
  //         list.add(element);
  //       });
  //       isDataReady=true;
  //       notifyListeners();
  //     }
  //   );
  //
  //   } on PlatformException catch (e) {
  //   print(e.message);
  //   }
  // }

  Query searchQuery(String city, String category, String gender){
    return FirebaseFirestore.instance
        .collection('saloons')
        .where('base_location', isEqualTo: city).
    where('gender', isEqualTo: gender).
    where(
        'categories', arrayContainsAny: category == null ? null : [category]);
  }

  Future<void> searchByName(String key) async {
    list=[];
    isDataReady=false;
    notifyListeners();
    print('search by name');

    try {
      return await FirebaseFirestore.instance
          .collection('saloons')
          .where('lower_case', isEqualTo: key)
          .get().then((value) {
        value.docs.forEach((element) {
          list.add(element);
        });
        isDataReady=true;
        notifyListeners();
      }
      );
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> addSaloon() async {
    await FirebaseFirestore.instance.collection('saloons').add({
      'base_location': 'Colombo',
      "name": "Nipuni Fashion test",
      'address': 'No 120 Kottawa Rd Samanpura Piliyandala',
      "gender": "FEMALE",
      "main-image_url":
      "https://firebasestorage.googleapis.com/v0/b/saloonapp-c93ca.appspot.com/o/wedding.jpg?alt=media&token=d1283eb7-99dc-4d2a-a53a-eda50cc99af0",
      "ratings_count": 283,
      "rating": 4.5,
      "lower_case": "nipuni fashion",
      "categories": [
        "HAIR CUT",
        "WAXING",
        "MASSAGE",
        "GROOM",
      ],
    }).then((docRef) async {
      return await FirebaseFirestore.instance
          .collection('saloons/${docRef.id}/data')
          .doc(docRef.id)
          .set({
        "appointment_interval": 120,
        "description": "i am description Nuwara eliya",
        "open_time": 10,
        "services": [
          {
            "price": 80000,
            "name": "Wedding Planning",
            "description": "We plan your wedding suite",
            "id": "ye3YxNBLXhZ3Zf6ETbOO"
          }
        ],
        "close_time": 19,
        "contact_number": 0752110342,
        "additional_data": {
          "parking": true,
          "reviews": [{}],
          "open_hours": {"Monday": "8:00 AM - 6:00 PM"},
          "is_verified": true,
          "membership_type": "Freemium",
          "washroom": true
        },
        "gallery": [
          "https://firebasestorage.googleapis.com/v0/b/saloonapp-c93ca.appspot.com/o/wedding.jpg?alt=media&token=d1283eb7-99dc-4d2a-a53a-eda50cc99af0"
        ]
      });
    });
  }

  Future<void> addReview() async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('reviews').add({
      "user_id": user.uid,
      "star": 4
    });
  }
}
