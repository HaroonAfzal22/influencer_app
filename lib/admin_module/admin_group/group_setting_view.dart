import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:influencer/FirebaseServices/firebase_methods.dart';
import 'package:influencer/admin_module/two_way_channel/view/widgets/admin_group_chat_controller.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/commonText.dart';
import 'package:influencer/util/dimension.dart';
import 'package:influencer/util/string.dart';

class GroupSettingView extends StatelessWidget {
  GroupSettingView({super.key});
  final aGroupController = Get.find<AdminGroupChatController>();
  FireBaseMethods _baseMethods = FireBaseMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('impostazione del canale'),
        ),
        body: Obx(
          () => Column(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: Dimensions.fontSize18),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            aGroupController.tutti.value = value;
                            _baseMethods.updateCollection(
                                {'Tutti': aGroupController.tutti.value},
                                'groupChats',
                                aGroupController.groupId);
                          },
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            aGroupController.consenti.value = value;
                            _baseMethods.updateCollection(
                                {'Consenti': aGroupController.consenti.value},
                                'groupChats',
                                aGroupController.groupId);
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
