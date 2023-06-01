import 'package:cloud_firestore/cloud_firestore.dart';

final firebaseInstance = FirebaseFirestore.instance;
final userContacts =
    firebaseInstance.collection('users').doc('112233').collection('contacts');

abstract class FirebaseMethods {
  // add user data
  static Future<void> addUserCollection(
      {uid,
      name,
      sureName,
      email,
      phone,
      password,
      opzione1,
      opzione2,
      fcmToken}) {
    return firebaseInstance
        .collection('users')
        .doc(uid)
        .set({
          'uid': uid,
          'name': name,
          'surename': sureName,
          'email': email,
          'phone': phone,
          'password ': password,
          'photoUrl': '',
          'userRole': 'user',
          'status': 'offline',
          'lastSeen': '',
          'homeview': 'false',
          'time': Timestamp.now(),

          //  opzion

          'opzione1': opzione1,

          'opzione2': opzione2,
          // acount setting

          'Sono': '',
          'DateOfBirth': '',
          'Interssi': '',
          'Location': '',
          'Messaggi': false,
          'Messagg0': false,
          'RMessaggi': false,
          'Annunci': false,
          'AttivitaAccount': false,
          'RAvvivitaAccount': false,

          // Notifications
          'fcmToken': fcmToken ?? ''
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  // add user contacts

  static Future<void> addUserContacts(Map<String, dynamic> contacts) async {
    return userContacts
        .add({'': ''})
        .then((value) => print("contact added"))
        .catchError((error) => print("Failed to add contacts: $error"));
  }
}
