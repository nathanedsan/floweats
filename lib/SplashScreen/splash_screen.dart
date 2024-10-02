import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uber_app/authenthication/auth_screen.dart';
import 'package:uber_app/global/global.dart';
import 'package:uber_app/mainScreens/home_screen.dart';
import 'package:uber_app/authenthication/role_selection_screen.dart';
import 'package:uber_app/widgets/face_detection.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  startTimer()
  {


    Timer(const Duration(seconds: 2), ()async  {

        Navigator.push(
            context, MaterialPageRoute(builder: (c) =>   RoleSelectionScreen()));

    });


  }

  @override
  void initState() {

    super.initState();

    startTimer();
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Image.asset("images/FlowEats.png"),
                const SizedBox(height: 10,),
                const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "Flow Eats",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                      color: Colors.black54,
                      fontSize: 40,
                      fontFamily:"Signatra",
                      letterSpacing: 3,
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
