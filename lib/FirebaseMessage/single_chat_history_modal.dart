import 'package:intl/intl.dart';

class SingleChatHistoryModal {
  String? docId;
  String? adminUid;
  String? userUid;
  String? userName = '';
  String? photoUrl = '';
  String? message = '';
  int? adminMessageCount = 0;
  int? userMessageCount = 0;
  dynamic time = '';
  bool? isUserRead = false;
  bool? isAdminRead = false;

  SingleChatHistoryModal(
      {this.docId,
      this.userName,
      this.photoUrl,
      this.time,
      this.message,
      this.isAdminRead,
      this.isUserRead});

  SingleChatHistoryModal.fromMap(data) {
    DateTime dateTime = data['time'].toDate();

    final dateString = DateFormat('hh:mm:ss').format(dateTime);
    // docId = data.id;
    userUid = data['userUid'];
    adminUid = data['adminUid'];
    photoUrl = data['photoUrl'];
    adminMessageCount = data['adminMessageCount'];
    userMessageCount = data['userMessageCount'];
    message = data['lastMessage'];
    isUserRead = data['isUserRead'];
    isAdminRead = data['isAdminRead'];
    userName = data['userName'];
    time = dateString;
  }
}
