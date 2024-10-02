import 'package:flutter/material.dart';
import 'package:uber_app/authenthication/login.dart';
import 'package:uber_app/authenthication/register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
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
                LoginScreen(),
                SignUpScreen(),
              ],

            ),
          ),
        )
    );
  }
}
