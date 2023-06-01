import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:influencer/FirebaseServices/dynamic_links.dart';
import 'package:influencer/FirebaseServices/firebase_auth.dart';
import 'package:influencer/admin_module/archiviazione/view/contact_listAdmin_startchannel.dart';
import 'package:influencer/admin_module/profile/image_view.dart';
import 'package:influencer/admin_module/profile/profile_controller.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'package:influencer/routes/app_pages.dart';
import 'package:influencer/routes/app_routes.dart';
import 'package:influencer/userModule/profile/view/widget/notification.dart';
import 'package:influencer/util/LoadingWidget.dart';
import 'package:influencer/util/dimension.dart';
import 'package:influencer/util/string.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../Helper/shared_pre_const.dart';
import '../../util/color.dart';
import '../admin_archived/view/component/googlemap.dart';
import 'package:path/path.dart' as path;

class Profile extends StatefulWidget {
  Profile({
    Key? key,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final currentController = Get.put(CurrentUserController());

  File? imageFile;
  String imageUrl = '';
  String fileName = '';
  PickedFile? pickedImage;

  var subadminstrationarea = '';
  var country = '';
  SharedPrefsHelper helper = SharedPrefsHelper();

  final proController = Get.find<ProfileController>();
  bool loader = false;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getDocumentStream(
      String docId) {
    final docRef = FirebaseFirestore.instance.collection('users').doc(docId);
    return docRef.snapshots();
  }

  @override
  void initState() {
    // myInit();
    helper.getSharedData();
    // TODO: implement initState
    super.initState();
  }

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> _selectPicture(String inputSource) async {
    final picker = ImagePicker();

    pickedImage = await picker.getImage(
      source:
          inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
      maxWidth: Dimensions.width190,
      maxHeight: Dimensions.height90 * 2,
    );

    fileName = path.basename(pickedImage!.path);
    imageFile = File(pickedImage!.path);

    var w = await Get.to(ImageView(
      imageFile: imageFile,
      fileName: fileName,
      imageUrl: imageUrl,
      pickedImage: pickedImage,
      collection: 'users',
      docId: currentController.currentUser?.uid ?? '',
      field: 'photoUrl',
    ));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onbackpress(context),
      child: loader == true
          ? const LoaderWidget()
          : Scaffold(
              backgroundColor: IColor.colorWhite,
              appBar: AppBar(
                centerTitle: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                surfaceTintColor: Colors.white,
                title: const Text(
                  Strings.profile,
                  style: TextStyle(color: IColor.colorblack),
                ),
                actions: [
                  GestureDetector(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      helper.sharedPreferences.remove(helper.userId);

                      Get.offAllNamed(AppPages.INITIAL);
                    },
                    child: SignOutWidget(),
                  )
                ],
              ),
              body: SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: Get.size.height,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: getDocumentStream(
                                currentController.currentUser?.uid ?? ''),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              }
                              final docSnapshot = snapshot.data!;
                              final data = docSnapshot.data();

                              return Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 40.r,
                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) =>
                                              bottomsheet(context),
                                          backgroundColor: Colors.white,
                                        );
                                      },
                                      child: CircleAvatar(
                                        // backgroundColor: Colors.transparent,
                                        radius: 40.r,
                                        child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.containerHeight65),
                                            child: data?['photoUrl'] == ''
                                                ? Image.asset(
                                                    'assets/images/person1.png',
                                                    width: Dimensions.height135,
                                                    height:
                                                        Dimensions.height135,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(
                                                    fit: BoxFit.cover,
                                                    data?['photoUrl']
                                                            .toString() ??
                                                        '',
                                                  )),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    currentController.currentUser!.name
                                        .toString(),
                                    style: TextStyle(
                                        fontFamily: 'Poppins-Bold.ttf',
                                        fontSize: Dimensions.fontSize22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  Text(
                                    timeago.format(
                                        currentController.currentUser?.time),
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontFamily: 'Poppins-Bold.ttf',
                                      fontSize: Dimensions.textsize15,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  //  Text(subadminstrationarea),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Paths.user_Setting);
                                    },
                                    child: Container(
                                      child: Center(
                                          child: Text(data?['Location'] == ''
                                              ? 'Imposta la tua posizione'
                                              : data?['Location'])),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            width: Get.size.width - 30.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              color: IColor.mainBlueColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(17.r),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: Dimensions.fontSize20,
                                      left: Dimensions.fontSize20),
                                  child: Column(
                                    children: [
                                      Text(
                                        '210.901',
                                        style: TextStyle(
                                            fontSize: Dimensions.fontSize20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: Dimensions.fontSize20,
                                      ),
                                      const Text(
                                        'Punteggio',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: Dimensions.paddingLeft10,
                                      bottom: Dimensions.paddingLeft10,
                                      left: Dimensions.height30),
                                  child: const VerticalDivider(
                                    thickness: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: Dimensions.fontSize20,
                                      left: Dimensions.fontsize30),
                                  child: Column(
                                    children: [
                                      Text(
                                        '10.256',
                                        style: TextStyle(
                                            fontSize: Dimensions.fontSize20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: Dimensions.fontSize20,
                                      ),
                                      const Text(
                                        'Followers totali',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 17.h,
                          ),
                          Container(
                            width: Get.size.width - 30.w,
                            height: Dimensions.height65,
                            decoration: BoxDecoration(
                              color: const Color(0xff7BD85A),
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimensions.paddingLeft10),
                              ),
                            ),
                            child: InkWell(
                              onTap: () async {
                                String generatedDynamicLink =
                                    await CreateDynamicLink.createDynamicLink();
                                Share.share(generatedDynamicLink,
                                    subject: 'Share with your Friends');
                              },
                              child: const Center(
                                child: Text(
                                  'Condividi il tuo codice invito',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          UserProfileSettingBtn(
                              title: 'Il mio account',
                              icon: Icons.edit_note_outlined,
                              onpress: () {
                                Get.toNamed(Paths.user_Setting);
                              }),
                          SizedBox(
                            height: 10.h,
                          ),
                          UserProfileSettingBtn(
                              title: Strings.notifiche,
                              icon: Icons.notifications_none_outlined,
                              onpress: () {
                                Get.to(UserNotification());
                              }),
                          SizedBox(
                            height: 10.h,
                          ),
                          UserProfileSettingBtn(
                              title: "Archiviazione",
                              icon: Icons.file_copy_outlined,
                              onpress: () {
                                Get.to(Archiviazione(),
                                    transition: Transition.fadeIn);
                              }),
                          SizedBox(
                            height: 10.h,
                          ),
                          UserProfileSettingBtn(
                              title: "FAQ",
                              icon: Icons.question_answer_outlined,
                              onpress: () {}),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
    );
  }

  Widget bottomsheet(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * .2,
      margin: EdgeInsets.symmetric(
          vertical: Dimensions.fontSize20,
          horizontal: Dimensions.paddingLeft10),
      child: Column(
        children: [
          Text(
            "Choose Profile Photo",
            style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: Dimensions.fontSize20),
          ),
          SizedBox(
            height: Dimensions.height50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.image,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      height: Dimensions.paddingvertical5,
                    ),
                    Text(
                      "Gallery",
                      style: TextStyle(
                          fontSize: Dimensions.fontSize20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    )
                  ],
                ),
                onTap: () {
                  _selectPicture('gallery');
                  Get.back();
                },
              ),
              SizedBox(
                width: Dimensions.containerwidth180,
              ),
              InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                    SizedBox(height: Dimensions.paddingvertical5),
                    Text(
                      "Camera",
                      style: TextStyle(
                          fontSize: Dimensions.fontSize20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    )
                  ],
                ),
                onTap: () {
                  print("Camera");

                  _selectPicture('camera');
                  Get.back();
                },
              )
            ],
          )
        ],
      ),
    );
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: Dimensions.width190,
      maxHeight: Dimensions.height90 * 2,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
    Navigator.pop(context);
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: Dimensions.width190,
      maxHeight: Dimensions.height90 * 2,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        Navigator.pop(context);
      });
    }
  }
}

class SignOutWidget extends StatelessWidget {
  const SignOutWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: IColor.mainBlueColor,
      ),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      padding: const EdgeInsets.all(10),
      child: const Center(
          child: Text(
        'LogOut',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
    );
  }
}

class UserProfileSettingBtn extends StatelessWidget {
  UserProfileSettingBtn(
      {Key? key, required this.icon, required this.onpress, this.title})
      : super(key: key);
  IconData icon;
  String? title;
  Function() onpress;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpress,
      child: Container(
          width: Get.size.width - 30.w,
          height: Dimensions.height60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.paddingLeft10),
            border: Border.all(color: Colors.white),
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
                blurRadius: 1,
                spreadRadius: 1,
                offset: Offset(4.0, 5.0),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 13.w),
                      child: Icon(
                        icon,
                        size: Dimensions.fontsize30,
                        color: Color.fromARGB(224, 0, 70, 250),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.fontSize20),
                      child: Text(
                        title.toString(),
                        style: TextStyle(
                            fontSize: Dimensions.fontSize18,
                            color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: Dimensions.height65),
                child: InkWell(
                  child: const Icon(Icons.arrow_forward_ios,
                      color: Color.fromARGB(224, 0, 70, 250)),
                ),
              ),
            ],
          )),
    );
  }
}

class TextField {
  static textFormField({
    required String lable,
    hintText,
    TextEditingController? controller,
  }) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Enter your ${lable}';
        }
        return null;
      },
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelStyle: TextStyle(fontSize: 14, color: Colors.white),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        label: Text(lable),
        hintText: '',
      ),
    );
  }
}

Future<bool> onbackpress(BuildContext context) async {
  bool exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('close app'),
          content: const Text('Do want to close app '),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('No')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes')),
          ],
        );
      });
  return exitApp ?? false;
}

// image view
