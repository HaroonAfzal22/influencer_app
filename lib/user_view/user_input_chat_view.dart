import 'dart:developer';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:influencer/FirebaseMessage/single_chat_history_controller.dart';
import 'package:influencer/FirebaseServices/firebase_methods.dart';
import 'package:influencer/admin_module/admin_archived/controller/admin_archived_controller.dart';
import 'package:influencer/admin_module/admin_archived/view/component/googlemap.dart';
import 'package:influencer/admin_module/admin_archived/view/widgets/audioCall.dart';
import 'package:influencer/admin_module/bottom_nav/bottom_nav.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'package:influencer/routes/app_pages.dart';
import 'package:influencer/admin_module/profile/profile.dart';
import 'package:influencer/user_view/user_chat_history_view.dart';
import 'package:influencer/util/LoadingWidget.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/commonText.dart';
import 'package:influencer/util/common_app.dart';
import 'package:influencer/util/dimension.dart';
import 'package:influencer/util/image_const.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:influencer/util/string.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class UserInputChatView extends StatefulWidget {
  UserInputChatView({
    Key? key,
  }) : super(key: key);
//  final ContacttiListAdmin? contactlist;
  @override
  State<UserInputChatView> createState() => _UserInputChatViewState();
}

class _UserInputChatViewState extends State<UserInputChatView> {
  final TextEditingController _controller = TextEditingController();
  final currentUser = Get.find<CurrentUserController>();
  final messageController = Get.find<MessageController>();
  final fireStore = FirebaseFirestore.instance;

  bool emojiShowing = false;
  final FocusNode focusNode = FocusNode();

  bool isbutton = false;
  bool isMessages = false;

  bool isRecording = false;
  late FireBaseOtherUser fireBaseOtherUser;
  var otherUserRes;
  var _stream;
  bool isLoad = false;
  getOtherUser() async {
    setState(() {
      isLoad = true;
    });

    otherUserRes = await fireBaseOtherUser.otherUser(
        otherUserId: messageController.otherUserId.toString(),
        collection: 'users');

    setState(() {
      isLoad = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fireBaseOtherUser = FireBaseOtherUser();
    // getOtherUser();
    // _initialiseControllers();
    // initRecorder();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          emojiShowing = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // _soundRecorder.closeRecorder();
    super.dispose();
    _disposeControllers();
    //recorder.closeRecorder();
  }

  // late final RecorderController recorderController;
  // late final PlayerController playerController1;

  String? path;
  String? musicFile;
  // late Directory appDirectory;

/*
  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.amr_nb
      ..androidOutputFormat = AndroidOutputFormat.three_gpp
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 15000
      ..bitRate = 64000;
    playerController1 = PlayerController()
      ..addListener(() {
        if (mounted) setState(() {});
      });
  }
*/

  void _disposeControllers() {
    // recorderController.dispose();
    // playerController1.stopAllPlayers();
  }

  bool isButton = false;

/*
  final recorder = FlutterSoundRecorder();

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Permission not granted';
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future startRecord() async {
    await recorder.startRecorder(toFile: "audio");
  }

  Future stopRecorder() async {
    final filePath = await recorder.stopRecorder();
    final file = File(filePath!);
    print('Recorded file path: $filePath');
  }
*/

  final AdminArchivedController controller =
      Get.put<AdminArchivedController>(AdminArchivedController());

  String fileType = 'All';
  FilePickerResult? result;
  PlatformFile? file;

  File? imageFile;
  Contact? _phoneContact;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (emojiShowing) {
          setState(() {
            emojiShowing = false;
          });
        } else {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: isLoad == true
              ? LoaderWidget()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // list view removed by haroon

                    ChatingAppBar(
                      avator: InkWell(
                          onTap: () {
                            Get.to(Profile());
                          },
                          child: CircleAvatar(
                            radius: Dimensions.fontSize12 * 2,
                            child: Image.asset('assets/img.jpeg'),
                          )),
                      backbtn: Icon(
                        Icons.arrow_back,
                        color: IColor.mainBlueColor,
                      ),
                      backFunction: () {
                        Get.offAll(() => BottomNavigationBarPage());
                      },
                      name: 'Admin',
                      sufix1onpress: () {
                        // Get.toNamed(Paths.voiceCall);
                        Get.to(VoiceCall());
                      },
                      sufixicon1: const Icon(
                        Icons.call,
                        color: IColor.mainBlueColor,
                      ),
                      sufix2onpress: () {
                        Get.toNamed(Paths.contattiVideoCall);
                      },
                      sufixicon2: ImageConstant.imgVideocamera,
                      sufixicon3: Icon(
                        Icons.more_vert,
                        color: IColor.mainBlueColor,
                      ),
                    ),
                    StreamBuilder(
                      stream: fireStore
                          .collection('users')
                          .doc(currentUser.currentUser?.uid.toString())
                          .collection('userChat')
                          .orderBy('time', descending: false)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          isMessages = true;
                          return Expanded(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              reverse: true,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: snapshot.data!.docs.reversed
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data() as Map<String, dynamic>;

                                DateTime dateTime = data["time"].toDate();
                                /*
                           final dateString =
                              DateFormat('yyyy-MM-dd hh:mm').format(dateTime);
                          */
                                final dateString =
                                    DateFormat(' hh:mm:ss').format(dateTime);
                                // devtools.log("Data time $dateString");
                                return MessageBubble(
                                  chatImageUrl: data['BannerImage'] ?? '',
                                  myDate: dateString,
                                  isME: data['email'] ==
                                      currentUser.currentUser?.email,
                                  userEmail: data['name'],
                                  userText: data['text'] ?? '',
                                );
                              }).toList(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          isMessages = false;
                          return Text('Something went wrong');
                        } else {
                          isMessages = false;
                        }

                        return Center(child: LoaderWidget());
                      },
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white),
                                  width: MediaQuery.of(context).size.width - 80,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 100),
                                    child: isRecording
                                        ? Row(
                                            children: [
                                              SizedBox(
                                                width: 6.w,
                                              ),
                                              StreamBuilder<
                                                  RecordingDisposition>(
                                                builder: (context, snapshot) {
                                                  final duration = snapshot
                                                          .hasData
                                                      ? snapshot.data!.duration
                                                      : Duration.zero;

                                                  String twoDigits(int n) => n
                                                      .toString()
                                                      .padLeft(2, '0');

                                                  final twoDigitMinutes =
                                                      twoDigits(duration
                                                          .inMinutes
                                                          .remainder(60));
                                                  final twoDigitSeconds =
                                                      twoDigits(duration
                                                          .inSeconds
                                                          .remainder(60));

                                                  return Text(
                                                    '$twoDigitMinutes:$twoDigitSeconds',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  );
                                                },
                                                // stream: recorder.onProgress,
                                              ),
                                              /*
                                              AudioWaveforms(
                                                enableGesture: true,
                                                size: Size(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2,
                                                    50),
                                                recorderController:
                                                    recorderController,
                                                waveStyle: const WaveStyle(
                                                    waveColor: Colors.black,
                                                    extendWaveform: true,
                                                    showMiddleLine: false,
                                                    showHourInDuration: true),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  // color: const Color(0xFF1E1B26),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 18.w),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 15.w),
                                              ),
                                          */
                                            ],
                                          )
                                        : TextFormField(
                                            onChanged: (value) {
                                              if (value.length > 0) {
                                                setState(() {
                                                  isbutton = true;
                                                });
                                              } else {
                                                setState(() {
                                                  isbutton = false;
                                                });
                                              }
                                            },
                                            controller: _controller,
                                            focusNode: focusNode,
                                            keyboardType:
                                                TextInputType.multiline,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        context: context,
                                                        builder: (builder) =>
                                                            bottomsheet());
                                                  },
                                                  icon: Icon(Icons.attachment)),
                                              contentPadding: EdgeInsets.all(5),
                                              hintText: Strings
                                                  .chating_search_hinttext,
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              alignLabelWithHint: true,
                                              border: InputBorder.none,
                                              prefixIcon: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      focusNode.unfocus();
                                                      focusNode
                                                              .canRequestFocus =
                                                          false;
                                                      emojiShowing =
                                                          !emojiShowing;
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.emoji_emotions,
                                                  )),
                                            ),
                                          ),
                                  )),
                              const SizedBox(
                                width: 12,
                              ),
                              /*
                              isbutton
                                  ?
                            */
                              InkWell(
                                onTap: () async {
                                  // add new collection-------------------------------------------------
                                  if (_controller.text.isNotEmpty) {
                                    fireStore
                                        .collection('users')
                                        .doc(currentUser.currentUser?.uid
                                            .toString()
                                            .toString())
                                        .collection('userChat')
                                        .add({
                                      'id': messageController.otherUserId
                                          .toString(),
                                      'name': currentUser.currentUser!.name
                                          .toString(),
                                      'email': currentUser.currentUser!.email
                                          .toString(),
                                      'text': _controller.text,
                                      'photo': 'CurrentUserPhoto',
                                      'time': Timestamp.now(),
                                    });
                                    // counter
                                    var messageCount = 1;

                                    var recentChat =
                                        await fireBaseOtherUser.otherUser(
                                            otherUserId: currentUser
                                                .currentUser?.uid
                                                .toString(),
                                            collection: 'recentChats');
                                    log('this is chat message ${recentChat.data()['isAdminRead']}');

                                    ///////

                                    if (recentChat.data() != null) {
                                      if (recentChat.data()?['isAdminRead'] ==
                                          false) {
                                        messageCount = recentChat
                                            .data()?['adminMessageCount'];
                                        messageCount = messageCount + 1;
                                      }
                                    }

                                    log('current user id ${currentUser.currentUser?.uid}');
                                    //         .toString())
                                    //recent chat of user

                                    fireStore
                                        .collection('recentChats')
                                        .doc(currentUser.currentUser?.uid
                                            .toString())
                                        .set({
                                      'curentUid': messageController.adminUserID
                                          .toString(),
                                      'otherUid': currentUser.currentUser?.uid
                                          .toString(),
                                      'adminMessageCount': messageCount,
                                      'isAdminRead': false,
                                      'lastMessage': _controller.text,
                                      'otherName': currentUser.currentUser?.name
                                          .toString(),
                                      'photoUrl': 'photoUrl',
                                      'userMessageCount': 0,
                                      'isUserRead': false,
                                      'time': Timestamp.now()
                                    });

                                    _controller.clear();
                                  }
                                },
                                child: const CircleAvatar(
                                  radius: 25,
                                  child: Icon(Icons.send),
                                ),
                              )
                              /*
                                  : InkWell(
                                      // onTap: _startOrStopRecording,
                                      child: CircleAvatar(
                                        radius: 22.r,
                                        child: isRecording
                                            ? Icon(Icons.send)
                                            : Icon(
                                                Icons.mic,
                                              ),
                                      ),
                                    )
                              */
                            ],
                          ),
                        ),
                        emojiPicker(),
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }

  /*
  void _startOrStopRecording() async {
    if (recorder.isRecording) {
      await stopRecorder();
      setState(() {});
    } else {
      await startRecord();
      setState(() {});
    }
    if (isRecording) {
      recorderController.reset();
      await stopRecorder();
      setState(() {});
      if (path != null) {}
    } else {
      await recorderController.record(path);
    }
    setState(() {
      isRecording = !isRecording;
    });
  }
 */

/*
  void _refreshWave() {
    if (isRecording) recorderController.refresh();
  }
*/

  Widget bottomsheet() {
    return Container(
      height: 240.h,
      child: Card(
        margin: EdgeInsets.all(18.sp),

        // height: 278,
        // width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                iconCreation('Document', Icons.insert_drive_file_rounded,
                    Colors.purple.shade700, () async {
                  result = await FilePicker.platform.pickFiles();
                  if (result == null) return;
                  file = result!.files.first;
                  setState(() {
                    Fluttertoast.showToast(
                        msg: 'Document Picked', toastLength: Toast.LENGTH_LONG);
                  });
                  Get.back();
                }),
                iconCreation('Camera', Icons.camera_alt, Colors.redAccent, () {
                  controller.getImage(ImageSource.camera);

                  Get.back();
                  Fluttertoast.showToast(
                      msg: 'Camera Picked', toastLength: Toast.LENGTH_LONG);
                }),
                iconCreation('Gallery', Icons.insert_photo_sharp,
                    Colors.pinkAccent.shade400, () async {
                  // _getFromGallery();
                  result =
                      await FilePicker.platform.pickFiles(type: FileType.image);
                  if (result == null) return;
                  file = result!.files.first;
                  setState(() {
                    Fluttertoast.showToast(
                        msg: 'Gallery Picked', toastLength: Toast.LENGTH_LONG);
                  });

                  Get.back();
                }),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  iconCreation(
                      'Audio', Icons.headphones, Colors.orange.shade700,
                      () async {
                    result = await FilePicker.platform
                        .pickFiles(type: FileType.audio);
                    if (result == null) return;
                    file = result!.files.first;
                    setState(() {
                      Fluttertoast.showToast(
                          msg: 'Audio Picked', toastLength: Toast.LENGTH_LONG);
                    });
                    Get.back();
                  }),
                  iconCreation('Location', Icons.location_pin,
                      Colors.greenAccent.shade700, () {
                    Get.to(CurrentUserLocation());
                    // Get.back();
                  }),
                  iconCreation('Contact', Icons.person, Colors.blue, () async {
                    final PhoneContact contact =
                        await FlutterContactPicker.pickPhoneContact();

                    Fluttertoast.showToast(
                        msg: 'Contact Picked', toastLength: Toast.LENGTH_LONG);
                    print(contact);
                    setState(() {
                      _phoneContact = contact;
                    });
                    Get.back();
                    //  Get.toNamed(Paths.numberPicker);
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget iconCreation(
      String name, IconData icon, Color color, Function() onress) {
    return GestureDetector(
      onTap: onress,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
            ),
            radius: 28,
          ),
          SizedBox(
            height: 10,
          ),
          Text(name)
        ],
      ),
    );
  }

  Widget emojiPicker() {
    return Offstage(
      offstage: !emojiShowing,
      child: SizedBox(
          height: 250.h,
          child: EmojiPicker(
            textEditingController: _controller,
            config: Config(
              columns: 7,
              // Issue: https://github.com/flutter/flutter/issues/28894
              emojiSizeMax: 32 *
                  (foundation.defaultTargetPlatform == TargetPlatform.android
                      ? 1.30
                      : 1.0),
              verticalSpacing: 0,
              horizontalSpacing: 0,
              gridPadding: EdgeInsets.zero,
              // initCategory: Category.RECENT,
              bgColor: const Color(0xFFF2F2F2),
              indicatorColor: Colors.blue,
              iconColor: Colors.grey,
              iconColorSelected: Colors.blue,
              backspaceColor: Colors.blue,

              skinToneDialogBgColor: Colors.white,
              skinToneIndicatorColor: Colors.grey,
              enableSkinTones: true,
              showRecentsTab: false,

              tabIndicatorAnimDuration: kTabScrollDuration,
              categoryIcons: const CategoryIcons(),
              buttonMode: ButtonMode.MATERIAL,
              checkPlatformCompatibility: true,
            ),
          )),
    );
  }
}
/*
 ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                ChatingAppBar(
                  avator: InkWell(
                      onTap: () {
                        Get.to(Profile());
                      },
                      child: CircleAvatar(
                        radius: Dimensions.fontSize12 * 2,
                        child: Image.asset('assets/img.jpeg'),
                      )),
                  backbtn: Icon(
                    Icons.arrow_back,
                    color: IColor.mainBlueColor,
                  ),
                  backFunction: () {
                    Get.to(BottomNavigationBarPage());
                  },
                  name: Strings.influencers,
                  sufix1onpress: () {
                    // Get.toNamed(Paths.voiceCall);
                    Get.to(VoiceCall());
                  },
                  sufixicon1: const Icon(
                    Icons.call,
                    color: IColor.mainBlueColor,
                  ),
                  sufix2onpress: () {
                    Get.toNamed(Paths.contattiVideoCall);
                  },
                  sufixicon2: ImageConstant.imgVideocamera,
                  sufixicon3: Icon(
                    Icons.more_vert,
                    color: IColor.mainBlueColor,
                  ),
                ),
                Container(
                  height: Get.size.height,
                  width: double.infinity,
                  child: Column(
                    children: [
                      CommonText(
                        title: Strings.oggi,
                        color: IColor.grey_color,
                        size: Dimensions.fontSize12,
                      ),
                      Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: Dimensions.sizedboxWidth8,
                          ),
                          CircleAvatar(
                            child: Image.asset('assets/img.jpeg'),
                          ),
                          SizedBox(
                            width: Dimensions.sizedboxWidth8,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: IColor.mainBlueColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          Dimensions.fontSize14),
                                      bottomLeft: Radius.circular(
                                          Dimensions.fontSize14),
                                      bottomRight: Radius.circular(
                                          Dimensions.fontSize14))),
                              width: Dimensions.width250,
                              height: Dimensions.height200,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.height6),
                                    child: CommonText(
                                      title:
                                          'orem Ipsum is simply dummy text of the printing',
                                      color: IColor.colorWhite,
                                      size: Dimensions.fontSize12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dimensions.padding8,
                                  ),
                                  Image.asset(
                                    'assets/images/perking.png',
                                    width: Dimensions.height265,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.height6,
                                        vertical: Dimensions.padding8),
                                    child: Align(
                                        alignment: Alignment.topRight,
                                        child: CommonText(
                                          title: '12:20 am',
                                          color: IColor.colorWhite,
                                          size: Dimensions.fontSize12,
                                        )),
                                  ),
                                ],
                              ))
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(right: Dimensions.fontSize25 * 2),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: CommonText(
                              title: 'seen',
                              color: IColor.grey_color,
                              size: Dimensions.fontSize12,
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
*/
/// chat module of ready
/*
    StreamBuilder(
                stream: fireStore
                    .collection('users')
                    .doc(widget.userId)
                    .collection('UsersChat')
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        reverse: true,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: snapshot.data!.docs.reversed
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;

                          DateTime dateTime = data["time"].toDate();
                          final dateString =
                              DateFormat('yyyy-MM-dd hh:mm').format(dateTime);
                          devtools.log("Data time $dateString");
                          return Text(data['text']);
                          // MessageBubble(
                          //   chatImageUrl: data['BannerImage'] ?? '',
                          //   myDate:dateString,
                          //   isME:" loggedinUser.email == data['sender']",
                          //   userEmail: data['sender'],
                          //   userText: data['text'] ?? '',
                          // );
                        }).toList(),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  return Text("Loading");
                },
              ),
*/

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {required this.userEmail,
      this.userText,
      required this.isME,
      required this.myDate,
      this.chatImageUrl});
  String myDate;
  var userText;
  String userEmail;
  bool isME;
  var chatImageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isME ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            userEmail,
          ),
          //------------------------------------
          if (chatImageUrl == '') ...[
            Material(
              borderRadius: isME
                  ? BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    )
                  : BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
              elevation: 5,
              color: isME ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  userText,
                  style: TextStyle(
                      color: isME ? Colors.white : Colors.black54,
                      fontSize: 15),
                ),
              ),
            ),
          ] else if (userText == '') ...[
            GestureDetector(
              onTap: () {
                print('Button pressed');
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        width: 300,
                        height: 300,
                        // child: CachedNetworkImage(
                        //   fit: BoxFit.cover,
                        //   imageUrl: chatImageUrl,
                        //   placeholder: (context, url) =>
                        //   const Center(child: CircularProgressIndicator()),
                        //   errorWidget: (context, url, error) =>
                        //   const Icon(Icons.error),
                        // ),
                      );
                    });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.blueAccent, width: 3),
                ),
                height: 300,
                width: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  // child: CachedNetworkImage(
                  //   fit: BoxFit.cover,
                  //   imageUrl: chatImageUrl,
                  //   placeholder: (context, url) =>
                  //   const Center(child: CircularProgressIndicator()),
                  //   errorWidget: (context, url, error) =>
                  //   const Icon(Icons.error),
                  // ),
                ),
              ),
            ),
          ],
//---------------------------------------

          Text(myDate)
        ],
      ),
    );
  }
}
/*
import 'dart:developer' as devtools show log;
import 'dart:developer';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:influencer/FirebaseMessage/single_chat_history_controller.dart';
import 'package:influencer/admin_module/FireBaseUsers/firebase_user_controller.dart';
import 'package:influencer/admin_module/admin_archived/controller/admin_archived_controller.dart';
import 'package:influencer/admin_module/admin_archived/view/component/googlemap.dart';
import 'package:influencer/admin_module/admin_archived/view/widgets/audioCall.dart';
import 'package:influencer/admin_module/bottom_nav/bottom_nav.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'package:influencer/routes/app_pages.dart';
import 'package:influencer/admin_module/profile/profile.dart';
import 'package:influencer/util/LoadingWidget.dart';
import 'package:influencer/util/color.dart';
import 'package:influencer/util/commonText.dart';
import 'package:influencer/util/common_app.dart';
import 'package:influencer/util/dimension.dart';
import 'package:influencer/util/image_const.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:influencer/util/string.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../FirebaseServices/firebase_methods.dart';

class AdminInputChatView extends StatefulWidget {
  AdminInputChatView({
    Key? key,
  }) : super(key: key);

//  final ContacttiListAdmin? contactlist;
  @override
  State<AdminInputChatView> createState() => _AdminInputChatViewState();
}

class _AdminInputChatViewState extends State<AdminInputChatView> {
  final TextEditingController _controller = TextEditingController();
  final currentUser = Get.find<CurrentUserController>();
  final messageController = Get.find<MessageController>();
  final fireStore = FirebaseFirestore.instance;

  bool emojiShowing = false;
  final FocusNode focusNode = FocusNode();

  bool isbutton = false;

  bool isRecording = false;
  late FireBaseOtherUser fireBaseOtherUser;
  var otherUserRes;
  var _stream;
  bool isLoad = false;
  getOtherUser() async {
    setState(() {
      isLoad = true;
    });
    fireBaseOtherUser = FireBaseOtherUser();
    otherUserRes = await fireBaseOtherUser.otherUser(
        otherUserId: messageController.otherUserId.toString(),
        collection: 'users');
    _stream = fireStore
        .collection('users')
        .doc(messageController.otherUserId.toString())
        .collection('userChat')
        .orderBy('time', descending: false)
        .snapshots();

    setState(() {
      isLoad = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getOtherUser();
    // _initialiseControllers();
    // initRecorder();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          emojiShowing = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // _soundRecorder.closeRecorder();
    super.dispose();
    _disposeControllers();
    //recorder.closeRecorder();
  }

  // late final RecorderController recorderController;
  // late final PlayerController playerController1;

  String? path;
  String? musicFile;
  // late Directory appDirectory;

/*
  void _initialiseControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.amr_nb
      ..androidOutputFormat = AndroidOutputFormat.three_gpp
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 15000
      ..bitRate = 64000;
    playerController1 = PlayerController()
      ..addListener(() {
        if (mounted) setState(() {});
      });
  }
*/

  void _disposeControllers() {
    // recorderController.dispose();
    // playerController1.stopAllPlayers();
  }

  bool isButton = false;

/*
  final recorder = FlutterSoundRecorder();

  Future initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw 'Permission not granted';
    }
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future startRecord() async {
    await recorder.startRecorder(toFile: "audio");
  }

  Future stopRecorder() async {
    final filePath = await recorder.stopRecorder();
    final file = File(filePath!);
    print('Recorded file path: $filePath');
  }
*/

  final AdminArchivedController controller =
      Get.put<AdminArchivedController>(AdminArchivedController());

  String fileType = 'All';
  FilePickerResult? result;
  PlatformFile? file;

  File? imageFile;
  Contact? _phoneContact;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (emojiShowing) {
          setState(() {
            emojiShowing = false;
          });
        } else {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: isLoad == true
              ? LoaderWidget()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // list view removed by haroon

                    ChatingAppBar(
                      avator: InkWell(
                          onTap: () {
                            Get.to(Profile());
                          },
                          child: CircleAvatar(
                            radius: Dimensions.fontSize12 * 2,
                            child: Image.asset('assets/img.jpeg'),
                          )),
                      backbtn: Icon(
                        Icons.arrow_back,
                        color: IColor.mainBlueColor,
                      ),
                      backFunction: () {
                        Get.offAll(() => BottomNavigationBarPage());
                      },
                      name: otherUserRes.data()['name'].toString(),
                      sufix1onpress: () {
                        // Get.toNamed(Paths.voiceCall);
                        Get.to(VoiceCall());
                      },
                      sufixicon1: const Icon(
                        Icons.call,
                        color: IColor.mainBlueColor,
                      ),
                      sufix2onpress: () {
                        Get.toNamed(Paths.contattiVideoCall);
                      },
                      sufixicon2: ImageConstant.imgVideocamera,
                      sufixicon3: Icon(
                        Icons.more_vert,
                        color: IColor.mainBlueColor,
                      ),
                    ),
                    StreamBuilder(
                      stream: _stream,
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              reverse: true,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: snapshot.data!.docs.reversed
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data() as Map<String, dynamic>;

                                DateTime dateTime = data["time"].toDate();
                                /*
                           final dateString =
                              DateFormat('yyyy-MM-dd hh:mm').format(dateTime);
                          */
                                final dateString =
                                    DateFormat(' hh:mm:ss').format(dateTime);
                                // devtools.log("Data time $dateString");
                                return MessageBubble(
                                  chatImageUrl: data['BannerImage'] ?? '',
                                  myDate: dateString,
                                  isME: false,
                                  userEmail: data['name'],
                                  userText: data['text'] ?? '',
                                );
                              }).toList(),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text('Something went wrong');
                        }

                        return Center(child: LoaderWidget());
                      },
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white),
                                  width: MediaQuery.of(context).size.width - 80,
                                  child: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 100),
                                    child: isRecording
                                        ? Row(
                                            children: [
                                              SizedBox(
                                                width: 6.w,
                                              ),
                                              StreamBuilder<
                                                  RecordingDisposition>(
                                                builder: (context, snapshot) {
                                                  final duration = snapshot
                                                          .hasData
                                                      ? snapshot.data!.duration
                                                      : Duration.zero;

                                                  String twoDigits(int n) => n
                                                      .toString()
                                                      .padLeft(2, '0');

                                                  final twoDigitMinutes =
                                                      twoDigits(duration
                                                          .inMinutes
                                                          .remainder(60));
                                                  final twoDigitSeconds =
                                                      twoDigits(duration
                                                          .inSeconds
                                                          .remainder(60));

                                                  return Text(
                                                    '$twoDigitMinutes:$twoDigitSeconds',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  );
                                                },
                                                // stream: recorder.onProgress,
                                              ),
                                              /*
                                              AudioWaveforms(
                                                enableGesture: true,
                                                size: Size(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2,
                                                    50),
                                                recorderController:
                                                    recorderController,
                                                waveStyle: const WaveStyle(
                                                    waveColor: Colors.black,
                                                    extendWaveform: true,
                                                    showMiddleLine: false,
                                                    showHourInDuration: true),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  // color: const Color(0xFF1E1B26),
                                                ),
                                                padding:
                                                    EdgeInsets.only(left: 18.w),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 15.w),
                                              ),
                                          */
                                            ],
                                          )
                                        : TextFormField(
                                            onChanged: (value) {
                                              if (value.length > 0) {
                                                setState(() {
                                                  isbutton = true;
                                                });
                                              } else {
                                                setState(() {
                                                  isbutton = false;
                                                });
                                              }
                                            },
                                            controller: _controller,
                                            focusNode: focusNode,
                                            keyboardType:
                                                TextInputType.multiline,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            decoration: InputDecoration(
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        context: context,
                                                        builder: (builder) =>
                                                            bottomsheet());
                                                  },
                                                  icon: Icon(Icons.attachment)),
                                              contentPadding: EdgeInsets.all(5),
                                              hintText: Strings
                                                  .chating_search_hinttext,
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              alignLabelWithHint: true,
                                              border: InputBorder.none,
                                              prefixIcon: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      focusNode.unfocus();
                                                      focusNode
                                                              .canRequestFocus =
                                                          false;
                                                      emojiShowing =
                                                          !emojiShowing;
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.emoji_emotions,
                                                  )),
                                            ),
                                          ),
                                  )),
                              const SizedBox(
                                width: 12,
                              ),
                              isbutton
                                  ? InkWell(
                                      onTap: () async {
                                        // add new collection
                                        fireStore
                                            .collection('users')
                                            .doc(messageController.otherUserId
                                                .toString())
                                            .collection('userChat')
                                            .add({
                                          'id': messageController.otherUserId
                                              .toString(),
                                          'name': currentUser.currentUser!.name
                                              .toString(),
                                          'email': currentUser
                                              .currentUser!.email
                                              .toString(),
                                          'text': _controller.text,
                                          'photo': 'CurrentUserPhoto',
                                          'time': Timestamp.now(),
                                        });
                                        // counter

                                        var recentChat =
                                            await fireBaseOtherUser.otherUser(
                                                otherUserId: messageController
                                                    .otherUserId
                                                    .toString(),
                                                collection: 'recentChats');

                                        await fireStore
                                            .collection('recentChats')
                                            .doc(messageController.otherUserId
                                                .toString())
                                            .get();

                                        var messageCount = 1;
                                        if (recentChat.data() != null) {
                                          // if (recentChat
                                          //         .data()?['isUserRead'] ==
                                          //     false) {
                                          messageCount = recentChat
                                              .data()?['userMessageCount'];
                                          messageCount = messageCount + 1;
                                          // }
                                        }

                                        //recent chat of user
                                        fireStore
                                            .collection('recentChats')
                                            .doc(messageController.otherUserId
                                                .toString())
                                            .update({
                                          // 'curentUid': currentUser
                                          //     .currentUser?.uid
                                          //     .toString(),
                                          // 'otherUid': messageController
                                          //     .otherUserId
                                          //     .toString(),
                                          'adminMessageCount': messageCount,
                                          'isAdminRead': false,
                                          'lastMessage': _controller.text,
                                          // 'otherName': otherUserRes
                                          //     .data()['name']
                                          //     .toString(),
                                          // 'photoUrl': 'photoUrl',
                                          // 'userMessageCount': 0,
                                          // 'isUserRead': false,
                                          'time': Timestamp.now()
                                        });
                                        _controller.clear();
                                      },
                                      child: const CircleAvatar(
                                        radius: 25,
                                        child: Icon(Icons.send),
                                      ),
                                    )
                                  : InkWell(
                                      // onTap: _startOrStopRecording,
                                      child: CircleAvatar(
                                        radius: 22.r,
                                        child: isRecording
                                            ? Icon(Icons.send)
                                            : Icon(
                                                Icons.mic,
                                              ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                        emojiPicker(),
                      ],
                    )
                  ],
                ),
        ),
      ),
    );
  }

  /*
  void _startOrStopRecording() async {
    if (recorder.isRecording) {
      await stopRecorder();
      setState(() {});
    } else {
      await startRecord();
      setState(() {});
    }
    if (isRecording) {
      recorderController.reset();
      await stopRecorder();
      setState(() {});
      if (path != null) {}
    } else {
      await recorderController.record(path);
    }
    setState(() {
      isRecording = !isRecording;
    });
  }
 */

/*
  void _refreshWave() {
    if (isRecording) recorderController.refresh();
  }
*/

  Widget bottomsheet() {
    return Container(
      height: 240.h,
      child: Card(
        margin: EdgeInsets.all(18.sp),

        // height: 278,
        // width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                iconCreation('Document', Icons.insert_drive_file_rounded,
                    Colors.purple.shade700, () async {
                  result = await FilePicker.platform.pickFiles();
                  if (result == null) return;
                  file = result!.files.first;
                  setState(() {
                    Fluttertoast.showToast(
                        msg: 'Document Picked', toastLength: Toast.LENGTH_LONG);
                  });
                  Get.back();
                }),
                iconCreation('Camera', Icons.camera_alt, Colors.redAccent, () {
                  controller.getImage(ImageSource.camera);

                  Get.back();
                  Fluttertoast.showToast(
                      msg: 'Camera Picked', toastLength: Toast.LENGTH_LONG);
                }),
                iconCreation('Gallery', Icons.insert_photo_sharp,
                    Colors.pinkAccent.shade400, () async {
                  // _getFromGallery();
                  result =
                      await FilePicker.platform.pickFiles(type: FileType.image);
                  if (result == null) return;
                  file = result!.files.first;
                  setState(() {
                    Fluttertoast.showToast(
                        msg: 'Gallery Picked', toastLength: Toast.LENGTH_LONG);
                  });

                  Get.back();
                }),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  iconCreation(
                      'Audio', Icons.headphones, Colors.orange.shade700,
                      () async {
                    result = await FilePicker.platform
                        .pickFiles(type: FileType.audio);
                    if (result == null) return;
                    file = result!.files.first;
                    setState(() {
                      Fluttertoast.showToast(
                          msg: 'Audio Picked', toastLength: Toast.LENGTH_LONG);
                    });
                    Get.back();
                  }),
                  iconCreation('Location', Icons.location_pin,
                      Colors.greenAccent.shade700, () {
                    Get.to(CurrentUserLocation());
                    // Get.back();
                  }),
                  iconCreation('Contact', Icons.person, Colors.blue, () async {
                    final PhoneContact contact =
                        await FlutterContactPicker.pickPhoneContact();

                    Fluttertoast.showToast(
                        msg: 'Contact Picked', toastLength: Toast.LENGTH_LONG);
                    print(contact);
                    setState(() {
                      _phoneContact = contact;
                    });
                    Get.back();
                    //  Get.toNamed(Paths.numberPicker);
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget iconCreation(
      String name, IconData icon, Color color, Function() onress) {
    return GestureDetector(
      onTap: onress,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: color,
            child: Icon(
              icon,
              color: Colors.white,
            ),
            radius: 28,
          ),
          SizedBox(
            height: 10,
          ),
          Text(name)
        ],
      ),
    );
  }

  Widget emojiPicker() {
    return Offstage(
      offstage: !emojiShowing,
      child: SizedBox(
          height: 250.h,
          child: EmojiPicker(
            textEditingController: _controller,
            config: Config(
              columns: 7,
              // Issue: https://github.com/flutter/flutter/issues/28894
              emojiSizeMax: 32 *
                  (foundation.defaultTargetPlatform == TargetPlatform.android
                      ? 1.30
                      : 1.0),
              verticalSpacing: 0,
              horizontalSpacing: 0,
              gridPadding: EdgeInsets.zero,
              // initCategory: Category.RECENT,
              bgColor: const Color(0xFFF2F2F2),
              indicatorColor: Colors.blue,
              iconColor: Colors.grey,
              iconColorSelected: Colors.blue,
              backspaceColor: Colors.blue,

              skinToneDialogBgColor: Colors.white,
              skinToneIndicatorColor: Colors.grey,
              enableSkinTones: true,
              showRecentsTab: false,

              tabIndicatorAnimDuration: kTabScrollDuration,
              categoryIcons: const CategoryIcons(),
              buttonMode: ButtonMode.MATERIAL,
              checkPlatformCompatibility: true,
            ),
          )),
    );
  }
}
/*
 ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                ChatingAppBar(
                  avator: InkWell(
                      onTap: () {
                        Get.to(Profile());
                      },
                      child: CircleAvatar(
                        radius: Dimensions.fontSize12 * 2,
                        child: Image.asset('assets/img.jpeg'),
                      )),
                  backbtn: Icon(
                    Icons.arrow_back,
                    color: IColor.mainBlueColor,
                  ),
                  backFunction: () {
                    Get.to(BottomNavigationBarPage());
                  },
                  name: Strings.influencers,
                  sufix1onpress: () {
                    // Get.toNamed(Paths.voiceCall);
                    Get.to(VoiceCall());
                  },
                  sufixicon1: const Icon(
                    Icons.call,
                    color: IColor.mainBlueColor,
                  ),
                  sufix2onpress: () {
                    Get.toNamed(Paths.contattiVideoCall);
                  },
                  sufixicon2: ImageConstant.imgVideocamera,
                  sufixicon3: Icon(
                    Icons.more_vert,
                    color: IColor.mainBlueColor,
                  ),
                ),
                Container(
                  height: Get.size.height,
                  width: double.infinity,
                  child: Column(
                    children: [
                      CommonText(
                        title: Strings.oggi,
                        color: IColor.grey_color,
                        size: Dimensions.fontSize12,
                      ),
                      Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: Dimensions.sizedboxWidth8,
                          ),
                          CircleAvatar(
                            child: Image.asset('assets/img.jpeg'),
                          ),
                          SizedBox(
                            width: Dimensions.sizedboxWidth8,
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  color: IColor.mainBlueColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(
                                          Dimensions.fontSize14),
                                      bottomLeft: Radius.circular(
                                          Dimensions.fontSize14),
                                      bottomRight: Radius.circular(
                                          Dimensions.fontSize14))),
                              width: Dimensions.width250,
                              height: Dimensions.height200,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.height6),
                                    child: CommonText(
                                      title:
                                          'orem Ipsum is simply dummy text of the printing',
                                      color: IColor.colorWhite,
                                      size: Dimensions.fontSize12,
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dimensions.padding8,
                                  ),
                                  Image.asset(
                                    'assets/images/perking.png',
                                    width: Dimensions.height265,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.height6,
                                        vertical: Dimensions.padding8),
                                    child: Align(
                                        alignment: Alignment.topRight,
                                        child: CommonText(
                                          title: '12:20 am',
                                          color: IColor.colorWhite,
                                          size: Dimensions.fontSize12,
                                        )),
                                  ),
                                ],
                              ))
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(right: Dimensions.fontSize25 * 2),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: CommonText(
                              title: 'seen',
                              color: IColor.grey_color,
                              size: Dimensions.fontSize12,
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
*/
/// chat module of ready
/*
    StreamBuilder(
                stream: fireStore
                    .collection('users')
                    .doc(widget.userId)
                    .collection('UsersChat')
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        reverse: true,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: snapshot.data!.docs.reversed
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;

                          DateTime dateTime = data["time"].toDate();
                          final dateString =
                              DateFormat('yyyy-MM-dd hh:mm').format(dateTime);
                          devtools.log("Data time $dateString");
                          return Text(data['text']);
                          // MessageBubble(
                          //   chatImageUrl: data['BannerImage'] ?? '',
                          //   myDate:dateString,
                          //   isME:" loggedinUser.email == data['sender']",
                          //   userEmail: data['sender'],
                          //   userText: data['text'] ?? '',
                          // );
                        }).toList(),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  return Text("Loading");
                },
              ),
*/

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {required this.userEmail,
      this.userText,
      required this.isME,
      required this.myDate,
      this.chatImageUrl});
  String myDate;
  var userText;
  String userEmail;
  bool isME;
  var chatImageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isME ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            userEmail,
          ),
          //------------------------------------
          if (chatImageUrl == '') ...[
            Material(
              borderRadius: isME
                  ? BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    )
                  : BorderRadius.only(
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
              elevation: 5,
              color: isME ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  userText,
                  style: TextStyle(
                      color: isME ? Colors.white : Colors.black54,
                      fontSize: 15),
                ),
              ),
            ),
          ] else if (userText == '') ...[
            GestureDetector(
              onTap: () {
                print('Button pressed');
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        width: 300,
                        height: 300,
                        // child: CachedNetworkImage(
                        //   fit: BoxFit.cover,
                        //   imageUrl: chatImageUrl,
                        //   placeholder: (context, url) =>
                        //   const Center(child: CircularProgressIndicator()),
                        //   errorWidget: (context, url, error) =>
                        //   const Icon(Icons.error),
                        // ),
                      );
                    });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.blueAccent, width: 3),
                ),
                height: 300,
                width: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  // child: CachedNetworkImage(
                  //   fit: BoxFit.cover,
                  //   imageUrl: chatImageUrl,
                  //   placeholder: (context, url) =>
                  //   const Center(child: CircularProgressIndicator()),
                  //   errorWidget: (context, url, error) =>
                  //   const Icon(Icons.error),
                  // ),
                ),
              ),
            ),
          ],
//---------------------------------------

          Text(myDate)
        ],
      ),
    );
  }
}

*/