import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:influencer/admin_module/bottom_nav/bottom_nav.dart';
import 'package:influencer/admin_module/contactti/view/component/newchannel_appbar.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'package:influencer/admin_module/two_way_channel/view/widgets/admin_group_chat_controller.dart';
import 'package:influencer/admin_module/two_way_channel/view/widgets/admin_group_input_view.dart';
import 'package:influencer/routes/app_pages.dart';
import 'package:influencer/routes/app_routes.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/commonText.dart';
import 'package:influencer/util/dimension.dart';
import 'package:influencer/util/string.dart';

import '../../../../Firebase_notification/notification_services.dart';

class AdminNewChannel extends StatefulWidget {
  @override
  State<AdminNewChannel> createState() => _AdminNewChannelState();
}

class _AdminNewChannelState extends State<AdminNewChannel> {
  final aGroupController = Get.find<AdminGroupChatController>();
  final con = Get.find<CurrentUserController>();
  final fireStore = FirebaseFirestore.instance;
  late AppPages _appPages;
  @override
  void initState() {
    _appPages = AppPages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                NewChannelAppBar(
                  ontap: () {
                    Get.back();
                  },
                ),
                Container(
                  width: double.infinity,
                  height: Get.size.height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: Get.size.height,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.fontSize18),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: Dimensions.height60,
                                ),
                                CommonText(
                                  size: Dimensions.fontSize18,
                                  color: IColor.colorblack,
                                  fontWeight: FontWeight.w600,
                                  title: Strings.info_canale,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      Strings.tutti_contatti,
                                      style: TextStyle(
                                        fontSize: Dimensions.fontSize18,
                                      ),
                                    ),
                                    Switch(
                                      value: aGroupController.tutti.value,
                                      activeColor: IColor.switch_btn_color,
                                      onChanged: (value) {
                                        setState(() {
                                          aGroupController.tutti.value = value;
                                        });
                                      },
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      Strings.consenti_risposte,
                                      style: TextStyle(
                                        fontSize: Dimensions.fontSize18,
                                      ),
                                    ),
                                    Switch(
                                      value: aGroupController.consenti.value,
                                      activeColor: IColor.switch_btn_color,
                                      onChanged: (value) {
                                        setState(() {
                                          aGroupController.consenti.value =
                                              value;
                                        });
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Container(
                child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.fontSize25,
                  vertical: Dimensions.fontSize16),
              child: CircleAvatar(
                  backgroundColor: IColor.mainBlueColor,
                  radius: Dimensions.fontsize30,
                  child: InkWell(
                      onTap: () async {
                        await fireStore
                            .collection('groupChats')
                            .doc(aGroupController.groupName)
                            .set({
                          'groupPhoto': '',
                          'AdminCount': 0,
                          'groupName': aGroupController.groupName,
                          'GroupMembers':
                              aGroupController.groupMembersStatusMap,
                          'Tutti': aGroupController.tutti.value,
                          'Consenti': aGroupController.consenti.value,
                          'Muta': aGroupController.muta.value,
                          'Nova': aGroupController.nova.value,
                          'lastMessage': '',
                          'time': Timestamp.now(),
                          'groupCreatedTime': Timestamp.now(),
                          'GroupDescription': '',
                          'groupId': aGroupController.groupName,
                          'isAdminArchived': false,
                          'adminNotificationSattus': false,
                          'usersNotificationSattus':
                              aGroupController.notificationSattusMap
                        });

                        Get.offNamed(Paths.adminInputGroupChatView);
                      },
                      child: Icon(
                        Icons.check,
                        color: IColor.colorWhite,
                        size: Dimensions.fontSize18 * 2,
                      ))),
            ))
          ],
        ),
      ),
    );
  }
}
