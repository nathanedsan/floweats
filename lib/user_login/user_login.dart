import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber_app/user_login/user_auth_screen.dart';

import '../authenthication/auth_screen.dart';
import '../global/global.dart';
import '../user_main/user_home.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/error.dart';
import '../widgets/loading.dart';


class ULoginScreen extends StatefulWidget {
  const ULoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}



class _LoginScreenState extends State<ULoginScreen>
{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  formValidation()
  {
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty)
    {
      //login
      loginNow();
    }
    else
    {
      showDialog(
          context: context,
          builder: (c)
          {
            return ErrorDialog(
              message: "Please write email/password.",
            );
          }
      );
    }
  }


  loginNow() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(
            message: "Checking Credentials",
          );
        }
    );

    User? currentUser;
    try {
      final auth = await firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      currentUser = auth.user;
    } catch (error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.toString(),
            );
          }
      );
    }

    if (currentUser != null) {
      readDataAndSetDataLocally(currentUser);
    } else {
      handleError("User is null.");
    }
  }


  Future readDataAndSetDataLocally(User currentUser) async {
    await FirebaseFirestore.instance.collection("users")
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      if (snapshot != null && snapshot.exists) {
        final data = snapshot.data();
        if (data != null) {
          if (sharedPreferences != null) {  // Check if sharedPreferences is not null
            await sharedPreferences!.setString("uid", currentUser.uid);
            await sharedPreferences!.setString("email", data["email"]);
            await sharedPreferences!.setString("name", data["name"]);
            await sharedPreferences!.setString("photoUrl", data["photoUrl"]);
          } else {
            print("sharedPreferences is null. Make sure it is properly initialized.");
            // Handle this case appropriately, e.g., show an error dialog.
          }

          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (c) => const UHomeScreen()));
        } else {
          firebaseAuth.signOut();
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (c) => const UAuthScreen()));

          showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "No record found.",
              );
            },
          );
        }
      }
    });
  }


  void handleError(String errorMessage) {
    showDialog(
      context: context,
      builder: (c) {
        return ErrorDialog(
          message: errorMessage,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Image.asset(
                "images/login.png",
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
                  hintText: "Email",
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: "Password",
                  isObsecre: true,
                ),
              ],
            ),
          ),
          ElevatedButton(
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.cyan,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
            onPressed: ()
            {
              formValidation();
            },
          ),
          const SizedBox(height: 30,),
        ],
      ),
    );
  }
}
