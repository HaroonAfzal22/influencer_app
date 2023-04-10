import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:influencer/admin_module/contactti/view/component/newchannel_appbar.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'package:influencer/admin_module/two_way_channel/view/widgets/admin_group_chat_controller.dart';
import 'package:influencer/admin_module/two_way_channel/view/widgets/admin_group_input_view.dart';
import 'package:influencer/routes/app_pages.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/commonText.dart';
import 'package:influencer/util/dimension.dart';
import 'package:influencer/util/string.dart';

class AdminNewChannel extends StatefulWidget {
  @override
  State<AdminNewChannel> createState() => _AdminNewChannelState();
}

class _AdminNewChannelState extends State<AdminNewChannel> {
  final aGroupController = Get.find<AdminGroupChatController>();
  final con = Get.find<CurrentUserController>();
  final fireStore = FirebaseFirestore.instance;
  bool status = false;
  bool status2 = false;
  bool status3 = false;
  bool status4 = false;
  bool status5 = false;
  bool status6 = false;
  bool status7 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ListView(
              physics: NeverScrollableScrollPhysics(),
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
                                      value: status6,
                                      activeColor: IColor.switch_btn_color,
                                      onChanged: (value) {
                                        setState(() {
                                          status6 = value;
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
                                      value: status7,
                                      activeColor: IColor.switch_btn_color,
                                      onChanged: (value) {
                                        setState(() {
                                          status7 = value;
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
                            .doc(aGroupController.groupName).collection(aGroupController.groupMembers.toString()).doc()
                            /*
                            .collection(aGroupController.groupName)
                            .doc(aGroupController.groupName +
                                con.currentUser!.uid.toString())
                          */
                            .set(
                              {
                          'groupName': aGroupController.groupName,
                          
                          // 'GroupMembers': {
                          //   for (int i = 0;
                          //       i <= aGroupController.groupMembers.length;
                          //       i++)
                          //     {aGroupController.groupMembers[i]: '0'}
                          // },
                          'groupSetting': aGroupController.groupSetting,
                          'lastMessage': '',
                          'time': Timestamp.now(),
                        });

                        Get.to(AdminInputGroupView());
                        // Get.toNamed(Paths.twoWayChating);
                        // AdminInputGroupView();
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
