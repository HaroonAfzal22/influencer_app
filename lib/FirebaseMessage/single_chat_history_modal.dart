import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SingleChatHistoryModal {
  String? docId;
  String? curentUid;
  String? otherUid;
  String? otherName = '';
  String? photoUrl = '';
  String? message = '';
  int? adminMessageCount = 0;
  int? userMessageCount = 0;
  dynamic time = '';
  bool? isUserRead = false;
  bool? isAdminRead = false;

  SingleChatHistoryModal(
      {this.docId,
      this.otherName,
      this.photoUrl,
      this.time,
      this.message,
      this.isAdminRead,
      this.isUserRead});

  SingleChatHistoryModal.fromMap(data) {
    DateTime dateTime = data['time'].toDate();

    final dateString = DateFormat('hh:mm:ss').format(dateTime);
    // docId = data.id;
    otherUid = data['otherUid'];
    curentUid = data['curentUid'];
    photoUrl = data['photoUrl'];
    adminMessageCount = data['adminMessageCount'];
    userMessageCount = data['userMessageCount'];
    message = data['lastMessage'];
    isUserRead = data['isUserRead'];
    isAdminRead = data['isAdminRead'];
    otherName = data['otherName'];
    time = dateString;
  }
}
