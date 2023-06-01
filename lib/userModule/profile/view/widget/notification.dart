import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/userModule/profile/view/component/notification_appbar.dart';
import 'package:influencer/util/string.dart';

import '../../../../admin_module/two_way_channel/view/home_controller.dart';

class UserNotification extends StatefulWidget {
  const UserNotification({Key? key}) : super(key: key);

  @override
  State<UserNotification> createState() => _UserNotificationState();
}

class _UserNotificationState extends State<UserNotification> {
  final currentController = Get.put(CurrentUserController());
  bool status1 = false;
  bool status2 = false;
  bool status3 = false;
  bool status4 = false;
  bool status5 = false;
  bool status6 = false;
  bool status7 = false;
  final fireStore = FirebaseFirestore.instance;
  Stream<DocumentSnapshot<Map<String, dynamic>>> getDocumentStream(
      String docId) {
    final docRef = FirebaseFirestore.instance.collection('users').doc(docId);
    return docRef.snapshots();
  }

  updateCollection({map}) async {
    await fireStore
        .collection('users')
        .doc(currentController.currentUser?.uid)
        .update(map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title: Text(
          Strings.notifiche,
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

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 18, top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notifiche Push',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Messaggi',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Switch(
                            value: data?['Messaggi'],
                            onChanged: (value) {
                              setState(() {
                                status1 = value;
                                updateCollection(map: {
                                  'Messaggi': status1,
                                });
                              });
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Attivita account',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Switch(
                            value: data?['AttivitaAccount'],
                            onChanged: (value) {
                              setState(() {
                                status2 = value;
                                updateCollection(
                                    map: {'AttivitaAccount': status2});
                              });
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Annunci',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Switch(
                            value: data?['Annunci'],
                            onChanged: (value) {
                              setState(() {
                                status3 = value;
                                updateCollection(map: {'Annunci': status3});
                              });
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Messaggi',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Switch(
                            value: data?['Messagg0'],
                            onChanged: (value) {
                              setState(() {
                                status4 = value;
                                updateCollection(map: {'Messagg0': status4});
                              });
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Raccomandazioni',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Messaggi',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Switch(
                            value: data?['RMessaggi'],
                            onChanged: (value) {
                              setState(() {
                                status5 = value;
                                updateCollection(map: {'RMessaggi': status5});
                              });
                            },
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Attivita account',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Switch(
                            value: data?['RAvvivitaAccount'],
                            onChanged: (value) {
                              setState(() {
                                status6 = value;
                                updateCollection(
                                    map: {'RAvvivitaAccount': status6});
                              });
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),

        //------------------
      ),
    );
  }
}
