import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../global/global.dart';
import '../mainScreens/home_screen.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({Key? key}) : super(key: key);

  @override
  _EarningsScreenState createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  double sellerTotalEarnings = 0;
  double sellerDailyEarnings = 0;
  double sellerWeeklyEarnings = 0;
  double sellerMonthlyEarnings = 0;

  retrieveSellerEarnings() async {
    String uid = sharedPreferences!.getString("uid")!;
    DateTime now = DateTime.now();
    DateTime firstDayOfWeek =
    now.subtract(Duration(days: now.weekday - 1)); // Start of the week

    // Fetch total earnings
    await FirebaseFirestore.instance
        .collection("sellers")
        .doc(uid)
        .get()
        .then((snap) {
      setState(() {
        sellerTotalEarnings =
            double.parse(snap.data()!["earnings"].toString());
      });
    });

    // Fetch and calculate daily earnings
    QuerySnapshot dailyEarningsSnapshot = await FirebaseFirestore.instance
        .collection("earnings")
        .where("sellerId", isEqualTo: uid)
        .where("date", isEqualTo: now.toLocal().toUtc())
        .get();

    dailyEarningsSnapshot.docs.forEach((doc) {
      sellerDailyEarnings += double.parse(doc["amount"].toString());
    });

    // Fetch and calculate weekly earnings
    QuerySnapshot weeklyEarningsSnapshot = await FirebaseFirestore.instance
        .collection("earnings")
        .where("sellerId", isEqualTo: uid)
        .where("date", isGreaterThanOrEqualTo: firstDayOfWeek.toUtc())
        .get();

    weeklyEarningsSnapshot.docs.forEach((doc) {
      sellerWeeklyEarnings += double.parse(doc["amount"].toString());
    });

    // Fetch and calculate monthly earnings
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    QuerySnapshot monthlyEarningsSnapshot = await FirebaseFirestore.instance
        .collection("earnings")
        .where("sellerId", isEqualTo: uid)
        .where("date", isGreaterThanOrEqualTo: firstDayOfMonth.toUtc())
        .get();

    monthlyEarningsSnapshot.docs.forEach((doc) {
      sellerMonthlyEarnings += double.parse(doc["amount"].toString());
    });
  }

  @override
  void initState() {
    super.initState();
    retrieveSellerEarnings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "€ " + sellerTotalEarnings.toString(),
                style: const TextStyle(
                  fontSize: 80,
                  color: Colors.white,
                  fontFamily: "Signatra",
                ),
              ),
              const Text(
                "Total Earnings",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.white,
                  thickness: 1.5,
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                "€ " + sellerDailyEarnings.toString(),
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontFamily: "Signatra",
                ),
              ),
              const Text(
                "Daily Earnings",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                "€ " + sellerWeeklyEarnings.toString(),
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontFamily: "Signatra",
                ),
              ),
              const Text(
                "Weekly Earnings",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                "€ " + sellerMonthlyEarnings.toString(),
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontFamily: "Signatra",
                ),
              ),
              const Text(
                "Monthly Earnings",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 40.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (c) => const HomeScreen()),
                  );
                },
                child: const Card(
                  color: Colors.white54,
                  margin: EdgeInsets.symmetric(vertical: 40, horizontal: 140),
                  child: ListTile(
                    leading: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Back",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
