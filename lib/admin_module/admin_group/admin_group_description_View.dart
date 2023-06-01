import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:get/get.dart';
import 'package:influencer/FirebaseServices/firebase_methods.dart';
import 'package:influencer/admin_module/two_way_channel/view/widgets/admin_group_chat_controller.dart';

class GroupDescription extends StatefulWidget {
  const GroupDescription({super.key});

  @override
  State<GroupDescription> createState() => _GroupDescriptionState();
}

class _GroupDescriptionState extends State<GroupDescription> {
  final aGroupController = Get.find<AdminGroupChatController>();
  late final TextEditingController purposeController;
  ScrollController scrollController = ScrollController();
  bool emojiShowing = false;
  late final FireBaseMethods _firebaseMethods;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    _firebaseMethods = FireBaseMethods();
    purposeController =
        TextEditingController(text: aGroupController.groupDescription);
    focusNode.requestFocus();
    emojiShowing = false;

    focusNode.addListener(
      () {
        if (focusNode.hasFocus) {
          setState(() {
            emojiShowing = false;
          });
        }
      },
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    purposeController.dispose();
    focusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 10,
          leading: Container(),
          title: const Text("Group Description"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 5, left: 10, right: 10, bottom: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: detailField(context,
                        focusnode: focusNode,
                        scrollController: scrollController,
                        controller: purposeController),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          emojiShowing = !emojiShowing;
                          focusNode.unfocus();
                        });
                      },
                      icon: const Icon(Icons.emoji_emotions_outlined))
                ],
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        text: 'Cancel',
                      ),
                    ),
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: () async {
                          Map myMap = {
                            'GroupDescription': purposeController.text
                          };

                          await _firebaseMethods.updateCollection(
                              myMap, 'groupChats', aGroupController.groupId);

                          Get.back();
                        },
                        text: 'OK',
                      ),
                    )
                  ],
                ),
                Offstage(
                    offstage: !emojiShowing,
                    child: SizedBox(
                        height: 280,
                        child: EmojiPicker(
                          textEditingController: purposeController,
                          onBackspacePressed: () {},
                          config: const Config(
                            columns: 7,
                            emojiSizeMax: 32 * 1.0,
                            verticalSpacing: 0,
                            horizontalSpacing: 0,
                            gridPadding: EdgeInsets.zero,
                            initCategory: Category.RECENT,
                            bgColor: Color(0xFFF2F2F2),
                            indicatorColor: Colors.blue,
                            iconColor: Colors.grey,
                            iconColorSelected: Colors.blue,
                            backspaceColor: Colors.blue,
                            skinToneDialogBgColor: Colors.white,
                            skinToneIndicatorColor: Colors.grey,
                            enableSkinTones: true,
                            showRecentsTab: true,
                            recentsLimit: 28,
                            replaceEmojiOnLimitExceed: false,
                            noRecents: const Text(
                              'No Recents',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black26),
                              textAlign: TextAlign.center,
                            ),
                            loadingIndicator: const SizedBox.shrink(),
                            tabIndicatorAnimDuration: kTabScrollDuration,
                            categoryIcons: const CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL,
                            checkPlatformCompatibility: true,
                          ),
                        ))),
              ],
            )
          ],
        ));
  }

  Widget detailField(context,
      {required scrollController,
      required TextEditingController controller,
      required FocusNode focusnode}) {
    return Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: TextFormField(
          enableSuggestions: false,
          autocorrect: false,
          style: TextStyle(fontSize: 16),
          focusNode: focusnode,
          scrollController: scrollController,
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              focusedBorder: UnderlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: Colors.blue)),
              hintStyle:
                  TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              hintText: "Add group description"),
          minLines: 1,
          maxLines: 7,
          keyboardType: TextInputType.multiline,
          controller: controller),
    );
  }
}

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    Key? key,
    required this.onPressed,
    this.text,
    this.backGroundColor,
    this.child,
    this.side,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String? text;
  final Color? backGroundColor;
  final Widget? child;
  final BorderSide? side;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
              side: side ?? BorderSide.none,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          backgroundColor: Colors.white,
        ),
        onPressed: onPressed,
        child: child ??
            Text(text ?? '',
                style: TextStyle(fontSize: 18, color: Colors.black)));
  }
}
