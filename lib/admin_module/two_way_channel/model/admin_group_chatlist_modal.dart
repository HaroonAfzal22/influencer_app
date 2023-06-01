import 'package:intl/intl.dart';

class AdminGroupChatListModal {
  String? docId;
  int? adminCount = 0;
  Map? groupMembers;
  String? consenti = '';
  String? groupPhoto = '';
  bool? muta = false;
  bool? nova = false;
  dynamic tutti = '';
  String? lastMessage = '';
  String? groupName='';
  var time;

  AdminGroupChatListModal(
      {this.docId,
      this.groupMembers,
      this.consenti,
      this.groupPhoto,
      this.muta,
      this.adminCount,
      this.nova,
      this.lastMessage,
      this.time,
      this.tutti,
      this.groupName});

  AdminGroupChatListModal.fromMap(data) {
    DateTime dateTime = data['time'].toDate();

    final dateString = DateFormat('hh:mm:ss').format(dateTime);
    // docId = data.id;
    adminCount = data['AdminCount'];
    groupMembers = data['GroupMembers'];
    consenti = data['Consenti'];
    groupPhoto = data['groupPhoto'];
    muta = data['Muta'];
    nova = data['Nova'];
    tutti = data['Tutti'];
    lastMessage = data['astMessage'];
    groupName = data['groupName'];
    time = dateString;
  }
}
