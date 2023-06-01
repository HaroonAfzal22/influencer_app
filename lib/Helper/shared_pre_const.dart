

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  String userId ='';
  String? userPrefId;
 late SharedPreferences sharedPreferences;

  getSharedData() async {
 sharedPreferences = await SharedPreferences.getInstance();
    userPrefId = sharedPreferences.getString(userId.toString());
  
  }
}
