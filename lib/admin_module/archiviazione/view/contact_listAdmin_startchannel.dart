import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:influencer/admin_module/admin_archived/model/admin_archived_modelclass.dart';
import 'package:influencer/admin_module/admin_archived/view/component/search_bar.dart';
import 'package:influencer/admin_module/contact_listfor_admin_startChat/model/contact_list_modelclass.dart';
import 'package:influencer/admin_module/two_way_channel/view/component/card_layout.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'package:influencer/routes/app_pages.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/commonText.dart';
import 'package:influencer/util/common_app.dart';
import 'package:influencer/util/dimension.dart';
import 'package:influencer/util/image_const.dart';
import 'package:influencer/util/string.dart';

import '../../two_way_channel/model/two_way_modelclass.dart';
import 'component/contactlist_card_layout.dart';

class Archiviazione extends StatelessWidget {
  final con = Get.find<CurrentUserController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            Strings.archiviazione,
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: IColor.colorblack,
              )),
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
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              search_bar(title: Strings.archived_privatd_chating_searchbar),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.fontSize20,
                          vertical: Dimensions.fontSize12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText(
                              title: Strings.message,
                              fontWeight: FontWeight.w500),
                          CommonText(
                            title: Strings.vedi_tutto,
                            color: IColor.grey_color,
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   // margin: EdgeInsets.only(bottom: 60.h),
                    //   height: Get.size.height,
                    //   child: ListView.builder(
                    //     physics: NeverScrollableScrollPhysics(),
                    //     itemCount: TwoWayChats.length,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       final TwoWayMessage chat = TwoWayChats[index];
                    //       return TwoWayUserChannelCard(
                    //         chat: chat,
                    //       );
                    //     },
                    //   ),
                    // ),
                    Center(
                      child: const Text('Non hai alcuna chat in archivio'),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
