import 'package:get/get.dart';

class AdminGroupChatController extends GetxController {
  Map groupMembersStatusMap = {}.obs;
  RxMap pressentGroupMemberMap = {}.obs;
  RxMap notificationSattusMap = {}.obs;
  String groupId = ''.obs.toString();
  String groupDescription = 'Write a group description'.obs.toString();
  String groupPhoto = ''.obs.toString();

  

Rx<bool> adminNotificationSattus = false.obs;
  Rx<bool> tutti = false.obs;
  Rx<bool> consenti = false.obs;
  Rx<bool> muta = false.obs;
  Rx<bool> nova = false.obs;
  String groupName = 'noName'.obs.toString();
  String selectedGroup = ''.obs.toString();
  int adminCount = 0.obs.toInt();
  List userFcm = [].obs.toList();
  List adminCollectionFcm = [].obs.toList();
  List usersCollectionFcm = [].obs.toList();
  bool changeIcon = false.obs.value;

//   getUserColl(){

// for( var  i in Firestore.instance.collection('user'))
//   }

  /*
  late Stream<QuerySnapshot> collectionReference;
  RxList<AdminGroupChatListModal> adminGroupChatList =
      RxList(<AdminGroupChatListModal>[]);
  getAllRegisterUsers() =>
      collectionReference.map((query) => query.docs.map((item) {
            log(item.data().toString());
            AdminGroupChatListModal.fromMap(item.data());
          }).toList());

  //


  @override
  void onInit() {
    super.onInit();

    /*
    collectionReference = FirebaseFirestore.instance
        .collection('groupChats')
        .orderBy('time', descending: true)
        .get()
        .asStream();

    log('controller data printing $collectionReference');
    */

    // adminGroupChatList.bindStream(getAllRegisterUsers());
  }
*/
}
