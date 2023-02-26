import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/admin_module/FireBaseUsers/firebase_user_controller.dart';
import 'package:influencer/admin_module/contactti/view/component/contactti_user_card.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'package:influencer/routes/app_pages.dart';
import 'package:influencer/util/app_extentions.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/string.dart';
import 'package:intl/intl.dart';

import '../two_way_channel/view/widgets/admin_group_chat_controller.dart';

class FireBaseUsersView extends StatefulWidget {
  FireBaseUsersView({super.key});

  @override
  State<FireBaseUsersView> createState() => _FireBaseUsersViewState();
}

class _FireBaseUsersViewState extends State<FireBaseUsersView> {
  final controller = Get.put(FireBaseUsersController());
  TextEditingController messageController = TextEditingController();
  final aGroupController = Get.put(AdminGroupChatController());

  List<int> _selectedIndices = [];

  final currentUser = Get.find<CurrentUserController>();
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
                              if (_selectedIndices.contains(index)) {
                                _selectedIndices.remove(index);
                                aGroupController.groupMembers.remove(controller
                                    .firbaseUsersList[index].uid
                                    .toString());
                              } else {
                                _selectedIndices.add(index);
                                aGroupController.groupMembers.add(controller
                                    .firbaseUsersList[index].uid
                                    .toString());
                              }

                              setState(() {});
                            },
                            color: _selectedIndices.contains(index)
                                ? activeColor
                                : inActiveColor,
                            name: controller.firbaseUsersList[index].name,
                          );
                  })),
            ),
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
                          if (_selectedIndices.isNotEmpty) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      Strings.groupName,
                                      textAlign: TextAlign.center,
                                    ),
                                    content: TextField(
                                      maxLength: 25,
                                      decoration: const InputDecoration(
                                          hintText:
                                              'enter group name here ...'),
                                      controller: messageController,
                                    ),
                                    actions: [
                                      SmallElevatedButton(
                                        text: 'Cancel',
                                        color: Colors.pinkAccent,
                                        onTap: () {
                                          Get.back();
                                        },
                                      ),
                                      SmallElevatedButton(
                                        text: '  Create ',
                                        color: Colors.blueAccent,
                                        onTap: () {
                                          if (messageController.text.isEmpty) {
                                            Get.snackbar('Error',
                                                'Please enter group name',
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 20));
                                          } else {
                                            aGroupController.groupName =
                                                messageController.text;
                                            Get.toNamed(Paths.adminNewChannel);
                                          }
                                        },
                                      )
                                    ],
                                  );
                                });
                          } else if (_selectedIndices.isEmpty) {
                            Get.snackbar('Error', 'Please select user for chat',
                                snackPosition: SnackPosition.BOTTOM,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20));
                          }
                        },
                        child: Icon(Icons.arrow_forward_rounded,
                            color: IColor.colorWhite, size: h * 0.03))),
              )),
            )
          ],
        ));
  }
}

class SmallElevatedButton extends StatelessWidget {
  SmallElevatedButton({
    required this.color,
    required this.onTap,
    required this.text,
    Key? key,
  }) : super(key: key);
  String text;
  VoidCallback onTap;
  Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color)),
        onPressed: onTap,
        child: Text(text));
  }
}
