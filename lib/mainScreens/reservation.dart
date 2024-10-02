import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uber_app/user_widget/app_bar.dart';
import 'package:uber_app/user_widget/simple_app_bar.dart';
import '../global/global.dart';

class ReservatonScreen extends StatefulWidget {
  @override
  _ReservatonScreenState createState() => _ReservatonScreenState();
}

class _ReservatonScreenState extends State<ReservatonScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore
            .collection('sellers')
            .where("sellerUID", isEqualTo: sharedPreferences!.getString("uid"))
            .snapshots(),
        builder: (context, sellerSnapshot) {
          if (!sellerSnapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          var sellerData = sellerSnapshot.data!.docs;
          if (sellerData.isEmpty) {
            // Handle the case where the seller data is not available
            return Center(
              child: Text('Seller data not found'),
            );
          }

          var sellerUID = sellerData[0]['sellerUID']; // Assuming 'sellerUID' is the field you want

          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _firestore
                .collection('sellers')
                .doc(sellerUID)
                .collection('bookings')
                .where('status', isEqualTo: 'pending') // Filter by status 'pending'
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
                  var booking = bookings[index].data()!;

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
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              // Accept booking logic here
                              // You may want to update the status or perform any other actions
                              // For example:
                              _updateBookingStatus(sellerUID, bookings[index].id, 'Accepted');
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {
                              // Deny booking logic here
                              // You may want to update the status or perform any other actions
                              // For example:
                              _updateBookingStatus(sellerUID, bookings[index].id, 'Denied');
                            },
                          ),
                        ],
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

  Future<void> _updateBookingStatus(String sellerUID, String bookingID, String status) async {
    try {
      // Update seller's bookings collection
      await _firestore
          .collection('sellers')
          .doc(sellerUID)
          .collection('bookings')
          .doc(bookingID)
          .update({'status': status});

      print('Seller booking updated successfully: $sellerUID, $bookingID, $status');

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
      print('Error updating booking status: $e');
    }
  }
}
