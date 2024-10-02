import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../global/global.dart';
import '../user_widget/simple_app_bar.dart';
import '../widgets/progress_bar.dart';

class Ureservation extends StatefulWidget {
  @override
  _UreservationState createState() => _UreservationState();
}

class _UreservationState extends State<Ureservation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppBar(title: "My Bookings"),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(sharedPreferences!.getString("uid"))
              .collection("bookings")
              .where("status", isEqualTo: "pending")
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (c, index) {
                var bookingData =
                snapshot.data!.docs[index].data() as Map<String, dynamic>;

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text('Date: ${bookingData['date']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Time: ${bookingData['time']}'),
                        Text(
                            'Number of People: ${bookingData['numberOfPeople']}'),
                        // Add other fields as needed
                      ],
                    ),
                  ),
                );
              },
            )
                : Center(child: circularProgress());
          },
        ),
      ),
    );
  }
}
