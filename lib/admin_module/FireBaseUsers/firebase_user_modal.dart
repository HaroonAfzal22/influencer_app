
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
  // account setting
  String? sono = '';
  String? interssi = '';
  String? location = '';
  dynamic dateOFBirth = '';
  // notification--
  bool? messaggi = false;
  bool? attivitaAccount = false;
  bool? annunci = false;
  bool? messaggi0 = false;
  // Reccomandazioni
  bool? rMessaggi = false;
  bool? rAvvivitaAccount = false;
  String? fcmToken = '';
  bool? notificationSattus = true;

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
      this.homeView,
      // account setting
      this.sono,
      this.dateOFBirth,
      this.interssi,
      this.location,
      // notification--
      this.messaggi,
      this.annunci,
      this.attivitaAccount,
      this.messaggi0,
      this.rAvvivitaAccount,
      this.rMessaggi,
      this.fcmToken,
      this.notificationSattus});

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
    sono = data['Sono']; // acount setting
    dateOFBirth = data['DateOfBirth'];
    interssi = data['Interssi'];
    location = data['Location'];
    messaggi = data['Messaggi'];
    messaggi0 = data['Messagg0'];
    rMessaggi = data['RMessaggi'];
    annunci = data['Annunci'];
    attivitaAccount = data['AttivitaAccount'];
    rAvvivitaAccount = data['RAvvivitaAccount'];
    fcmToken = data['fcmToken'];
    notificationSattus = data['notificationSattus'];
  }
}
