import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/FirebaseMessage/single_chat_history_controller.dart';
import 'package:influencer/admin_module/FireBaseUsers/firebase_user_controller.dart';
import 'package:influencer/admin_module/contactti/view/component/contactti_user_card.dart';
import 'package:influencer/admin_module/contactti/view/widget/admin_input_chat_view.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'package:influencer/routes/app_pages.dart';
import 'package:influencer/util/app_extentions.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/string.dart';
import 'package:intl/intl.dart';

class AdminSingleChatUserListView extends StatefulWidget {
  AdminSingleChatUserListView({super.key});

  @override
  State<AdminSingleChatUserListView> createState() =>
      _AdminSingleChatUserListViewState();
}

class _AdminSingleChatUserListViewState
    extends State<AdminSingleChatUserListView> {
  final controller = Get.put(FireBaseUsersController());
  final currentUser = Get.find<CurrentUserController>();
  final history = Get.find<MessageController>();
  Color activeColor = Colors.pink.shade100;
  Color inActiveColor = Colors.white;
  dynamic tileColor = Colors.white;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = Get.size.height;
    double w = Get.size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: IColor.colorblack,
              )),
          backgroundColor: IColor.colorWhite,
          elevation: 0,
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              Strings.contatti,
              style: TextStyle(color: IColor.colorblack),
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              child: Obx(() => ListView.builder(
                  itemCount: controller.firbaseUsersList.length,
                  itemBuilder: (context, index) {
                    return controller.firbaseUsersList[index].userRole ==
                            'admin'
                        ? const SizedBox()
                        : ContattiUserCard(
                            onTap: () {
                              history.UserId = controller
                                  .firbaseUsersList[index].uid
                                  .toString();
                              Get.to(AdminInputChatView());
                            },
                            name: controller.firbaseUsersList[index].name,
                          );
                  })),
            ),

            /*
            Align(
              alignment: Alignment(0.95, 0.8),
              child: Container(
                  child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: h * 0.04, vertical: h * 0.023),
                child: CircleAvatar(
                    backgroundColor: IColor.mainBlueColor,
                    radius: h * 0.035,
                    child: InkWell(
                        onTap: () {
                          Get.toNamed(Paths.userInputChatView);
                        },
                        child: Icon(Icons.arrow_forward_rounded,
                            color: IColor.colorWhite, size: h * 0.03))),
              )),
            )
        */
          ],
        ));
  }
}
