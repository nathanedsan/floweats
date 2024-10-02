import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber_app/authenthication/auth_screen.dart';
import 'package:uber_app/global/global.dart';
import 'package:uber_app/mainScreens/home_screen.dart';
import 'package:uber_app/widgets/error.dart';
import 'package:uber_app/widgets/loading.dart';

import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController =TextEditingController();
  TextEditingController passwordController =TextEditingController();

  formValidation()
  {
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty)
      {
        loginNow();
      }
    else
      {
        showDialog
          (context:context ,
            builder: (c)
        {
          return ErrorDialog(message: "Please input email and password",);
        }
        );
      }
  }

  loginNow() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(message: "Checking Credential");
        }
    );

    User? currentUser;
    await firebaseAuth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((auth) {
      if (mounted) {
        currentUser = auth.user;
      }
    }).catchError((error) {
      print(error);
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(message: error.message.toString());
        },
      );
    });

    if (currentUser != null) {
      if (mounted) { // Check if the widget is still mounted
        await readDataAndSetDataLocally(currentUser!);
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      }
    }
  }


  Future readDataAndSetDataLocally(User currentUser) async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).get();

      if (snapshot.exists) {
        await sharedPreferences!.setString("uid", currentUser.uid);
        await sharedPreferences!.setString("email", snapshot.data()!["sellerEmail"]);
        await sharedPreferences!.setString("name", snapshot.data()!["sellerName"]);
        await sharedPreferences!.setString("photoUrl", snapshot.data()!["sellerAvatarUrl"]);
        await sharedPreferences!.setStringList("userCart", ['garbageValue']);


        List<String> userCartList = snapshot.data()!["userCart"].cast<String>();
        await sharedPreferences!.setStringList("userCart", userCartList);

        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));

      } else {
        // Handle the case when the document does not exist.
      firebaseAuth.signOut();
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (c) => const AuthScreen()));
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(message: "No Record found");
          }
      );


      }
    } catch (e) {
      print("Error reading data: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment:  Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset
                ("images/seller.png",
                  height: 270,

              ),

            ),

          ),
          Form(
          key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hinttext: "Email",
                  isObsecre: false, hintText: '',
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hinttext: "Password",
                  isObsecre: true, hintText: '',
                ),
              ],
            ),
          ),
          ElevatedButton(
            child: const  Text(
              "Login",
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.greenAccent,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
            onPressed: ()
              {
                formValidation();

              },

          ),
          const SizedBox(height: 30,),
        ],

      ) ,

    );
  }
}
