import 'dart:developer';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:influencer/FirebaseMessage/single_chat_history_controller.dart';
import 'package:influencer/admin_module/profile/profile_controller.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/dimension.dart';
import 'package:influencer/util/string.dart';

class UserProfileDetailView extends StatefulWidget {
  const UserProfileDetailView({super.key});

  @override
  State<UserProfileDetailView> createState() => _UserProfileDetailViewState();
}

class _UserProfileDetailViewState extends State<UserProfileDetailView> {
  final userController = Get.find<MessageController>();
  final proController = Get.find<ProfileController>();
  Stream<DocumentSnapshot<Map<String, dynamic>>> getDocumentStream(
      String docId) {
    final docRef = FirebaseFirestore.instance.collection('users').doc(docId);
    return docRef.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          stream: getDocumentStream(proController.userProfileId.toString()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final docSnapshot = snapshot.data!;
            final data = docSnapshot.data();

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 40.r,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              Dimensions.containerHeight65),
                          child: data?['photoUrl'] == ''
                              ? Image.asset(
                                  'assets/images/person1.png',
                                  width: Dimensions.height135,
                                  height: Dimensions.height135,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  fit: BoxFit.cover,
                                  data?['photoUrl'].toString() ?? '',
                                )),
                    ),
                    // end of image
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    data?['name'],
                    style: TextStyle(
                        fontFamily: 'Poppins-Bold.ttf',
                        fontSize: Dimensions.fontSize22,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    timeago.format((data?['time'] as Timestamp).toDate()),
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'Poppins-Bold.ttf',
                      fontSize: Dimensions.textsize15,
                    ),
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Center(
                      child: Text(data?['Location'] == ''
                          ? 'La posizione non è selezionata.'
                          : data?['Location'])),
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
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: SizedBox(
                      height: 30.h,
                    ),
                  ),
                  ProfileViewTileWidget(
                    title: 'Sono',
                    value:
                        data?['Sono'] == '' ? 'Non selezionato' : data?['Sono'],
                  ),
                  ProfileViewTileWidget(
                    title: 'Interssi',
                    value: data?['Interssi'] == ''
                        ? 'Non selezionato'
                        : data?['Interssi'],
                  ),
                  ProfileViewTileWidget(
                    title: 'DI COSA TI OCCUPI? (1° OPZIONE)',
                    value: data?['opzione1'],
                  ),
                  ProfileViewTileWidget(
                    title: 'DI COSA TI OCCUPI? (2° OPZIONE)',
                    value: data?['opzione2'],
                  ),
                  ProfileViewTileWidget(
                    title: 'Eta',
                    value: data?['DateOfBirth'] == ''
                        ? 'Non selezionato'
                        : data?['DateOfBirth'],
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 50.h,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class ProfileViewTileWidget extends StatelessWidget {
  const ProfileViewTileWidget(
      {Key? key, required this.title, required this.value})
      : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            value,
            style: TextStyle(
                color: Colors.blue, fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
