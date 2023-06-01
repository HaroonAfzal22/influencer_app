import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:influencer/admin_module/admin_archived/model/admin_archived_modelclass.dart';
import 'package:influencer/admin_module/contactti/view/widget/admin_input_chat_view.dart';
import 'package:influencer/admin_module/two_way_channel/model/two_way_modelclass.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'package:influencer/admin_module/two_way_channel/view/widgets/admin_group_input_view.dart';
import 'package:influencer/admin_module/two_way_channel/view/widgets/group_list_card_widget.dart';
import 'package:influencer/user_view/user_input_chat_view.dart';
import 'package:influencer/util/comon_widgets.dart';
import 'package:influencer/util/dimension.dart';
import 'package:influencer/util/image_const.dart';
import 'package:intl/intl.dart';

// var chatData;

class ChatHistoryCardWidget extends StatelessWidget {
  ChatHistoryCardWidget({
    required this.messageCount,
    required this.messgae,
    required this.sender,
    required this.time,
    required this.isRead,
    this.image,
    Key? key,
  }) : super(key: key);
  String messgae;
  String sender;
  var image;
  var time;
  var messageCount;
  var isRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      color: Colors.white70,
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.fontSize20,
        vertical: Dimensions.height2,
      ),
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(Dimensions.height2),
            decoration: isRead
                ? BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(Dimensions.fontSize20 * 2)),
                    border: Border.all(
                      width: Dimensions.height2,
                      color: Theme.of(context).primaryColor,
                    ),
                    // shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  )
                : BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      ),
                    ],
                  ),
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade100,
              radius: 30.r,
              child: ImageWidgetProg(
                imageUrl: image,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: Dimensions.fontSize20,
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text(
                            sender.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          true
                              // chat.sender.isOnline!
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: Dimensions.paddingvertical5),
                                  width: Dimensions.padding_7half5,
                                  height: Dimensions.padding_7half5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              : Container(
                                  child: null,
                                ),
                        ],
                      ),
                      Column(
                        children: [
                          messageCount == 0
                              ? SizedBox()
                              : CircleAvatar(
                                  radius: Dimensions.fontSize12,
                                  child: Text(messageCount.toString()),
                                ),
                          Text(
                            time.toString(),
                            style: TextStyle(
                              fontSize: Dimensions.fontSize12,
                              fontWeight: FontWeight.w300,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.paddingLeft10,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      messgae.toString(),
                      style: TextStyle(
                        fontSize: Dimensions.fontSize12,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
