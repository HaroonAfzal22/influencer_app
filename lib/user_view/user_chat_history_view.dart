import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:influencer/admin_module/admin_archived/view/component/search_bar.dart';
import 'package:influencer/admin_module/two_way_channel/model/two_way_modelclass.dart';
import 'package:influencer/admin_module/two_way_channel/view/component/card_layout.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'package:influencer/routes/app_pages.dart';
import 'package:influencer/user_view/user_input_chat_view.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/commonText.dart';
import 'package:influencer/util/dimension.dart';
import 'package:influencer/util/image_const.dart';
import 'package:influencer/util/string.dart';

import '../FirebaseMessage/single_chat_history_controller.dart';
import '../admin_module/two_way_channel/chat_history_card_widget.dart';

// void _moveToScreen2(BuildContext context) =>
//     Navigator.pushReplacementNamed(context, "screen2");

class UserChatView extends StatelessWidget {
  final con = Get.find<CurrentUserController>();
  final userController = Get.find<MessageController>();
  final fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onbackpress(context),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              Strings.chat,
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              GestureDetector(
                  onTap: () {
                    /*
                    con.currentUser?.userRole == 'admin'
                        ? Get.toNamed(Paths.fireBaseUsersView)
                        :
                */
                    Get.toNamed(Paths.mobileContact);
                  },
                  child: SvgPicture.asset(ImageConstant.edit_img)),
              PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 1,
                      child: Text(Strings.nuova_chat),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text(Strings.nuova_canale),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: Text(Strings.canali_esistenti),
                    ),
                    const PopupMenuItem(
                      value: 4,
                      child: Text(Strings.chat_archivaiate),
                    ),
                    const PopupMenuItem(
                      value: 5,
                      child: Text(Strings.impostaziani),
                    ),
                  ];
                },
                onSelected: (item) {
                  if (item == 1) {
                    Get.toNamed(Paths.contactListAdminStartChannel);
                  } else if (item == 2) {
                    Get.toNamed(Paths.contactList);
                  } else if (item == 3) {
                    Get.toNamed(Paths.canaliEsistentiScreen);
                  } else if (item == 4) {
                    Get.toNamed(Paths.adminArchived);
                  } else if (item == 5) {
                    Get.toNamed(Paths.user_Setting);
                  }
                },
              ),
            ],
          ),
          backgroundColor: IColor.colorWhite,
          body: SafeArea(
            child: Column(
              children: [
                search_bar(title: Strings.archived_privatd_chating_searchbar),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.fontSize20,
                      vertical: Dimensions.fontSize12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CommonText(
                          title: Strings.message, fontWeight: FontWeight.w500),
                      CommonText(
                        title: Strings.vedi_tutto,
                        color: IColor.grey_color,
                      )
                    ],
                  ),
                ),
                userController.userHistoryList.isEmpty
                    ? const Center(
                        child: Text('You did\'nt ve any chat history'))
                    : Expanded(
                        child: Obx(() => ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: userController.userHistoryList.length,
                            itemBuilder: (context, index) {
                              var ref = userController.userHistoryList[index];

                              if (con.currentUser?.uid ==
                                  userController
                                      .userHistoryList[index].otherUid) {
                                return GestureDetector(
                                  onTap: () {
                                    userController.adminUserID =
                                        con.currentUser!.uid.toString();
                                    Get.toNamed(Paths.userInputChatView);
                                    if (ref.isAdminRead == false) {
                                      fireStore
                                          .collection('recentChats')
                                          .doc(ref.otherUid)
                                          .update({
                                        'isUserRead': true,
                                        'userMessageCount': 0
                                      });
                                    }
                                  },
                                  child: ChatHistoryCardWidget(
                                    isRead: ref.isUserRead,
                                    messageCount: ref.userMessageCount,
                                    messgae: ref.message.toString(),
                                    sender: ref.otherName.toString(),
                                    time: ref.time,
                                  ),
                                );
                              }

                              // return Text(userController
                              //     .userHistoryList[index].curentUid
                              //
                              //     .toString());
                              return const Center();
                            })),
                      )
              ],
            ),
          )),
    );
  }

  Future<bool> onbackpress(BuildContext context) async {
    bool exitApp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('close app'),
            content: const Text('Do want to close app '),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('No')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes')),
            ],
          );
        });
    return exitApp ?? false;
  }
}
