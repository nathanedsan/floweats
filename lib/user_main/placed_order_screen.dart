import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber_app/user_main/user_home.dart';

import '../assistantMethod/assistant_method.dart';
import '../global/global.dart';
import '../mainScreens/home_screen.dart';

class PlacedOrderScreen extends StatefulWidget {
  String? addressID;
  double? totalAmount;
  String? sellerUID;

  PlacedOrderScreen({this.sellerUID, this.totalAmount, this.addressID});

  @override
  _PlacedOrderScreenState createState() => _PlacedOrderScreenState();
}

class _PlacedOrderScreenState extends State<PlacedOrderScreen> {
  String orderId = DateTime.now().millisecondsSinceEpoch.toString();

  String selectedPaymentMethod = "Cash on Delivery";

  Future<void> _showPaymentDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Payment Method'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  title: const Text('Cash on Delivery'),
                  onTap: () {
                    setState(() {
                      selectedPaymentMethod = 'Cash on Delivery';
                    });
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Card Payment'),
                  onTap: () {
                    setState(() {
                      selectedPaymentMethod = 'Card Payment';
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  addOrderDetails() {
    writeOrderDetailsForUser({
      "addressID": widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": selectedPaymentMethod,
      "orderTime": orderId,
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "riderUID": "",
      "status": "normal",
      "orderId": orderId,
    });

    writeOrderDetailsForSeller({
      "addressID": widget.addressID,
      "totalAmount": widget.totalAmount,
      "orderBy": sharedPreferences!.getString("uid"),
      "productIDs": sharedPreferences!.getStringList("userCart"),
      "paymentDetails": selectedPaymentMethod,
      "orderTime": orderId,
      "isSuccess": true,
      "sellerUID": widget.sellerUID,
      "riderUID": "",
      "status": "normal",
      "orderId": orderId,
    }).whenComplete(() {
      clearCartNow(context);
      setState(() {
        orderId = "";
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const UHomeScreen()));
        Fluttertoast.showToast(
            msg: "Congratulations, Order has been placed successfully.");
      });
    });
  }

  Future writeOrderDetailsForUser(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(sharedPreferences!.getString("uid"))
        .collection("orders")
        .doc(orderId)
        .set(data);
  }

  Future writeOrderDetailsForSeller(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection("orders").doc(orderId).set(data);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.amber,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/delivery.jpg"),
            const SizedBox(height: 12,),
            ElevatedButton(
              child: const Text("Choose Payment Method"),
              style: ElevatedButton.styleFrom(
                primary: Colors.cyan,
              ),
              onPressed: () {
                _showPaymentDialog();
              },
            ),
            const SizedBox(height: 12,),
            ElevatedButton(
              child: const Text("Place Order"),
              style: ElevatedButton.styleFrom(
                primary: Colors.cyan,
              ),
              onPressed: () {
                addOrderDetails();
              },
            ),
          ],
        ),
      ),
    );
  }
}
