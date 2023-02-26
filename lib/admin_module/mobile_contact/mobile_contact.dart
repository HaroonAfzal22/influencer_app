import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:influencer/admin_module/two_way_channel/model/two_way_user_model.dart';
import 'package:influencer/admin_module/two_way_channel/view/widgets/admin_group_input_view.dart';
import 'package:influencer/util/LoadingWidget.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/commonText.dart';
import 'package:influencer/util/dimension.dart';
import 'package:influencer/util/image_const.dart';
import 'package:influencer/util/string.dart';
import 'dart:developer' as devtools show log;

import 'package:share_plus/share_plus.dart';

class MobileContact extends StatefulWidget {
  const MobileContact({super.key});

  @override
  State<MobileContact> createState() => _MobileContactState();
}

class _MobileContactState extends State<MobileContact> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;
  Contact? contact;
  bool istrue = false;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future _fetchContacts() async {
    if (!await FlutterContacts.requestPermission(readonly: true)) {
      setState(() => _permissionDenied = true);
    } else {
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );

      Map mapContact = contacts.asMap();
      // devtools.log('${mapContact}');

      setState(() => _contacts = contacts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading:
          //  IconButton(
          //     onPressed: () {
          //       Get.back();
          //     },
          //     icon: const Icon(
          //       Icons.arrow_back,
          //       color: IColor.colorblack,
          //     )
          //     ),
          backgroundColor: IColor.colorWhite,
          elevation: 0,
          title: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              Strings.contatti,
              style: TextStyle(color: IColor.colorblack),
            ),
          ),
        ),
        body: _body());
  }

  Widget _body() {
    if (_permissionDenied)
      return const Center(child: Text('Permission denied'));
    if (_contacts == null) return const Center(child: LoaderWidget());
    return ListView.builder(
        itemCount: _contacts!.length,
        itemBuilder: (context, i) => Padding(
            padding: REdgeInsets.all(8.0),
            child: ListTile(
                onTap: () {
                 /*
                  Get.to(AdminInputGroupView(
                    user: TwoWayUserModel(
                        id: 1,
                        imageUrl: ImageConstant.dummyImage2,
                        isOnline: true,
                        name: "qaiser"),
                  ));
                 */
                },
                leading: CircleAvatar(
                  child: Text(_contacts![i].displayName[0]),
                  radius: 25.r,
                ),
                title: Text(_contacts![i].displayName),
                subtitle: Text(
                    ' ${_contacts![i].phones.isNotEmpty ? _contacts![i].phones.first.number : '(none)'}'),
                trailing: MaterialButton(
                  onPressed: () {
                    Share.share("https://www.google.com/");
                  },
                  child: CommonText(
                      title: Strings.invita_ora, color: IColor.colorWhite),
                  color: istrue ? IColor.grey_color : IColor.mainBlueColor,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(Dimensions.fontSize16)),
                ))));
  }
}
