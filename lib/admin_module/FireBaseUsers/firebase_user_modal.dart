import 'package:cloud_firestore/cloud_firestore.dart';

class UsersListModal {
  String? docId;
  String? uid = '';
  String? name = '';
  String? surename = '';
  String? email = '';
  String? photoUrl = '';
  String? userRole = '';
  String? phone = '';
  dynamic time = '';
  String? status = '';
  String? lastSeen = '';
  String? homeView = '';

  UsersListModal(
      {this.docId,
      this.email,
      this.name,
      this.surename,
      this.photoUrl,
      this.uid,
      this.userRole,
      this.phone,
      this.status,
      this.time,
      this.lastSeen,
      this.homeView});

  UsersListModal.fromMap(DocumentSnapshot data) {
    docId = data.id;
    uid = data['uid'];
    name = data['name'];
    surename = data['surename'];
    email = data['email'];
    phone = data['phone'];
    photoUrl = data['photoUrl'];
    userRole = data['userRole'];
    status = data['status'];
    time = data['time'];
    lastSeen = data['lastSeen'];
    homeView = data['homeview'];
  }
}
