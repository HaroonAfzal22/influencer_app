import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseOtherUser {
  final fireStore = FirebaseFirestore.instance;
 var users;

 otherUser({otherUserId,collection})  {
    users = fireStore.collection(collection).doc(otherUserId).get();

    return users;
  }
}
