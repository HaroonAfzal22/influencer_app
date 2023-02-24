import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/UserCannali/admin_canali_view.dart.dart';
import 'package:influencer/admin_module/bottom_nav/bottom_nav_layout.dart';
import 'package:influencer/admin_module/mobile_contact/mobile_contact.dart';
import 'package:influencer/admin_module/profile/profile.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'package:influencer/admin_module/two_way_channel/view/two_way_admin_channel.dart';
import 'package:influencer/user_view/user_canali_view.dart';
import 'package:influencer/user_view/user_chat_history_view.dart';


class BottomNavigationBarPage extends StatefulWidget {
  int? uid;
  BottomNavigationBarPage({this.uid});
  @override
  State<BottomNavigationBarPage> createState() =>
      _BottomNavigationBarPageState();
}

class _BottomNavigationBarPageState extends State<BottomNavigationBarPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final controller = Get.find<CurrentUserController>();
  int currentIndex = 0;

  String text = '0';
  bool select = true;
  final _bottomnavigationGlobalkey = GlobalKey();

  final PageStorageBucket bucket = PageStorageBucket();

  List<Widget> userViews = <Widget>[
    // TwoWayUserChannel(),
    UserChatView(),
    UserCanaliView(),
    const MobileContact(),
    Profile(),
  ];

  static List<Widget> adminViews = <Widget>[
    TwoWayUserChannel(),
    AdminCanaliView(),
    const MobileContact(),

    // ContactList(),
    //  const MobileContact(),
    Profile(),
    // Profile(),
    // ContactListAdminStartChannel(),
    // User_Setting()

    // FavScreen(),
  ];

  // Widget currenScreen = TwoWayUserChannel();

  void _onItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return controller.currentUser?.userRole == 'user'
        ? Scaffold(
            // appBar: appBar(),

            bottomNavigationBar: TabBarMaterialWidgets(
              index: currentIndex,
              onChangedTab: onChangeTab,
            ),
            body: userViews[currentIndex])
        : Scaffold(
            bottomNavigationBar: TabBarMaterialWidgets(
              index: currentIndex,
              onChangedTab: onChangeTab,
            ),
            body: adminViews[currentIndex],
          );
  }

  void onChangeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  bool isSelect = false;
  bool selected = true;
  String code = 'USD';
}
