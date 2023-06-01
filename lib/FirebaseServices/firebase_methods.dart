import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseMethods {
  final fireStore = FirebaseFirestore.instance;
  var users;

  getUserCollectData({otherUserId, collection}) {
    users = fireStore.collection(collection).doc(otherUserId).get();

    return users;
  }

  updateCollection(Map<dynamic, dynamic> map, collection, docId) {
    Map<String, Object?> groupMembersStatusMap = map.cast<String, Object?>();
    fireStore.collection(collection).doc(docId).update(groupMembersStatusMap);
  }
  // set collection

  setCollection(Map<dynamic, dynamic> map, collection, docId) {
    Map<String, Object?> groupMembersStatusMap = map.cast<String, Object?>();
    fireStore.collection(collection).doc(docId).set(groupMembersStatusMap);
  }

  deleteDocument(String collectionName, String docId) {
    fireStore.collection(collectionName).doc(docId).delete();
  }

  // add collection
  addCollection({collectionPath,msgCollectionPath, documentMap,docId}) {
    fireStore.collection(collectionPath).doc(docId).collection(msgCollectionPath).add(documentMap);
  }

  /////
  ///
}
