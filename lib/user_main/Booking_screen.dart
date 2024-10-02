import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/sellers.dart';
import '../user_widget/app_bar.dart';

class Bookingscreen extends StatefulWidget {
  final Sellers? model;

  Bookingscreen({this.model});

  @override
  _BookingscreenState createState() => _BookingscreenState();
}

class _BookingscreenState extends State<Bookingscreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _numberOfPeopleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyTextField(
              hint: 'Your Name',
              controller: _nameController,
            ),
            const SizedBox(height: 16.0),
            MyTextField(
              hint: 'Your Phone Number',
              controller: _phoneController,
            ),
            const SizedBox(height: 16.0),
            MyTextField(
              hint: 'Date',
              controller: _dateController,
            ),
            const SizedBox(height: 16.0),
            MyTextField(
              hint: 'Time',
              controller: _timeController,
            ),
            const SizedBox(height: 16.0),
            MyTextField(
              hint: 'Number of People',
              controller: _numberOfPeopleController,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _submitBooking(context);
              },
              child: const Text('Book Now'),
            ),
          ],
        ),
      ),
    );
  }

  void _submitBooking(BuildContext context) async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _timeController.text.isEmpty ||
        _numberOfPeopleController.text.isEmpty) {
      return;
    }

    String? uid = _auth.currentUser?.uid;
    String? sellerUID = widget.model?.sellerUID;

    if (uid != null && sellerUID != null) {
      DocumentReference bookingReference = await _firestore
          .collection('sellers')
          .doc(sellerUID)
          .collection('bookings')
          .add({
        'bookingID': '',
        'userID': uid,
        'name': _nameController.text,
        'phone': _phoneController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'numberOfPeople': _numberOfPeopleController.text,
        'status': 'pending',
      });

      // Update the booking ID with the auto-generated ID
      await bookingReference.update({'bookingID': bookingReference.id});

      // Update user's bookings collection
      await _firestore.collection('users').doc(uid).collection('bookings').doc(bookingReference.id).set({
        'bookingID': bookingReference.id,
        'status': 'pending',
        'sellerUID': sellerUID,
        'userID': uid,
        'name': _nameController.text,
        'phone': _phoneController.text,
        'date': _dateController.text,
        'time': _timeController.text,
        'numberOfPeople': _numberOfPeopleController.text,
      });

      // Update user's information
      await _firestore.collection('users').doc(uid).update({
        'name': _nameController.text,
        'phone': _phoneController.text,
        // Add other fields as needed
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking successful!'),
        ),
      );
    }
  }
}

class MyTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;

  MyTextField({this.hint, this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration.collapsed(hintText: hint),
        validator: (value) =>
        value!.isEmpty ? 'Field can not be empty' : null,
      ),
    );
  }
}
