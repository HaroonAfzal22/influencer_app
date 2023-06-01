import 'dart:developer';
import 'dart:io';
import 'package:influencer/admin_module/two_way_channel/view/widgets/group_list_card_widget.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:influencer/FirebaseServices/firbase_collection.dart';
import 'package:influencer/FirebaseServices/firebase_methods.dart';
import 'package:influencer/admin_module/FireBaseUsers/FireBaseUsersView.dart';
import 'package:influencer/admin_module/admin_group/add_participent_view.dart';
import 'package:influencer/admin_module/admin_group/admin_group_description_View.dart';
import 'package:influencer/admin_module/admin_group/group_setting_view.dart';
import 'package:influencer/admin_module/bottom_nav/bottom_nav.dart';
import 'package:influencer/admin_module/profile/image_view.dart';
import 'package:influencer/admin_module/two_way_channel/view/widgets/admin_group_chat_controller.dart';
import 'package:influencer/util/dimension.dart';

var headingStyle = const TextStyle(fontSize: 19, fontWeight: FontWeight.bold);
var subHeadingStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);

class AdminGroupDetailView extends StatefulWidget {
  const AdminGroupDetailView({super.key});

  @override
  State<AdminGroupDetailView> createState() => _AdminGroupDetailViewState();
}

class _AdminGroupDetailViewState extends State<AdminGroupDetailView> {
  final aGroupController = Get.find<AdminGroupChatController>();
  FirebaseStorage storage = FirebaseStorage.instance;
  File? imageFile;
  String imageUrl = '';
  String fileName = '';
  PickedFile? pickedImage;

  bool loading = false;

  late final FireBaseMethods _firebaseMethods;
// user stream method
  Stream<DocumentSnapshot<Map<String, dynamic>>> userStream(String docId) {
    final docRef = FirebaseFirestore.instance.collection('users').doc(docId);
    return docRef.snapshots();
  }

  // Stream Method
  Stream<DocumentSnapshot<Map<String, dynamic>>> getDocumentStream(
      String docId) {
    final docRef =
        FirebaseFirestore.instance.collection('groupChats').doc(docId);

    return docRef.snapshots();
  }

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
      collection: 'groupChats',
      docId: aGroupController.groupId,
      field: 'groupPhoto',
    ));
  }

  @override
  void initState() {
    _firebaseMethods = FireBaseMethods();
    super.initState();
  }

  bool values = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(228, 255, 255, 255),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: getDocumentStream(aGroupController.groupName),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            final snapData = snapshot.data;

            Map userIds = snapData?['GroupMembers'];
            aGroupController.groupDescription = snapData?['GroupDescription'];
            aGroupController.consenti.value = snapData?['Consenti'];
            aGroupController.tutti.value = snapData?['Tutti'];
            aGroupController.adminNotificationSattus.value =
                snapData?['adminNotificationSattus'];
            aGroupController.groupPhoto = snapData?['groupPhoto'];

            return ListView(
              scrollDirection: Axis.vertical,
              children: [
                // first container of picture
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 40.r,
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => bottomsheet(context),
                              backgroundColor: Colors.white,
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade100,
                            radius: 40.r,
                            child: ImageWidgetProg(
                              imageUrl: aGroupController.groupPhoto,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        snapData?['groupName'],
                        style: headingStyle,
                      ),
                      const SizedBox(
                        height: 13,
                      ),
                      Text(
                        "Group: ${snapData?['GroupMembers'].length}",
                        style: subHeadingStyle,
                      ),
                      const SizedBox(
                        height: 21,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Image.asset(
                                      'assets/images/audio_call.png')),
                              const Text("Audio call")
                            ],
                          ),
                          const SizedBox(
                            width: 13,
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Image.asset(
                                      'assets/images/video_call.png')),
                              const Text("Video call")
                            ],
                          ),
                          const SizedBox(
                            width: 13,
                          ),
                          Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    aGroupController.pressentGroupMemberMap
                                        .value = snapData?['GroupMembers'];
                                    Get.to(const AddParticipentView());
                                  },
                                  icon: Image.asset(
                                      'assets/images/add_person.png')),
                              const Text("Add")
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 21,
                ),
                // discriptio container
                Container(
                  color: Colors.white,
                  child: ListTile(
                    onTap: () {
                      Get.to(const GroupDescription());
                    },
                    title: const Text("Add Group description"),
                    subtitle: Text(
                      snapData?['GroupDescription'] == ''
                          ? 'Write a group discription'
                          : snapData?['GroupDescription'],
                      maxLines: 2,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 21,
                ),
                // notification group setting container
                Container(
                  color: Colors.white,
                  height: 130,
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text("Mute Notification"),
                        leading: const Icon(Icons.notifications),
                        trailing: Obx(() => Switch(
                            value:
                                aGroupController.adminNotificationSattus.value,
                            onChanged: ((value) {
                              aGroupController.adminNotificationSattus.value =
                                  value;
                              _firebaseMethods.updateCollection({
                                'adminNotificationSattus': aGroupController
                                    .adminNotificationSattus.value
                              }, 'groupChats', aGroupController.groupId);
                            }))),
                      ),
                      ListTile(
                        onTap: () {
                          Get.to(GroupSettingView());
                        },
                        title: const Text("Group Settings"),
                        leading: const Icon(Icons.settings),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 21,
                ),
                // All user list and share/ add participent etc..
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      ListTile(
                        onTap: () {
                          aGroupController.pressentGroupMemberMap.value =
                              snapData?['GroupMembers'];
                          Get.to(const AddParticipentView());
                        },
                        title: const Text("Add Participants"),
                        leading: CircleAvatar(
                          child: Image.asset(
                            'assets/images/icon_person.png',
                            color: Colors.white,
                          ),
                          radius: 23,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      ListTile(
                        title: const Text("Invite via Link"),
                        leading: CircleAvatar(
                          child: Image.asset(
                            'assets/images/share_link.png',
                            color: Colors.white,
                          ),
                          radius: 23,
                        ),
                      ),
                      for (var i in userIds.keys) ...[
                        StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: userStream(i),
                            builder: (context, snapshot) {
                              final snapUserData = snapshot.data;

                              return ListTile(
                                leading: snapUserData?['photoUrl'] == '' ||
                                        snapUserData?['photoUrl'] == null
                                    ? const CircleAvatar()
                                    : CircleAvatar(
                                        foregroundImage: NetworkImage(
                                            snapUserData?['photoUrl']),
                                        radius: 20,
                                      ),
                                title: Text(
                                    snapUserData?['name'].toString() ?? ''),
                              );
                            })
                      ]
                    ],
                  ),
                ),
                // exsit listtile
                ExitButtonWidget(
                  onClick: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Do you want to delete this channel?',
                              textAlign: TextAlign.center,
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
                                    try {
                                      _firebaseMethods.deleteDocument(
                                          'groupChats',
                                          aGroupController.groupId);
                                    } on Exception catch (e) {
                                      Get.snackbar('Errore',
                                          'qualcosa di sbagliato riprova più tardi',
                                          snackPosition: SnackPosition.BOTTOM,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 20));
                                    }

                                    Get.offAll(() => BottomNavigationBarPage());
                                  })
                            ],
                          );
                        });
                  },
                ),
              ],
            );
          },
        ));
  } // gellery widget

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

// Exit tile widget
class ExitButtonWidget extends StatelessWidget {
  const ExitButtonWidget({
    required this.onClick,
    Key? key,
  }) : super(key: key);

  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: 60,
      color: Colors.white,
      child: ListTile(
        onTap: onClick,
        title: const Text(
          "Delete Group",
          style: TextStyle(color: Colors.red, fontSize: 21),
        ),
        leading: const Icon(
          Icons.exit_to_app,
          color: Colors.red,
          size: 27,
        ),
      ),
    );
  }
}

/*

 
*/
/*
 
*/
/*

*/
// galery widgets
