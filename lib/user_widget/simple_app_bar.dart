import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final PreferredSizeWidget? bottom;

  SimpleAppBar({this.bottom, this.title});

  @override
  Size get preferredSize => bottom == null
      ? const Size(56, kToolbarHeight)
      : const Size(56, kToolbarHeight + 80);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan,
              Colors.greenAccent,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
      ),
      centerTitle: true,
      title: title != null
          ? Text(
        title!,
        style: const TextStyle(
          fontSize: 45.0,
          letterSpacing: 3,
          color: Colors.white,
          fontFamily: "Signatra",
        ),
      )
          : const Text(
        'Flow Eats',
        style: TextStyle(
          fontSize: 45.0,
          letterSpacing: 3,
          color: Colors.white,
          fontFamily: "Signatra",
        ),
      ),
    );
  }
}
