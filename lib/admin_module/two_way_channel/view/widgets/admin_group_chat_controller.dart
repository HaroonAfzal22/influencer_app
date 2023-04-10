import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminGroupChatController extends GetxController {
  Map groupMembersStatusMap = {
  }.obs;
  /*
  'time':Timestamp.now(),
'lastMessage':'',
'admin':0

  */

  List groupMembers = [].obs.toList();
  Map groupSetting = {'Tutti': false, 'Consenti': false}.obs;
  String groupName = 'noName'.obs.toString();
  String selectedGroup = ''.obs.toString();
}
