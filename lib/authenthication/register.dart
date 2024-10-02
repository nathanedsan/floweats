import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_app/mainScreens/home_screen.dart';
import 'package:uber_app/widgets/custom_text_field.dart';
import 'package:uber_app/widgets/error.dart';
import 'package:uber_app/widgets/loading.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import '../global/global.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;

  String sellerImageUrl = "";
  String completeAddress = "";

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;
    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );
    Placemark pMark = placeMarks![0];

    completeAddress =
    '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    locationController.text = completeAddress;
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: "Please select an image.",
          );
        },
      );
    } else {
      if (passwordController.text == confirmpasswordController.text) {
        if (confirmpasswordController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            nameController.text.isNotEmpty &&
            phoneController.text.isNotEmpty &&
            locationController.text.isNotEmpty) {
          showDialog(
            context: context,
            builder: (c) {
              return LoadingDialog(
                message: "Registering Account",
              );
            },
          );
          String fileName =
          DateTime.now().millisecondsSinceEpoch.toString();
          storage.Reference reference = storage.FirebaseStorage.instance
              .ref()
              .child("sellers")
              .child(fileName);
          storage.UploadTask uploadTask =
          reference.putFile(File(imageXFile!.path));
          storage.TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            sellerImageUrl = url;

            AuthenticateSellerAndSignUp();
          });
        } else {
          showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Information cannot be empty.",
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Password do not match.",
            );
          },
        );
      }
    }
  }

  void AuthenticateSellerAndSignUp() async {
    User? currentUser;

    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (c) {
          return ErrorDialog(
            message: error.message.toString(),
          );
        },
      );
    });

    if (currentUser != null) {
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);

        Route newRoute = MaterialPageRoute(builder: (c) => HomeScreen());
        Navigator.push(context, newRoute);
      });
    }
  }

  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance.collection("sellers").doc(currentUser.uid).set({
      "sellerUID": currentUser.uid,
      "sellerEmail": currentUser.email,
      "sellerName": nameController.text.trim(),
      "sellerAvatarUrl": sellerImageUrl,
      "phone": phoneController.text.trim(),
      "Address": completeAddress,
      "status": "approved",
      "earnings": 0.0,
      "Lat": position!.latitude,
      "Lng": position!.longitude,
    });

    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!
        .setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameController.text.trim());
    await sharedPreferences!.setString("photoUrl", sellerImageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              _getImage();
            },
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.20,
              backgroundColor: Colors.black26,
              backgroundImage:
              imageXFile == null ? null : FileImage(File(imageXFile!.path)),
              child: imageXFile == null
                  ? Icon(
                Icons.add_photo_alternate,
                size: MediaQuery.of(context).size.width * 0.20,
                color: Colors.white,
              )
                  : null,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.person,
                  controller: nameController,
                  hinttext: "Name",
                  isObsecre: false,
                  hintText: '',
                ),
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hinttext: "Email",
                  isObsecre: false,
                  hintText: '',
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hinttext: "Password",
                  isObsecre: true,
                  hintText: '',
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: confirmpasswordController,
                  hinttext: "Confirm Password",
                  isObsecre: true,
                  hintText: '',
                ),
                CustomTextField(
                  data: Icons.phone,
                  controller: phoneController,
                  hinttext: "Phone",
                  isObsecre: false,
                  hintText: '',
                ),
                CustomTextField(
                  data: Icons.my_location,
                  controller: locationController,
                  hinttext: "Cafe/Restaurant Address",
                  isObsecre: false,
                  enabled: true, // Allow manual input
                  hintText: 'Enter your address',
                ),
                Container(
                  width: 400,
                  height: 40,
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    label: const Text(
                      "Get my Current Location",
                      style: TextStyle(color: Colors.black87),
                    ),
                    icon: const Icon(
                      Icons.location_on,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      getCurrentLocation();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.greenAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            child: const Text(
              "Sign Up",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.greenAccent,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
            onPressed: () {
              formValidation();
            },
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
