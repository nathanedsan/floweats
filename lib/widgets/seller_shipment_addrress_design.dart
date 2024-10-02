import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uber_app/mainScreens/home_screen.dart';

import '../assistantmethodseller/get_current_location.dart';
import '../global/global.dart';
import '../mainScreens/parcel_picking_screen.dart';
import '../models/address.dart';

class SShipmentAddressDesign extends StatelessWidget {
  final Address? model;
  final String? orderStatus;
  final String? orderId;
  final String? sellerId;
  final String? orderByUser;

  SShipmentAddressDesign(
      {this.model, this.orderStatus, this.orderId, this.sellerId, this.orderByUser});

  confirmedParcelShipment(BuildContext context, String getOrderID, String sellerId,
      String purchaserId) {
    FirebaseFirestore.instance.collection("orders").doc(getOrderID).update({
      "status": "picking",
      "lat": position!.latitude,
      "lng": position!.longitude,
      "address": completeAddress,
    });

    // Update user's order status
    FirebaseFirestore.instance.collection("users").doc(purchaserId).collection('orders').doc(getOrderID).update({
      "status": "picking",
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParcelPickingScreen(
          purchaserId: purchaserId,
          purchaserAddress: model!.fullAddress,
          purchaserLat: model!.lat,
          purchaserLng: model!.lng,
          sellerId: sellerId,
          getOrderID: getOrderID,
        ),
      ),
    );
  }

  declineOrder(BuildContext context, String getOrderID) {
    FirebaseFirestore.instance.collection("orders").doc(getOrderID).update({
      "status": "declined",
    });

    // Update user's order status
    FirebaseFirestore.instance.collection("users").doc(orderByUser).collection('orders').doc(getOrderID).update({
      "status": "declined",
    });

    // Additional logic or navigation after declining the order if needed
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Shipping Details:',
              style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(
          height: 6.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(
                children: [
                  const Text("Name", style: TextStyle(color: Colors.black)),
                  Text(model!.name!),
                ],
              ),
              TableRow(
                children: [
                  const Text("Phone Number",
                      style: TextStyle(color: Colors.black)),
                  Text(model!.phoneNumber!),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            model!.fullAddress!,
            textAlign: TextAlign.justify,
          ),
        ),
        orderStatus == "ended"
            ? Container()
            : Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  UserLocation uLocation = UserLocation();
                  uLocation.getCurrentLocation();

                  confirmedParcelShipment(
                      context, orderId!, sellerId!, orderByUser!);
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
                  width: (MediaQuery.of(context).size.width - 40) / 2 - 10,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Confirm - To Deliver",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  declineOrder(context, orderId!);
                },
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.red,
                        Colors.orange,
                      ],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  width: (MediaQuery.of(context).size.width - 40) / 2 - 10,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Decline Order",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()));
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
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: const Center(
                  child: Text(
                    "Go Back",
                    style: TextStyle(color: Colors.white, fontSize: 15.0),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
