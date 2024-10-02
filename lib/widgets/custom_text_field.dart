import 'package:flutter/material.dart';


class CustomTextField extends StatelessWidget {
 final TextEditingController? controller;
 final IconData? data;
 final String? hinttext;
 bool? isObsecre = true;
 bool? enabled =true;


 CustomTextField({
   this.controller,
   this.data,
   this.hinttext,
   this.isObsecre,
   this.enabled, required String hintText,

});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.all(Radius.circular(10)),

      ),
    padding: EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(10),
      child: TextFormField(
       enabled: enabled,
       controller: controller,
        obscureText: isObsecre!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: Colors.cyan,

          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hinttext,
        ),

      ),
    ) ;
  }
}
