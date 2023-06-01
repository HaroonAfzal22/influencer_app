import 'dart:developer';

import 'package:get/get.dart';
import 'package:influencer/FirebaseServices/firbase_collection.dart';

import 'package:influencer/Modals/user_modal.dart';

class CurrentUserController extends GetxController {
  Rx<UserModal>? userModal;

  UserModal? get currentUser => userModal?.value;

  @override
  void onInit() {
    userModal = UserModal().obs;

    log('user modal from init data ${userModal?.value}');
    super.onInit();

  }
 
}
