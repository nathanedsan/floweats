import 'package:flutter/material.dart';
import 'package:uber_app/Guest_main/Guest_store_info.dart';


import '../models/sellers.dart';
import '../user_main/menu_screen_user.dart';



class GSellersDesignWidget extends StatefulWidget
{
  Sellers? model;
  BuildContext? context;

  GSellersDesignWidget({this.model, this.context});

  @override
  _SellersDesignWidgetState createState() => _SellersDesignWidgetState();
}



class _SellersDesignWidgetState extends State<GSellersDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (c)=> Gstoreinfo(model: widget.model)));
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
                widget.model!.sellerAvatarUrl!,
                height: 220.0,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 1.0,),
              Text(
                widget.model!.sellerName!,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: "signatra",
                ),
              ),
              Text(
                widget.model!.sellerEmail!,
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
