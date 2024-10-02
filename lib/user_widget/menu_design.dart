import 'package:flutter/material.dart';

import '../mainScreens/item_screen.dart';
import '../models/menu.dart';
import '../user_main/item_screen_user.dart';



class MenusDesignWidget extends StatefulWidget
{
  Menus? model;
  BuildContext? context;

  MenusDesignWidget({this.model, this.context});

  @override
  _MenusDesignWidgetState createState() => _MenusDesignWidgetState();
}



class _MenusDesignWidgetState extends State<MenusDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> UItemsScreen(model: widget.model)));
      },
      splashColor: Colors.greenAccent,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 280,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
              Image.network(
                widget.model!.thumbnailUrl!,
                height: 220.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 1.0,),
              Text(
                widget.model!.menuTitle!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: "Signatra",
                ),
              ),
              Text(
                widget.model!.menuInfo!,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
