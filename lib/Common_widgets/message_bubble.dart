/*

  import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:influencer/util/dimension.dart';

import '../admin_module/two_way_channel/model/two_way_modelclass.dart';

_chatBubble(TwoWayMessage message, bool isMe, bool isSameUser) {
    if (isMe) {
      return Row(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          !isSameUser
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      width: Dimensions.padding8,
                    ),
                    Container(
                      decoration: BoxDecoration(
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
                        radius: 22.r,
                        child: Image.asset(widget.user!.imageUrl.toString()),
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
          Container(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.70,
              ),
              padding: EdgeInsets.all(Dimensions.paddingLeft10),
              margin: EdgeInsets.symmetric(vertical: Dimensions.paddingLeft10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(Dimensions.textsize15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.80,
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      return Row(
        // textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          !isSameUser
              ? Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
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
                        radius: 22.r,
                        backgroundColor: Colors.blue,
                        backgroundImage: AssetImage(ImageConstant.dummyImage3),
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
          SizedBox(
            width: Dimensions.height6,
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.70,
              ),
              padding: EdgeInsets.all(Dimensions.paddingLeft10),
              margin: EdgeInsets.symmetric(vertical: Dimensions.paddingLeft10),
              decoration: BoxDecoration(
                color: IColor.recieve_message_container_color,
                borderRadius: BorderRadius.circular(Dimensions.textsize15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
*/