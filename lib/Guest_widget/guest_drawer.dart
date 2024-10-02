import 'package:flutter/material.dart';
import 'package:uber_app/authenthication/role_selection_screen.dart';
import '../authenthication/auth_screen.dart';

class GMyDrawer extends StatelessWidget {
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
                        backgroundColor: Colors.grey, // Set a default background color
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Guest",
                  style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: "Train"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Body drawer
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            child: Column(
              children: [
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
                    // Handle onTap
                  },
                ),
                // ... Other list items ...
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
                    // Handle sign out
                    Navigator.push(context, MaterialPageRoute(builder: (c) =>  RoleSelectionScreen()));
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
