import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:influencer/FirebaseServices/firebase_methods.dart';
import 'package:influencer/admin_module/FireBaseUsers/FireBaseUsersView.dart';
import 'package:influencer/admin_module/FireBaseUsers/firebase_user_controller.dart';
import 'package:influencer/admin_module/admin_group/admin_group_detail_view.dart';
import 'package:influencer/admin_module/contactti/view/component/contactti_user_card.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'package:influencer/admin_module/two_way_channel/view/widgets/admin_group_chat_controller.dart';
import 'package:influencer/userModule/user_admin_archived/view/component/user_googlemap.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/string.dart';

class AddParticipentView extends StatefulWidget {
  const AddParticipentView({super.key});

  @override
  State<AddParticipentView> createState() => _AddParticipentViewState();
}

class _AddParticipentViewState extends State<AddParticipentView> {
  final fireStore = FirebaseFirestore.instance;
  final controller = Get.put(FireBaseUsersController());
  TextEditingController messageController = TextEditingController();
  final currentUser = Get.find<CurrentUserController>();
  Color activeColor = Colors.pink.shade100;
  Color inActiveColor = Colors.white;
  dynamic tileColor = Colors.white;
  double h = Get.size.height;
  double w = Get.size.width;
  late final FireBaseMethods _firebaseMethods;
  @override
  void initState() {
    _firebaseMethods = FireBaseMethods();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller.aGroupController.pressentGroupMemberMap.clear();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              'partecipanti al gruppo',
              style: TextStyle(color: IColor.colorblack),
            ),
          ),
        ),
        body: Stack(
          children: [
            Obx(
              () => Column(
                  children: controller.firbaseUsersList.map((e) {
                bool isPresent = controller
                    .aGroupController.pressentGroupMemberMap
                    .containsKey(e.uid);

                return e.userRole == 'admin'
                    ? ContattiUserCard(
                        isAdminTile: true,
                        color: const Color.fromARGB(255, 187, 152, 196),
                        name: e.name,
                        onTap: () {},
                      )
                    : isPresent
                        ? ContattiUserCard(
                            color: Colors.black12,
                            name: e.name,
                            onTap: () {
                              Get.snackbar('Mettere in guardia',
                                  "Utente già aggiunto al gruppo",
                                  snackPosition: SnackPosition.BOTTOM,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 20));
                            },
                            onLongPress: () async {
                              // controller.aGroupController.changeIcon = true;
                              await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Vuoi eliminare questo utente',
                                        textAlign: TextAlign.center,
                                      ),
                                      content: ListTile(
                                        leading: e.photoUrl == '' ||
                                                e.photoUrl == null
                                            ? const CircleAvatar()
                                            : CircleAvatar(
                                                foregroundImage: NetworkImage(
                                                    e.photoUrl.toString()),
                                                radius: 20,
                                              ),
                                        title: Text(e.name.toString()),
                                      ),
                                      actions: [
                                        SmallElevatedButton(
                                          text: '  Annulla  ',
                                          color: Colors.blueAccent,
                                          onTap: () {
                                            Get.back();
                                          },
                                        ),
                                        SmallElevatedButton(
                                          text: ' Eliminare',
                                          color: Colors.redAccent,
                                          onTap: () async {
                                            if ((controller.aGroupController
                                                .pressentGroupMemberMap
                                                .containsKey(e.uid))) {
                                              controller.aGroupController
                                                  .pressentGroupMemberMap
                                                  .remove(e.uid);
                                              controller.aGroupController
                                                  .notificationSattusMap
                                                  .remove(e.uid);

                                              Map<String, dynamic> myMap = {
                                                'usersNotificationSattus':
                                                    controller.aGroupController
                                                        .notificationSattusMap,
                                                'GroupMembers': controller
                                                    .aGroupController
                                                    .pressentGroupMemberMap
                                              };

                                              try {
                                                fireStore
                                                    .collection('groupChats')
                                                    .doc(controller
                                                        .aGroupController
                                                        .groupName)
                                                    .update(myMap);
                                              } on Exception catch (e) {
                                                Get.snackbar('Errore',
                                                    'qualcosa di sbagliato riprova più tardi',
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 20));
                                                // TODO
                                              }

                                              myMap.clear();

                                              Get.back();
                                            }
                                          },
                                        )
                                      ],
                                    );
                                  });
                            },
                          )
                        : ContattiUserCard(
                            onTap: () {
                              if (controller.selectedIndices.contains(e.uid)) {
                                controller.selectedIndices.remove(e.uid);

                                controller
                                    .aGroupController.groupMembersStatusMap
                                    .remove(e.uid);
                                controller
                                    .aGroupController.notificationSattusMap
                                    .remove(e.uid);
                              } else {
                                controller.selectedIndices.add(e.uid);

                                controller.aGroupController
                                    .groupMembersStatusMap[e.uid] = 0;
                                controller.aGroupController
                                    .notificationSattusMap[e.uid] = true;
                                log(' user map ${controller.aGroupController.groupMembersStatusMap} add map');
                              }

                              setState(() {});
                            },
                            color: controller.selectedIndices.contains(e.uid)
                                ? activeColor
                                : inActiveColor,
                            name: e.name,
                          );
              }).toList()),
            ),
            Align(
              alignment: const Alignment(0.95, 0.8),
              child: Container(
                  child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: h * 0.04, vertical: h * 0.023),
                child: CircleAvatar(
                    backgroundColor: IColor.mainBlueColor,
                    radius: h * 0.035,
                    child: InkWell(
                        onTap: () async {
                          if (controller.selectedIndices.isNotEmpty) {
                            Map<String, dynamic> myMap = {
                              'GroupMembers': controller
                                  .aGroupController.groupMembersStatusMap
                            };
                            fireStore
                                .collection('groupChats')
                                .doc(controller.aGroupController.groupName)
                                .update(myMap);
                            myMap.clear();

                            Get.back();
                            Get.snackbar('Info', "aggiunto con successo",
                                snackPosition: SnackPosition.BOTTOM,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20));
                          } else if (controller.selectedIndices.isEmpty) {
                            Get.snackbar(
                                'Errore', "Seleziona l'utente per la chat",
                                snackPosition: SnackPosition.BOTTOM,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 20));
                          }
                        },
                        child: Icon(Icons.done,
                            color: IColor.colorWhite, size: h * 0.03))),
              )),
            )
          ],
        ));
  }
}
