import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModal {
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

  UserModal(
      {this.email,
      this.name,
      this.surename,
      this.photoUrl,
      this.uid,
      this.userRole,
      this.phone,
      this.status,
      this.time,
      this.lastSeen,
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
      this.fcmToken});

  factory UserModal.fromJson(Map<String, dynamic> json) {
    return UserModal(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      surename: json['surename'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      userRole: json['userRole'] ?? '',
      status: json['status'] ?? '',
      lastSeen: json['lastSeen'],
      time: (json['time'] as Timestamp).toDate(),
      sono: json['Sono'] ?? '', // acount setting
      dateOFBirth: json['DateOfBirth'] ?? '',
      interssi: json['Interssi'] ?? '',
      location: json['Location'] ?? '',
      messaggi: json['Messaggi'] ?? false,
      messaggi0: json['Messagg0'] ?? false,
      rMessaggi: json['RMessaggi'] ?? false,
      annunci: json['Annunci'] ?? false,
      attivitaAccount: json['AttivitaAccount'] ?? false,
      rAvvivitaAccount: json['RAvvivitaAccount'] ?? false,
      fcmToken: json['fcmToken'] ?? ''
    );
  }
}
/*
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'surename': surename,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'userRole': userRole,
      'status': status,
      'time': time,
    };
  }
*/