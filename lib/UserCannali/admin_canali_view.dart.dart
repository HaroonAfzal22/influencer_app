import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:influencer/admin_module/admin_archived/view/component/search_bar.dart';
import 'package:influencer/admin_module/two_way_channel/chat_history_card_widget.dart';
import 'package:influencer/admin_module/two_way_channel/view/component/card_layout.dart';
import 'package:influencer/admin_module/two_way_channel/view/widgets/admin_group_chat_controller.dart';
import 'package:influencer/admin_module/two_way_channel/view/widgets/admin_group_input_view.dart';
import 'package:influencer/admin_module/two_way_channel/view/widgets/group_list_card_widget.dart';
import 'package:influencer/routes/app_pages.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/commonText.dart';
import 'package:influencer/util/dimension.dart';
import 'package:influencer/util/image_const.dart';
import 'package:influencer/util/string.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as devtools show log;
import '../admin_module/two_way_channel/model/two_way_modelclass.dart';
import '../admin_module/two_way_channel/view/home_controller.dart';

class AdminCanaliView extends StatelessWidget {
  final con = Get.find<CurrentUserController>();
  final adminGroupController = Get.find<AdminGroupChatController>();
  final aGroupController = Get.find<AdminGroupChatController>();
  final _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onbackpress(context),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              Strings.canali,
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              GestureDetector(
                  onTap: () {
                    con.currentUser?.userRole == 'admin'
                        ? Get.toNamed(Paths.fireBaseUsersView)
                        : Get.toNamed(Paths.mobileContact);
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
                    Get.toNamed(Paths.fireBaseUsersView);
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
                          title: Strings.canali, fontWeight: FontWeight.w500),
                      CommonText(
                        title: Strings.vedi_tutto,
                        color: IColor.grey_color,
                      )
                    ],
                  ),
                ),
                StreamBuilder(
                  stream: _fireStore
                      .collection('groupChats')
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!.docs.isEmpty
                          ? const Text('Non partecipi a nessun canale')
                          : Expanded(
                              child: ListView(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data() as Map<String, dynamic>;
                                  aGroupController.groupPhoto =
                                      data['groupPhoto'];

                                  DateTime dateTime = data["time"].toDate();
                                  final dateString =
                                      DateFormat('yyyy-MM-dd hh:mm')
                                          .format(dateTime);
                                  // add group members in getx controller

                                  return GestureDetector(
                                    onTap: () {
                                      // log('group members from on tap ${aGroupController.userFcm}');

                                      aGroupController.groupMembersStatusMap =
                                          data['GroupMembers'];

                                      log('group members from on tap ${aGroupController.groupMembersStatusMap}');

                                      aGroupController.groupName =
                                          data['groupName'];
                                      aGroupController.groupId =
                                          data['groupId'];

                                      aGroupController.groupPhoto =
                                          data['groupPhoto'];

                                      _fireStore
                                          .collection('groupChats')
                                          .doc(aGroupController.groupId)
                                          .update({'AdminCount': 0});

                                      Get.to(AdminInputGroupView());
                                    },
                                    child: GroupListCardWidget(
                                      imageUrl: aGroupController.groupPhoto,
                                      chatNumber: data['AdminCount'],
                                      groupName: data['groupName'],
                                      time: dateString,
                                      message: data['lastMessage'] == ''
                                          ? 'Write a message'
                                          : data['lastMessage'],
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                    }
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    return const Text("Loading");
                  },
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
