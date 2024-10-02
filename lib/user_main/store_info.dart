import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uber_app/user_main/Booking_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';

import '../Guest_widget/guest_app_bar.dart';
import '../models/sellers.dart';
import '../user_widget/app_bar.dart';
import 'menu_screen_user.dart';


class StoreInfo extends StatefulWidget {
  final Sellers? model;

  StoreInfo({this.model});

  @override
  State<StoreInfo> createState() => _StoreInfoState();
}

class _StoreInfoState extends State<StoreInfo> {
  Sellers? seller;
  int numberOfPeople = 0;

  @override
  void initState() {
    super.initState();
    fetchSellerInfo();
  }

  Future<void> fetchSellerInfo() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('sellers')
          .doc(widget.model!.sellerUID)
          .get();

      if (snapshot.exists) {
        setState(() {
          seller = Sellers.fromJson(snapshot.data()! as Map<String, dynamic>);
        });
      }
    } catch (e) {
      print("Error getting seller information: $e");
    }
  }

  Future<void> fetchNumberOfPeople() async {
    try {
      var dataSnapshot = await FirebaseDatabase.instance.reference().child('people_count').once();
      setState(() {
        numberOfPeople = (dataSnapshot.snapshot.value as int?) ?? 0;
      });
    } catch (e) {
      print("Error getting number of people: $e");
    }
  }

  Future<void> launchGoogleMaps(double latitude, double longitude) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  void onCuteButtonPressed() {
    print('Cute button pressed!');
  }

  void onMenuButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MenusScreen(model: widget.model)),
    );
  }

  void onBookingButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Bookingscreen(model: widget.model,)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: seller != null
          ? Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (seller!.sellerAvatarUrl != null)
            CircleAvatar(
              backgroundImage: NetworkImage(seller!.sellerAvatarUrl!),
              radius: 80,
            ),
          Text(
            'Seller Name: ${seller!.sellerName}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Varela',
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Email: ${seller!.sellerEmail}',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Varela',
            ),
            textAlign: TextAlign.center,
          ),
          if (seller!.phone != null)
            Text(
              'Phone: ${seller!.phone!}',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Varela',
              ),
              textAlign: TextAlign.center,
            ),
          if (seller!.Address != null)
            TextButton(
              onPressed: () {
                launchGoogleMaps(
                  seller!.Lat!,
                  seller!.Lng!,
                );
              },
              child: Text(
                'Location: ${seller!.Address!}',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Varela',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ElevatedButton(
            onPressed: () {
              fetchNumberOfPeople();
            },
            child: Text(
              'Queue',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Text(
            'Number of people: $numberOfPeople',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Varela',
            ),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: onMenuButtonPressed,
            child: Text(
              'Menu',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: onBookingButtonPressed,
            child: Text(
              'Book Now',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      )
          : Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
