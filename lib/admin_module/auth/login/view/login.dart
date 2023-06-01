import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/Controllers/auth_controller.dart/auth_controller.dart';

import 'package:influencer/admin_module/auth/registeration/view/registeration.dart';
import 'package:influencer/routes/app_pages.dart';
import 'package:influencer/util/LoadingWidget.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/commonbutton.dart';
import 'package:influencer/util/editText.dart';
import 'package:influencer/util/image_const.dart';
import 'package:influencer/util/string.dart';

class LoginView extends StatelessWidget {
  LoginView({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double h = Get.size.height;
    double w = Get.size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImageConstant.auth_bg), fit: BoxFit.cover),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Form(
              key: _formKey,
              child: GetBuilder<AuthController>(
                init: AuthController(),
                builder: (controller) {
                  return Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Spacer(),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: h * 0.023),
                            child: Center(
                                child: Text(
                              "Accedi",
                              style: TextStyle(
                                  color: IColor.colorWhite,
                                  fontFamily: 'Poppins',
                                  fontSize: h * 0.05,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: h * 0.03),
                            child: Text(
                              "E-mail",
                              style: TextStyle(color: IColor.colorWhite),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: h * 0.026),
                            child: EditText(
                              controller: controller.emailLoginController,
                              hint: "La tua e-mail",
                              formvalidate: (value) {
                                if (!value!.contains('@') && value.isNotEmpty) {
                                  return "L'email non è valida";
                                } else if (value.isEmpty) {
                                  return "Inserisci un'e-mail";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: h * 0.03),
                            child: Text(
                              "Parola d'ordine",
                              style: TextStyle(color: IColor.colorWhite),
                            ),
                          ),
                          SizedBox(
                            height: h * 0.013,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: h * 0.026),
                            child: EditText(
                              controller: controller.passwordLoginController,
                              hint: "Parola d'ordine",
                              formvalidate: (value) {
                                if (value.isNotEmpty && value.length > 7) {
                                  return null;
                                } else if (value.length < 8 &&
                                    value.isNotEmpty) {
                                  return 'Inserisci almeno 8 caratteri';
                                } else {
                                  return 'Per favore inserisci LA TUA password';
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: h * 0.023,
                          ),
                          controller.isLoading == true
                              ? const LoaderWidget()
                              : CommonButton(
                                  title: Strings.login,
                                  onpress: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await controller.signInUser();
                                    }
                                  },
                                ),
                          SizedBox(
                            height: h * 0.04,
                          ),
                          InkWell(
                            onTap: () {
                              Get.toNamed(Paths.forgotPassword);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(Strings.forgetpassword,
                                      style:
                                          TextStyle(color: IColor.colorWhite))),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: h * 0.04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  Strings.Alreadyaccount,
                                  style: TextStyle(color: IColor.colorWhite),
                                ),
                                TextButton(
                                    onPressed: () {
                                      Get.to(InfluencerForm());
                                    },
                                    child: const Text(Strings.Signup,
                                        style: TextStyle(
                                            color: IColor.colorWhite,
                                            fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ],
                  );
                },
              ),
            )),
      ),
    );
  }
}
