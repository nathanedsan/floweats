import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_widget/simple_app_bar.dart';

class AcceptedBookingsScreen extends StatefulWidget {
  @override
  _AcceptedBookingsScreenState createState() =>
      _AcceptedBookingsScreenState();
}


class _AcceptedBookingsScreenState extends State<AcceptedBookingsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(),
      body: FutureBuilder<String>(
        // Fetch the sellerUID from SharedPreferences
        future: SharedPreferences.getInstance()
            .then((prefs) => prefs.getString("uid") ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              // Handle the case where sellerUID is empty or not available
              child: Text('Error: SellerUID is empty or not available'),
            );
          }

          String sellerUID = snapshot.data!;

          return StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('sellers')
                .doc(sellerUID)
                .collection('bookings')
                .where('status', isEqualTo: 'Accepted')
                .orderBy('date', descending: false)
                .orderBy('time', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var bookings = snapshot.data!.docs;

              return ListView.builder(
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  var booking = bookings[index].data() as Map<String, dynamic>;

                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text('Name: ${booking['name']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Phone: ${booking['phone']}'),
                          Text('Date: ${booking['date']}'),
                          Text('Time: ${booking['time']}'),
                          Text('Number of People: ${booking['numberOfPeople']}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () {
                          // Update booking status to 'Ended'
                          _updateBookingStatus(
                              sellerUID, bookings[index].id, 'Ended');
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _updateBookingStatus(
      String sellerUID, String bookingID, String status) async {
    try {
      // Update seller's bookings collection
      await _firestore
          .collection('sellers')
          .doc(sellerUID)
          .collection('bookings')
          .doc(bookingID)
          .update({'status': status});

      print('Seller booking updated successfully: $sellerUID, $bookingID, $status');

      // Update user's bookings collection
      await _updateUserBookingStatus(bookingID, status);

    } catch (e) {
      print('Error updating booking status: $e');
    }
  }

  Future<void> _updateUserBookingStatus(String bookingID, String status) async {
    try {
      // Get the user ID associated with this booking
      var userBookingSnapshot = await _firestore
          .collection('users')
          .where('bookings.${bookingID}', isNotEqualTo: null)
          .limit(1)
          .get();

      var userID = userBookingSnapshot.docs.isNotEmpty
          ? userBookingSnapshot.docs[0].id
          : null;

      if (userID != null) {
        // Update user's bookings collection
        await _firestore
            .collection('users')
            .doc(userID)
            .collection('bookings')
            .doc(bookingID)
            .update({'status': status});

        print('User booking updated successfully: $userID, $bookingID, $status');
      } else {
        print('User ID not found for bookingID: $bookingID');
      }
    } catch (e) {
      print('Error updating user booking status: $e');
    }
  }
}
