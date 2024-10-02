import 'package:flutter/material.dart';
import 'package:uber_app/authenthication/login.dart';
import 'package:uber_app/authenthication/register.dart';
import 'package:uber_app/user_login/user_login.dart';
import 'package:uber_app/user_login/user_register.dart';

class UAuthScreen extends StatefulWidget {
  const UAuthScreen({super.key});

  @override
  State<UAuthScreen> createState() => _UAuthScreenState();
}

class _UAuthScreenState extends State<UAuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length:2,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.cyan,
                      Colors.greenAccent
                    ],
                    begin:  FractionalOffset(0.0, 0.0),
                    end:  FractionalOffset(1.0, 0.0),
                    stops: [0.0,1.0],
                    tileMode: TileMode.clamp,
                  )
              ),

            ),
            title: const Text(
              "FlowEats",
              style: TextStyle(
                fontSize: 60,
                color: Colors.black54,
                fontFamily: "Lobster",

              ),
            ),
            centerTitle: true,
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.lock, color:Colors.black,),
                  text:"Login",
                ),
                Tab(
                  icon: Icon(Icons.person, color:Colors.black,),
                  text:"Register",
                )
              ],
              indicatorColor: Colors.black54,
              indicatorWeight: 6,
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
                gradient:LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.greenAccent,
                    Colors.cyan,
                  ],
                )
            ),
            child:  TabBarView(
              children: [
                ULoginScreen(),
                USignUpScreen(),
              ],

            ),
          ),
        )
    );
  }
}
