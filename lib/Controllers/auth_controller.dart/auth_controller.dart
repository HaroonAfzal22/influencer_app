import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/FirebaseServices/firebase_auth.dart';
import 'package:influencer/Modals/user_body_modal.dart';
import 'package:influencer/Modals/user_modal.dart';

class AuthController extends GetxController {
  bool isLoading = false;
  AuthProvider authProvider = AuthProvider();
  UserModelBody user = UserModelBody();
  late TextEditingController emailLoginController;
  late TextEditingController passwordLoginController;
  late TextEditingController nameController;
  late TextEditingController surNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController confirmController;
  

  @override
  void onInit() {
    emailLoginController = TextEditingController();
    passwordLoginController = TextEditingController();
    nameController = TextEditingController();
    surNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmController = TextEditingController();
    
    super.onInit();
  }

  createUser() async {
    isLoading = true;

    update();

    await authProvider.registerFireBaseUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        phone: phoneController.text,
        surname: surNameController.text);

    isLoading = false;
    update();
  }

  // login user

  Future signInUser() async {
    isLoading = true;
    update();
    final data = await authProvider.signInFireBaseUser(
      email: emailLoginController.text,
      password: passwordLoginController.text,
    );
    log('user controller data ${data!.uid}');
    isLoading = false;
    update();
  }
}
