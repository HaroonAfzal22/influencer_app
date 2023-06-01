import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/admin_module/FireBaseUsers/firebase_user_modal.dart';
import 'dart:developer' as devtools show log;

import 'package:influencer/admin_module/two_way_channel/view/widgets/admin_group_chat_controller.dart';

class FireBaseUsersController extends GetxController {
   final aGroupController = Get.put(AdminGroupChatController());
  TextEditingController messageController = TextEditingController();

  RxList<UsersListModal> firbaseUsersList = RxList(<UsersListModal>[]);
  
  List selectedIndices = [].obs.toList();

  late CollectionReference collectionReference;

  getAllRegisterUsers() => collectionReference.snapshots().map((query) =>
      query.docs.map((item) => UsersListModal.fromMap(item)).toList());

  @override
  void onInit() {
    super.onInit();

    collectionReference = FirebaseFirestore.instance.collection('users');

    firbaseUsersList.bindStream(getAllRegisterUsers());
  }
}
