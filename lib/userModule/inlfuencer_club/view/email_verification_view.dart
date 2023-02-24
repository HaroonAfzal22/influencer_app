import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/routes/app_routes.dart';
import 'package:influencer/util/color.dart';

class EmailverificationView extends StatefulWidget {
  const EmailverificationView({Key? key}) : super(key: key);

  @override
  State<EmailverificationView> createState() => _EmailverificationViewState();
}

class _EmailverificationViewState extends State<EmailverificationView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
            'Email verify',
            style: TextStyle(color: IColor.colorblack),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.06,
            ),
            const Text(
              "We've sent you an email verification. Please open it to verify your account",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: IColor.mainBlueColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            const Text(
              "If you haven 't recived a verification email yet, Press the button below",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.06,
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              height: size.height * 0.06,
              minWidth: size.width * 0.6,
              onPressed: () {
                final user = FirebaseAuth.instance.currentUser;
                user?.sendEmailVerification();
              },
              child: Text('send email verification',
                  style: TextStyle(color: IColor.colorWhite)),
              color: IColor.mainBlueColor,
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Get.offNamed(AppPages.INITIAL);
              },
              child: const Text('reset',
                  style: TextStyle(
                      color: IColor.mainBlueColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
