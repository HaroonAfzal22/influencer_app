import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/util/common_app.dart';
import 'package:influencer/util/dimension.dart';
import 'package:influencer/util/string.dart';

class NewChannelAppBar extends StatelessWidget {
  NewChannelAppBar( {required this.ontap});
  VoidCallback ontap;
  @override
  Widget build(BuildContext context) {
    return CommonApp(
      backFunction: ontap,
      backbtn: Icon(Icons.arrow_back),
      name: Strings.contatti,
      popupmenu: PopupMenuButton(
        itemBuilder: (context) {
          return [
            const PopupMenuItem(
              child: Text(Strings.muta_canale),
            ),
            const PopupMenuItem(
              child: Text(Strings.nuova_canale),
            ),
          ];
        },
      ),
    );
  }
}
