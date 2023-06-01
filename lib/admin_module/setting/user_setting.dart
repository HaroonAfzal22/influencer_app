import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:influencer/Controllers/auth_controller.dart/auth_controller.dart';
import 'package:influencer/admin_module/profile/profile_controller.dart';
import 'package:influencer/admin_module/setting/user_profile_widget.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'package:influencer/routes/app_pages.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/common_app.dart';
import 'package:influencer/util/string.dart';
import 'package:intl/intl.dart';

class User_Setting extends StatefulWidget {
  const User_Setting({Key? key}) : super(key: key);

  @override
  State<User_Setting> createState() => _User_SettingState();
}

class _User_SettingState extends State<User_Setting> {
  RangeValues _currentRangeValues = const RangeValues(40, 80);

  bool status = false;
  bool status1 = false;
  bool status2 = false;
  // String? gender = "Male";
  int? groupValue;
  int? groupValue1;
  var datepick;
  final fireStore = FirebaseFirestore.instance;
  final proController = Get.find<ProfileController>();
  final currentController = Get.put(CurrentUserController());
  Stream<DocumentSnapshot<Map<String, dynamic>>> getDocumentStream(
      String docId) {
    final docRef = FirebaseFirestore.instance.collection('users').doc(docId);
    return docRef.snapshots();
  }

  String? date;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: Text(
          Strings.mio_account,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: getDocumentStream(currentController.currentUser?.uid ?? ''),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            final docSnapshot = snapshot.data!;
            final data = docSnapshot.data();
            proController.sono = data?['Sono'];
            proController.interssi = data?['Interssi'];
            proFileController.opzione1 = data?['opzione1'];
            proFileController.opzione2 = data?['opzione2'];

            return Column(
              children: [
                SizedBox(
                  height: 15.h,
                ),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          dialogboxSono(
                              context: context,
                              title1: "Maschia",
                              title2: "Femmina",
                              title3: "Altra",
                              canOnpress: () {
                                Get.back();
                              },
                              okOnpress: () {
                                log('intesti ${proController.sono}');
                                fireStore
                                    .collection('users')
                                    .doc(currentController.currentUser?.uid)
                                    .update({'Sono': proController.sono});
                                Get.back();
                              });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sono',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              proController.sono == ''
                                  ? 'Donna / Uomo'
                                  : proController.sono,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () => dialogboxInterassi(
                            context: context,
                            title1: "Cibo ",
                            title2: "Lingerie",
                            title3: "Beauty",
                            canOnpress: () {
                              Get.back();
                            },
                            okOnpress: () {
                              log('intesti ${proController.interssi}');
                              fireStore
                                  .collection('users')
                                  .doc(currentController.currentUser?.uid)
                                  .update({'Interssi': proController.interssi});

                              Get.back();
                            }),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Interessi',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              proController.interssi == ''
                                  ? 'Cibo,Lingerie,Beauty'
                                  : proController.interssi,
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //----- haroon implemented new functionlity here
                      GestureDetector(
                        onTap: () => dialogboxOptimize1(
                            context: context,
                            okOnpress: () async {
                              log('log message consloe :::${proFileController.opzione1}');

                              await fireStore
                                  .collection('users')
                                  .doc(currentController.currentUser?.uid)
                                  .update(
                                      {'opzione1': proFileController.opzione1});
                              Get.back();
                            },
                            canOnpress: () {
                              Get.back();
                            }),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              flex: 6,
                              child: Text(
                                'DI COSA TI OCCUPI? (1° OPZIONE)',
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              proFileController.opzione1,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      GestureDetector(
                        onTap: () => dialogboxOptimize2(
                            context: context,
                            okOnpress: () async {
                              await fireStore
                                  .collection('users')
                                  .doc(currentController.currentUser?.uid)
                                  .update({
                                'opzione2':
                                    proFileController.opzione2.toString()
                              });
                              Get.back();
                            },
                            canOnpress: () {
                              Get.back();
                            }),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              flex: 6,
                              child: Text(
                                'DI COSA TI OCCUPI? (2° OPZIONE)',
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              proFileController.opzione2,
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Paths.setLocation);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Location',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              data?['Location'] == ''
                                  ? 'Verona, IT'
                                  : data?['Location'],
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          datepick = await showDatePicker(
                              initialDatePickerMode: DatePickerMode.day,
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1980),
                              lastDate: DateTime.now());

                          if (datepick != null) {
                            var dateUpdate =
                                DateFormat('MMMM ,dd ,yyy').format(datepick);
                            fireStore
                                .collection('users')
                                .doc(currentController.currentUser?.uid)
                                .update({'DateOfBirth': dateUpdate});
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Età',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              data?['DateOfBirth'] == ''
                                  ? '00-00-0000'
                                  : data?['DateOfBirth'],
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> dialogboxSono({
    context,
    title1,
    title2,
    title3,
    canOnpress,
    var okOnpress,
  }) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          var selectedRadio = 0;
          return AlertDialog(
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile(
                          title: Text(title1),
                          value: 'Maschia',
                          groupValue: proController.sono,
                          onChanged: (value) {
                            setState(() {
                              proController.sono = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text(title2),
                          value: "Femmina",
                          groupValue: proController.sono,
                          onChanged: (value) {
                            setState(() {
                              proController.sono = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text(title3),
                          value: "Altra",
                          groupValue: proController.sono,
                          onChanged: (value) {
                            setState(() {
                              proController.sono = value.toString();
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: canOnpress,
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: okOnpress, child: const Text('Ok')),
                          ],
                        )
                      ]),
                );
              },
            ),
          );
        });
  }
  // interessi dialoge

  Future<void> dialogboxInterassi({
    context,
    title1,
    title2,
    title3,
    canOnpress,
    var okOnpress,
  }) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          var selectedRadio = 0;
          return AlertDialog(
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        RadioListTile(
                          title: Text(title1),
                          value: "Cibo",
                          groupValue: proController.interssi,
                          onChanged: (value) {
                            setState(() {
                              proController.interssi = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text(title2),
                          value: "Lingerie",
                          groupValue: proController.interssi,
                          onChanged: (value) {
                            setState(() {
                              proController.interssi = value.toString();
                            });
                          },
                        ),
                        RadioListTile(
                          title: Text(title3),
                          value: "Beauty",
                          groupValue: proController.interssi,
                          onChanged: (value) {
                            setState(() {
                              proController.interssi = value.toString();
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: canOnpress,
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: okOnpress, child: const Text('Ok')),
                          ],
                        )
                      ]),
                );
              },
            ),
          );
        });
  }
}
