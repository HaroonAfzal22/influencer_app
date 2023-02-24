import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/admin_module/contactti/model/contact_listModelClass.dart';
import 'package:influencer/routes/app_pages.dart';
import 'package:influencer/util/dimension.dart';
import 'package:influencer/util/image_const.dart';

class ContattiUserCard extends StatelessWidget {
  ContattiUserCard({
    this.lastMessage,
    this.name,
    required this.onTap,
    this.color,
    Key? key,
  }) : super(key: key);
  bool unread = false;
  String? name;
  String? lastMessage;
  VoidCallback onTap;
  Color? color;
  @override
  Widget build(BuildContext context) {
    double h = Get.size.height;
    double w = Get.size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin:
            EdgeInsets.symmetric(horizontal: w * 0.045, vertical: h * 0.014),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: color ?? Colors.white,
        ),
        // padding: EdgeInsets.symmetric(
        //   horizontal: h*0.023,
        //   vertical: h*0.015,
        // ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(2),
              decoration: unread == false
                  ? BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(h * 0.03)),
                      border: Border.all(
                        width: 2,
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
                radius: h * 0.03,
                backgroundColor: Colors.green,
                child: Image.asset(ImageConstant.dummyImage1),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.65,
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
                            name ?? 'no name',
                            style: TextStyle(
                              fontSize: Dimensions.fontSize16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          unread == true
                              ? Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  width: 7,
                                  height: 7,
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
