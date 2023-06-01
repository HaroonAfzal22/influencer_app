import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'package:influencer/util/dimension.dart';

class GroupListCardWidget extends StatelessWidget {
  GroupListCardWidget(
      {Key? key,
      required this.groupName,
      required this.message,
      required this.time,
      required this.chatNumber,
      required this.imageUrl})
      : super(key: key);
  String groupName;
  String message;
  String time;
  int chatNumber;
  String imageUrl;

  final currentUser = Get.find<CurrentUserController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.fontSize20,
        vertical: Dimensions.height2,
      ),
      child: Row(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(Dimensions.height2),
              decoration: chatNumber != 0 // chat unread
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
              child: ImageWidgetProg(imageUrl: imageUrl)),
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
                            groupName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          chatNumber != 0
                              ? CircleAvatar(
                                  radius: Dimensions.fontSize12,
                                  child: Text(chatNumber.toString()),
                                )
                              : SizedBox(),
                          SizedBox(
                            height: Dimensions.paddingLeft10,
                          ),
                          Text(
                            time,
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
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      message,
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

class ImageWidgetProg extends StatelessWidget {
  const ImageWidgetProg({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey.shade100,
      radius: Dimensions.fontSize17and5 * 2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: imageUrl == ''
            ? CircleAvatar(radius: Dimensions.fontSize17and5 * 2)
            : CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: imageUrl,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) =>
                    CircleAvatar(radius: Dimensions.fontSize17and5 * 2),
              ),
      ),
    );
  }
}
