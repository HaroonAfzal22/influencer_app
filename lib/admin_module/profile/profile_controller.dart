import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:influencer/FindTutorsModelClass.dart';
import 'package:influencer/Modals/user_modal.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';

class ProfileController extends GetxController {
 

  // profile picture

  var dateTime = ('00-00-000').obs;

  String puntenggio = ''.obs.toString();
  String totalFollwers = ''.obs.toString();

  //--------------

// ii imo account
  RxString photoUrl =  RxString('');


  String sono = ''.obs.toString();

  String interssi = ''.obs.toString();
   String opzione1 = 'AUTO'.obs.toString();
  String opzione2 = 'AUTO'.obs.toString();

  String location = ''.obs.toString();
  String eta = ''.obs.toString();
  String userProfileId = '';

//notification

//------
  Rx<bool> messaggi = false.obs;
  Rx<bool> attivitaAccount = false.obs;
  Rx<bool> annunci = false.obs;
  Rx<bool> raccomandazioni = false.obs;

  //---Notofiche Message

  Rx<bool> nMessaggi = false.obs;
  Rx<bool> nAttivitaAccount = false.obs;
}
