import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uber_app/mainScreens/home_screen.dart';

import '../assistantmethodseller/get_current_location.dart';
import '../global/global.dart';
import '../maps/map_utilities.dart';

class ParcelDeliveringScreen extends StatefulWidget {
  String? purchaserId;
  String? purchaserAddress;
  double? purchaserLat;
  double? purchaserLng;
  String? sellerId;
  String? getOrderId;

  ParcelDeliveringScreen({
    this.purchaserId,
    this.purchaserAddress,
    this.purchaserLat,
    this.purchaserLng,
    this.sellerId,
    this.getOrderId,
  });

  @override
  _ParcelDeliveringScreenState createState() => _ParcelDeliveringScreenState();
}

class _ParcelDeliveringScreenState extends State<ParcelDeliveringScreen> {
  String orderTotalAmount = "";

  confirmParcelHasBeenDelivered(getOrderId, sellerId, purchaserId, purchaserAddress, purchaserLat, purchaserLng) {
    FirebaseFirestore.instance.collection("orders").doc(getOrderId).update({
      "status": "ended",
      "address": completeAddress,
      "lat": position!.latitude,
      "lng": position!.longitude,
      "earnings": "", //pay per parcel delivery amount
    }).then((value) {}).then((value) {
      FirebaseFirestore.instance.collection("sellers").doc(widget.sellerId).update({
        "earnings": (double.parse(orderTotalAmount) + (double.parse(previousEarnings))).toString(), //total earnings amount of seller
      });
    }).then((value) {
      FirebaseFirestore.instance.collection("users").doc(purchaserId).collection("orders").doc(getOrderId).update({
        "status": "ended",
        "sellerUID": sharedPreferences!.getString("uid"),
      });
    });

    Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
  }

  getOrderTotalAmount() {
    FirebaseFirestore.instance.collection("orders").doc(widget.getOrderId).get().then((snap) {
      orderTotalAmount = snap.data()!["totalAmount"].toString();
      widget.sellerId = snap.data()!["sellerUID"].toString();
    }).then((value) {
      getSellerData();
    });
  }

  getSellerData() {
    FirebaseFirestore.instance.collection("sellers").doc(widget.sellerId).get().then((snap) {
      previousEarnings = snap.data()!["earnings"].toString();
    });
  }

  @override
  void initState() {
    super.initState();

    // rider location update
    UserLocation uLocation = UserLocation();
    uLocation.getCurrentLocation();

    getOrderTotalAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "images/confirm2.png",
          ),
          const SizedBox(height: 5,),
          GestureDetector(
            onTap: () {
              // Use url_launcher to open Google Maps
              _launchMaps(widget.purchaserLat, widget.purchaserLng);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/restaurant.png',
                  width: 50,
                ),
                const SizedBox(width: 7,),
                Column(
                  children: const [
                    SizedBox(height: 12,),
                    Text(
                      "Show Customer Location",
                      style: TextStyle(
                        fontFamily: "Signatra",
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 40,),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  // rider location update
                  UserLocation uLocation = UserLocation();
                  uLocation.getCurrentLocation();

                  // confirmed - that rider has picked parcel from seller
                  confirmParcelHasBeenDelivered(
                    widget.getOrderId,
                    widget.sellerId,
                    widget.purchaserId,
                    widget.purchaserAddress,
                    widget.purchaserLat,
                    widget.purchaserLng,
                  );
                },
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.cyan,
                        Colors.greenAccent,
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width - 90,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Order has been Delivered - Confirm",
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to launch Google Maps with the customer's location
  _launchMaps(double? lat, double? lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
