import 'package:flutter/material.dart';
import 'package:uber_app/authenthication/role_selection_screen.dart';
import 'package:uber_app/mainScreens/earning_screen.dart';
import 'package:uber_app/mainScreens/history_screen.dart';
import 'package:uber_app/mainScreens/new_order_screen.dart';
import 'package:uber_app/mainScreens/not_yet_delivered_screen.dart';
import 'package:uber_app/mainScreens/parcel_in_progress_screen.dart';
import 'package:uber_app/mainScreens/reservation.dart';
import 'package:uber_app/mainScreens/reservation_table.dart';


import '../authenthication/auth_screen.dart';
import '../global/global.dart';
import '../mainScreens/home_screen.dart';

class MyDrawers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          // Header drawer
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children: [
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      height: 160,
                      width: 160,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                          sharedPreferences!.getString("photoUrl")!,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                  sharedPreferences!.getString("name")!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: "Train",
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12,),

          // Body drawer
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            child: Column(
              children: [
                // ... (your existing code)

                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.home, color: Colors.black),
                  title: const Text(
                    "Home",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => const HomeScreen()),
                    );
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.monetization_on, color: Colors.black),
                  title: const Text(
                    "My Earnings",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => EarningsScreen()),
                    );
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.reorder, color: Colors.black),
                  title: const Text(
                    "New orders",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => NewOrdersScreen()),
                    );
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.local_shipping, color: Colors.black),
                  title: const Text(
                    "Parcel in Progress",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => ParcelInProgressScreen()),
                    );
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.local_shipping, color: Colors.black),
                  title: const Text(
                    "Not Yet Delivered",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => NotYetDeliveredScreen()),
                    );
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.history, color: Colors.black),
                  title: const Text(
                    "History - Orders",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => SHistoryScreen()),
                    );
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.event, color: Colors.black),
                  title: const Text(
                    "Reservation",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => ReservatonScreen()),
                    );
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.check, color: Colors.black),
                  title: const Text(
                    "Confirmed Reservation",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (c) => AcceptedBookingsScreen()),
                    );

                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app, color: Colors.black),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    firebaseAuth.signOut().then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (c) => RoleSelectionScreen()),
                      );
                    });
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
