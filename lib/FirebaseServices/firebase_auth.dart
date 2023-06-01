import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/FirebaseServices/firbase_collection.dart';
import 'package:influencer/Helper/shared_pre_const.dart';
import 'package:influencer/Modals/user_modal.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'dart:developer' as devtools show log;
import 'package:influencer/routes/app_pages.dart';
import 'package:influencer/userModule/inlfuencer_club/view/email_verification_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider {
  final controller = Get.find<CurrentUserController>();
  final auth = FirebaseAuth.instance;
  var users = FirebaseFirestore.instance.collection('users');

// register user

  Future registerFireBaseUser(
      {email,
      password,
      name,
      surname,
      phone,
      fcmToken,
      opzione1,
      opzione2}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (auth.currentUser != null) {
        String? token = await FirebaseMessaging.instance.getToken();

        FirebaseMethods.addUserCollection(
          uid: auth.currentUser?.uid.toString(),
          name: name,
          sureName: surname,
          phone: phone,
          email: email,
          password: password,
          fcmToken: token,
          
        );
        Get.offNamed(Paths.loginView);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar('Error', 'This email is already in use',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.symmetric(vertical: 20));
      } else if (e.code == 'weak-password') {
        Get.snackbar('Error', 'password must b 8 characters',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.symmetric(vertical: 20));
      }
    } on Exception catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.symmetric(vertical: 20));
    }
  }

  // Signin User

  Future<UserModal?> signInFireBaseUser({email, password}) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await auth.signInWithEmailAndPassword(email: email, password: password);

      if (auth.currentUser != null) {
        if (auth.currentUser?.emailVerified ?? true) {
          //------------------------------
          String? token = await FirebaseMessaging.instance.getToken();

          final userDocId = auth.currentUser?.uid;
          await users.doc(userDocId).update({'fcmToken': token});
          devtools.log('user fcm token $token');

          SharedPrefsHelper helper = SharedPrefsHelper();
          sharedPreferences.setString(helper.userId, userDocId.toString());

          final userDocData = await users.doc(userDocId).get();
          final udoc = userDocData.data();
          controller.userModal?.value = UserModal.fromJson(udoc!);

          // I ll implement furthur here things thanks
          Get.offNamed(Paths.bottomNavigationBarPage);
        } else {
          auth.currentUser!.sendEmailVerification();
          Get.to(const EmailverificationView());
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'User not find on this email',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.symmetric(vertical: 20));

        devtools.log('User not found');
      } else if (e.code == 'wornd-password') {
        Get.snackbar('Error', 'Your password is not correct',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.symmetric(vertical: 20));
      } else {
        Get.snackbar('Error', e.code,
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.symmetric(vertical: 20));
      }
      // TODO
    } on Exception catch (e) {
      Get.snackbar('Error', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.symmetric(vertical: 20));
    }
    return controller.userModal?.value;
  }

// LoginUser
  getCurrentUser(userDocId) async {
    final userDocData = await users.doc(userDocId).get();
    final udoc = userDocData.data();
    controller.userModal?.value = UserModal.fromJson(udoc!);
  }
}
