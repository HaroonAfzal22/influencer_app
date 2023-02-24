import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:influencer/FirebaseMessage/single_chat_history_modal.dart';
import 'dart:developer' as devtools show log;

class MessageController extends GetxController {
  String otherUserId = '';
  String adminUserID = '';

  RxList<SingleChatHistoryModal> userHistoryList =
      RxList(<SingleChatHistoryModal>[]);

  late Stream<QuerySnapshot> collectionReference;
  //SingleChatHistoryModal.fromMap(item.data())

  getAllRegisterUsers() => collectionReference.map((query) => query.docs
      .map((item) => SingleChatHistoryModal.fromMap(item.data()))
      .toList());

  // getAllRegisterUsers() => collectionReference.map((query) =>
  //   query.docs.map((item) => devtools.log(item.data().toString())).toList());
  // getAllRegisterUsers() =>
  //     collectionReference.map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());

  @override
  void onInit() {
    super.onInit();

    collectionReference = FirebaseFirestore.instance
        .collection('recentChats')
        .orderBy('time', descending: true)
        .snapshots();
    userHistoryList.bindStream(getAllRegisterUsers());
  }
}
/*
    fireStore
                                    .collection('users')
                                    .doc(widget.userId)
                                    .collection('UsersChat')
                                    .add({
                                  'name':
                                      currentUser.currentUser!.name.toString(),
                                  'email':
                                      currentUser.currentUser!.email.toString(),
                                  'text': _controller.text,
                                  'photo': 'CurrentUserPhoto',
                                  'time': Timestamp.now(),
                                });
                                 sendMessage({
    name,
    email,
    message,
    photo,
  }) {
    collectionReference
        .collection('users')
        .doc(userId)
        .collection('UsersChat')
        .add({
      'name': name,
      'email': email,
      'text': message,
      'photo': photo,
      'time': Timestamp.now(),
    });
  }
*/
