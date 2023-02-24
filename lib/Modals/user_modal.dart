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
      this.lastSeen});

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
        time: (json['time'] as Timestamp).toDate());
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