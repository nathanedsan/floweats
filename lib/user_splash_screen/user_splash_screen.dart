import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uber_app/authenthication/auth_screen.dart';
import 'package:uber_app/global/global.dart';
import 'package:uber_app/mainScreens/home_screen.dart';
import 'package:uber_app/authenthication/role_selection_screen.dart';
import 'package:uber_app/user_login/user_auth_screen.dart';
import 'package:uber_app/user_main/user_home.dart';

class UMySplashScreen extends StatefulWidget {
  const UMySplashScreen({super.key});

  @override
  State<UMySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<UMySplashScreen> {

  startTimer()
  {


    Timer(const Duration(seconds: 2), ()async  {
      if(firebaseAuth.currentUser != null)
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=>const UHomeScreen()));
      }
      else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) =>   UAuthScreen()));
      }
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
