import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber_app/user_widget/app_bar.dart'; // Import your app bar widget
import 'package:url_launcher/url_launcher.dart';
import '../Guest_widget/guest_app_bar.dart';
import '../models/sellers.dart';

class Gstoreinfo extends StatefulWidget {
  Sellers? model;

  Gstoreinfo({this.model});

  @override
  State<Gstoreinfo> createState() => _GstoreinfoState();
}

class _GstoreinfoState extends State<Gstoreinfo> {
  Sellers? seller;
  late GoogleMapController mapController;

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

  // Function to launch Google Maps with the specified location coordinates
  Future<void> launchGoogleMaps(double latitude, double longitude) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  // Function to handle the "Cute" button press
  void onCuteButtonPressed() {
    // Add your cute button logic here
    print('Cute button pressed!');
    // You can add more functionality as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GMyAppBar(), // Replace with your app bar widget
      body: seller != null
          ? Column(
        children: [
          // Display larger seller avatar if available
          if (seller!.sellerAvatarUrl != null)
            CircleAvatar(
              backgroundImage: NetworkImage(seller!.sellerAvatarUrl!),
              radius: 80,
            ),
          // Increase the font size for seller information
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
          // Show phone if available
          if (seller!.phone != null)
            Text(
              'Phone: ${seller!.phone!}',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Varela',
              ),
              textAlign: TextAlign.center,
            ),
          // Show address if available
          if (seller!.Address != null)
            Text(
              'Address: ${seller!.Address!}',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Varela',
              ),
              textAlign: TextAlign.center,
            ),
          // Show location on Google Map
          if (seller!.Lat != null && seller!.Lng != null)
            Container(
              height: 200,
              child: GoogleMap(
                onMapCreated: (controller) {
                  setState(() {
                    mapController = controller;
                  });
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(seller!.Lat!, seller!.Lng!),
                  zoom: 15.0,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('seller_location'),
                    position: LatLng(seller!.Lat!, seller!.Lng!),
                    infoWindow: InfoWindow(title: 'Seller Location'),
                  ),
                },
              ),
            ),
          // "Cute" button
          ElevatedButton(
            onPressed: onCuteButtonPressed,
            child: Text(
              'Queue',
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
