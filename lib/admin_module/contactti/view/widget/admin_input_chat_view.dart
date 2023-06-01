import 'dart:developer' as devtools show log;
import 'dart:developer';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart' as player;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:influencer/FirebaseMessage/single_chat_history_controller.dart';
import 'package:influencer/FirebaseServices/firbase_collection.dart';
import 'package:influencer/Firebase_notification/notification_services.dart';

import 'package:influencer/admin_module/admin_archived/controller/admin_archived_controller.dart';
import 'package:influencer/admin_module/admin_archived/view/component/googlemap.dart';
import 'package:influencer/admin_module/admin_archived/view/widgets/audioCall.dart';
import 'package:influencer/admin_module/contactti/view/widget/audio_provider.dart';

import 'package:influencer/admin_module/profile/profile_controller.dart';
import 'package:influencer/admin_module/profile/user_profile_detail_view.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'package:influencer/admin_module/two_way_channel/view/widgets/admin_group_chat_controller.dart';
import 'package:influencer/admin_module/two_way_channel/view/widgets/group_list_card_widget.dart';
import 'package:influencer/routes/app_pages.dart';

import 'package:influencer/util/LoadingWidget.dart';
import 'package:influencer/util/color.dart';

import 'package:influencer/util/common_app.dart';
import 'package:influencer/util/dimension.dart';
import 'package:influencer/util/image_const.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:influencer/util/string.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../../../../FirebaseServices/firebase_methods.dart';
import '../../../two_way_channel/view/AdminGroupChat/user_group_input_view.dart';

// duration issue
class AdminInputChatView extends StatefulWidget {
  AdminInputChatView({
    Key? key,
  }) : super(key: key);

//  final ContacttiListAdmin? contactlist;
  @override
  State<AdminInputChatView> createState() => _AdminInputChatViewState();
}

class _AdminInputChatViewState extends State<AdminInputChatView>
    with WidgetsBindingObserver {
  final aGroupController = Get.find<AdminGroupChatController>();
  final TextEditingController _controller = TextEditingController();
  final currentUser = Get.find<CurrentUserController>();
  final messageController = Get.find<MessageController>();
  final proController = Get.find<ProfileController>();
  final fireStore = FirebaseFirestore.instance;
  final con = Get.find<CurrentUserController>();
  final AdminArchivedController controller =
      Get.put<AdminArchivedController>(AdminArchivedController());
  FirebaseStorage storage = FirebaseStorage.instance;
  String audioUrl = '';
  int counter = 0;
  List myLists = [];

  bool emojiShowing = false;
  final FocusNode focusNode = FocusNode();
  bool isbutton = false;
  bool isRecording = false;
  late FireBaseMethods fireBaseOtherUser;
  var otherUserRes;
  var _stream;
  bool isLoad = false;

  late FireBaseMethods _firebaseMethods;
  int audioDuration = 0;
  late final RecorderController recorderController;
  late final PlayerController playerController1;

  String? path;
  String? musicFile;
  late Directory appDirectory;
  final player.AudioPlayer _audioPlayer = player.AudioPlayer();
  bool isPlaying = false;
  late final Duration duration;
  late final Duration position;

  ///////

  getOtherUser() async {
    setState(() {
      isLoad = true;
    });
    fireBaseOtherUser = FireBaseMethods();
    otherUserRes = await fireBaseOtherUser.getUserCollectData(
        otherUserId: messageController.UserId.toString(), collection: 'users');
    proController.userProfileId = messageController.UserId;

    _stream = fireStore
        .collection('users')
        .doc(messageController.UserId.toString())
        .collection('userChat')
        .orderBy('time', descending: false)
        .snapshots();

    setState(() {
      isLoad = false;
    });
  }

  @override
  void initState() {
    // audio player
    duration = Duration();
    position = Duration();

    // audio player

    super.initState();
    _firebaseMethods = FireBaseMethods();

    getOtherUser();
    _initialiseControllers();
    initRecorder();

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
    _audioPlayer.stop();
    _audioPlayer.dispose();
    // _soundRecorder.closeRecorder();
    super.dispose();
    _disposeControllers();
    recorder.closeRecorder();
  }

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

  void _disposeControllers() {
    recorderController.dispose();
    playerController1.stopAllPlayers();
  }

  bool isButton = false;

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
    isRecording = true;
    await recorder.startRecorder(toFile: "audio");
  }

  Future stopRecorder() async {
    audioUrl = '';
    isRecording = false;
    final filePath = await recorder.stopRecorder();
    // await recorderController.record(path);
    final file = File(filePath!);
    String uniqueFilename = const Uuid().v1();
    // var uri = Uri.file(uniqueFilename)
    Reference reference = FirebaseStorage.instance.ref();
    Reference referenceRootDir = reference.child('userChat');
    Reference referenceRootDirToUpload = referenceRootDir.child(uniqueFilename);
    await referenceRootDirToUpload.putFile(File(filePath));
    await referenceRootDirToUpload
        .getDownloadURL()
        .then((value) => audioUrl = value);

    // Reference ref =
    //     storage.ref().child('voiceNotes/${file.path.split('/').last}');
    // UploadTask uploadTask = ref.putFile(file);
    // TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    // String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    // audioUrl = downloadUrl;
    setState(() {});
    recorderController.reset();
    log('Recorded file path: ${audioUrl} o');
  }

  String fileType = 'All';
  FilePickerResult? result;
  PlatformFile? file;

  File? imageFile;
  Contact? _phoneContact;

  playPauseAudio(mapData) async {
    log('audio map printingf from a mapData $mapData');
    // log('messageController.activeAudioMap ${messageController.activeAudioMap.value['id']}');
    // if (messageController.activeAudioMap.value.isNotEmpty) {
    //   // if(){

    //   // }
    //   messageController.activeAudioMap.value.clear();

    //   messageController.audiomap.value['play'] = false;
    //   await _audioPlayer.stop();
    // } else if (messageController.activeAudioMap.value.isEmpty) {
    //   messageController.activeAudioMap.value.addAll(mapData);

    //   await _audioPlayer.play(messageController.audiomap.value['text']);
    //   messageController.audiomap.value['play'] = true;
    //   log('after update of map ${messageController.audiomap}');

    //   _audioPlayer.onPlayerStateChanged.listen((event) {
    //     setState(() {
    //       event == player.PlayerState.PLAYING;
    //     });
    //   });

    //   _audioPlayer.onDurationChanged.listen((event) {
    //     setState(() {
    //       messageController.audiomap.value['duration'] = event;
    //       log('duration change::$event');
    //     });
    //   });
    //   _audioPlayer.onAudioPositionChanged.listen((event) {
    //     setState(() {
    //       log('audio position::$event');
    //       messageController.audiomap.value['position'] = event;
    //     });
    //   });
    // }
  }

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
                          Get.to(const UserProfileDetailView());
                        },
                        child: CircleAvatar(
                            backgroundColor: Colors.grey.shade100,
                            radius: 20.r,
                            child: Obx(
                              () => ImageWidgetProg(
                                imageUrl:
                                    messageController.singleChatImage.value,
                              ),
                            )),
                      ),
                      backbtn: const Icon(
                        Icons.arrow_back,
                        color: IColor.mainBlueColor,
                      ),
                      backFunction: () {
                        Get.back();
                      },
                      name: otherUserRes.data()['name'].toString(),
                      sufix1onpress: () {
                        // Get.toNamed(Paths.voiceCall);
                        Get.to(const VoiceCall());
                      },
                      sufixicon1: const Icon(
                        Icons.call,
                        color: IColor.mainBlueColor,
                      ),
                      sufix2onpress: () {
                        Get.toNamed(Paths.contattiVideoCall);
                      },
                      sufixicon2: ImageConstant.imgVideocamera,
                      sufixicon3: const Icon(
                        Icons.more_vert,
                        color: IColor.mainBlueColor,
                      ),
                    ),

                    StreamBuilder(
                      stream: _stream,
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          ;
                          log('snapshot.data!.docs.length ${snapshot.data!.docs.length}');
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
                                    DateFormat(' hh:mm:ss').format(dateTime);
                                Duration duration = Duration(
                                    milliseconds: data['audioDuration']);

                                if (data['messageType'] == 'audio') {
                                  bool containsMap = messageController
                                      .activeAudioMap.value
                                      .any(
                                          (map) => map['text'] == data['text']);
                                  log(' containsMap ${messageController.activeAudioMap.value.length}');

                                  if (!containsMap) {
                                    messageController.activeAudioMap.value.add({
                                      'id': data['id'],
                                      'audioUrl': data['text'],
                                      'duration': duration,
                                      'position': duration,
                                      'play': false
                                    });
                                  }

                                  // bool isListAvailable = doesLis
                                  // bool isAvailable = messageController
                                  //     .audioListMAp.value
                                  //     .contains(data['id']);
                                  // counter++;
                                  // log('is avaialable isAvailable $isAvailable ');

                                  // if (isAvailable == false) {

                                  // if (data.isNotEmpty) {
                                  //   messageController.audioListMAp.value.addAll;

                                  //   messageController.audioListMAp.value.add({
                                  // 'id': data['id'],
                                  // 'audioUrl': data['text'],
                                  // 'duration': duration,
                                  // 'position': duration,
                                  // 'play': false
                                  // });

                                  // }
                                  // }
                                  log(' Map lis of data ${messageController.activeAudioMap.value}');
                                }

                                /*
                                  'audioUrl': data['text'],
                                      'duration': duration,
                                      'position': duration,
                                      'play': false
                                */

                                /*
                                 isPlaying == false
                        ? await _audioPlayer.play(widget.audioUrl)
                        : await _audioPlayer.pause();
                        isPlaying ? Icons.pause : Icons.play_arrow

                        ////
                        return data['messageType'] == 'audio'
                                    ? AudioPlayerWidget(
                                        map: map,
                                        audioUrl: data['text'],
                                        duration: duration,
                                        position: duration)
                                */

                                return data['messageType'] == 'audio'
                                    ? Text('data')
                                    //  AudioPlayerWidget(
                                    //     icon: messageController
                                    //             .audiomap.value['play']
                                    //         ? Icons.pause
                                    //         : Icons.play_arrow,
                                    //     onTap: () {
                                    //       // log('ontap working  ${data['id']}');
                                    //       // log('map data is printing here ${messageController.audiomap}');
                                    //       // messageController
                                    //       //     .audioActivityList.value = [
                                    //       //   messageController.audiomap
                                    //       // ];
                                    //       // messageController.activeAudio.value =
                                    //       //     data['id'];

                                    //       playPauseAudio(
                                    //           messageController.audiomap.value

                                    //           // messageController
                                    //           //   .audiomap.value['audioUrl']
                                    //           );
                                    //     },
                                    //     duration: messageController
                                    //         .audiomap.value['duration'],
                                    //     position: messageController
                                    //         .audiomap.value['position'],
                                    //   )
                                    : ChatBubbleWidget(
                                        imageUrl: data['photo'],
                                        name: data['name'] ?? ' name',
                                        isMe: data['email'] ==
                                            con.currentUser?.email,
                                        message: data['text'] ?? 'message',
                                        time: dateString,
                                      );
                              }).toList(),
                            ),
                          );
                        }
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        return const Center(child: LoaderWidget());
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
                                                  Duration duration = snapshot
                                                          .hasData
                                                      ? snapshot.data!.duration
                                                      : Duration.zero;

                                                  int durationMilliseconds =
                                                      duration.inMilliseconds;

                                                  audioDuration =
                                                      durationMilliseconds;

                                                  return Text(
                                                    AudioProvider
                                                        .formatDuration(
                                                            duration),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  );
                                                },
                                                stream: recorder.onProgress,
                                              ),
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
                                                  icon: const Icon(
                                                      Icons.attachment)),
                                              contentPadding: EdgeInsets.all(5),
                                              hintText: Strings
                                                  .chating_search_hinttext,
                                              hintStyle: const TextStyle(
                                                  color: Colors.grey),
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
                                        if (_controller.text.isNotEmpty) {
                                          _firebaseMethods.addCollection(
                                              collectionPath: 'users',
                                              docId: messageController.UserId,
                                              msgCollectionPath: 'userChat',
                                              documentMap: {
                                                'messageType': 'text',
                                                'id': messageController.UserId
                                                    .toString(),
                                                'name': currentUser
                                                    .currentUser!.name
                                                    .toString(),
                                                'email': currentUser
                                                    .currentUser!.email
                                                    .toString(),
                                                'text': _controller.text,
                                                'photo': messageController
                                                    .singleChatImage.value,
                                                'time': Timestamp.now(),
                                              });

                                          // counter

                                          var recentChat =
                                              await fireBaseOtherUser
                                                  .getUserCollectData(
                                                      otherUserId:
                                                          messageController
                                                                  .UserId
                                                              .toString(),
                                                      collection:
                                                          'recentChats');
                                          // get  user fcmToken
                                          var getUserCollection =
                                              await fireBaseOtherUser
                                                  .getUserCollectData(
                                                      otherUserId:
                                                          messageController
                                                                  .UserId
                                                              .toString(),
                                                      collection: 'users');
                                          var collectionRes =
                                              await getUserCollection.data();
                                          var UserFcmToken =
                                              collectionRes['fcmToken'];
                                          var userPhoto =
                                              collectionRes['photoUrl'];

                                          var messageCount = 1;
                                          if (recentChat.data() != null) {
                                            if (recentChat
                                                    .data()?['isUserRead'] ==
                                                false) {
                                              messageCount = recentChat
                                                  .data()?['userMessageCount'];
                                              messageCount = messageCount + 1;
                                            }
                                          }

                                          //recent chat of user
                                          fireStore
                                              .collection('recentChats')
                                              .doc(messageController.UserId
                                                  .toString())
                                              .set({
                                            'adminUid': currentUser
                                                .currentUser?.uid
                                                .toString(),
                                            'userUid': messageController.UserId
                                                .toString(),
                                            'adminMessageCount': 0,
                                            'isAdminRead': false,
                                            'lastMessage': _controller.text,
                                            'userName': otherUserRes
                                                .data()['name']
                                                .toString(),
                                            'photoUrl': userPhoto ?? '',
                                            'userMessageCount': messageCount,
                                            'isUserRead': false,
                                            'time': Timestamp.now()
                                          });
                                          // Notification

                                          LocalNotificationServices
                                              .sendNotification(
                                                  'nuovo messaggio',
                                                  _controller.text,
                                                  UserFcmToken ?? '');
                                          _controller.clear();
                                        }
                                      },
                                      child: const CircleAvatar(
                                        radius: 25,
                                        child: Icon(Icons.send),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {},
                                      child: CircleAvatar(
                                        radius: 22.r,
                                        child: isRecording == true
                                            ? IconButton(
                                                onPressed: () async {
                                                  await stopRecorder();

                                                  await _firebaseMethods
                                                      .addCollection(
                                                          collectionPath:
                                                              'users',
                                                          docId:
                                                              messageController
                                                                  .UserId,
                                                          msgCollectionPath:
                                                              'userChat',
                                                          documentMap: {
                                                        'audioDuration':
                                                            audioDuration,
                                                        'messageType': 'audio',
                                                        'id': messageController
                                                            .UserId.toString(),
                                                        'name': currentUser
                                                            .currentUser!.name
                                                            .toString(),
                                                        'email': currentUser
                                                            .currentUser!.email
                                                            .toString(),
                                                        'text': audioUrl,
                                                        'photo':
                                                            messageController
                                                                .singleChatImage
                                                                .value,
                                                        'time': Timestamp.now(),
                                                      });

                                                  setState(() {});
                                                },
                                                icon: const Icon(Icons.send))
                                            : IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    startRecord();
                                                  });
                                                },
                                                icon: const Icon(Icons.mic)),
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

  void _refreshWave() {
    if (isRecording) recorderController.refresh();
  }

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

// observer here
/*
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async{
    // TODO: implement didChangeAppLifecycleState
    switch (state) {
      case AppLifecycleState.resumed:
        print("app in resumed");
        //Play the Music
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        //Stop the music
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        await _audioPlayer.stop();
        await  _audioPlayer.dispose();
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        await _audioPlayer.stop();
        await  _audioPlayer.dispose();
        //Stop the music
        break;
    }
  }
*/

}

class AudioPlayerWidget extends StatelessWidget {
  AudioPlayerWidget({
    Key? key,
    // required this.audioUrl,
    required this.duration,
    required this.position,
    required this.onTap,
    required this.icon,
  });

  Duration duration;
  Duration position;
  VoidCallback onTap;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 50),
      // width: 100,
      color: Colors.pink,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    onTap();
                  },
                  icon: Icon(icon)),
              Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (double value) async {
                  final pos = Duration(seconds: value.toInt());
                  log('pos of audio player');
                  // await _audioPlayer.seek(pos);
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(AudioProvider.formatDuration(position)),
              Text(AudioProvider.formatDuration(duration - position)),
            ],
          ),
        ],
      ),
    );
  }
}

/*

class AudioPlayerWidget extends StatefulWidget {
  AudioPlayerWidget(
      {Key? key,
      required this.audioUrl,
      required this.duration,
      required this.position,
      required this.map});

  String audioUrl;
  Duration duration;
  Duration position;
  Map map;

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final player.AudioPlayer _audioPlayer = player.AudioPlayer();
  List audioPlayerList = [];
  late final player.AudioPlayer currentAudioPlayer;

  bool isPlaying = false;
  @override
  void initState() {
    // currentAudioPlayer = player.AudioPlayer();

    _audioPlayer.onPlayerStateChanged.listen((event) {
      setState(() {
        isPlaying = event == player.PlayerState.PLAYING;
      });
    });

    _audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        widget.duration = event;
        log('duration change::$event');
      });
    });
    _audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        log('audio position::$event');
        widget.position = event;
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  playStop({String playerUrl = ''}) {
    if (audioPlayerList.isEmpty) {
      audioPlayerList.add({_audioPlayer.play(playerUrl): true});
    } else {
      audioPlayerList.clear();
      audioPlayerList.add({_audioPlayer.play(playerUrl): true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 50),
      // width: 100,
      color: Colors.pink,
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () async {

                    log('map data ${widget.map}');
                    // playStop(playerUrl: widget.audioUrl);
                    // if (isPlaying == false) {
                    //   final paly = await _audioPlayer.play(widget.audioUrl);
                    //   log('play variable::$paly');
                    // } else {
                    //   final pause = await _audioPlayer.pause();
                    //   log(' variable::$pause');
                    // }

                    // isPlaying == false
                    //     ? await _audioPlayer.play(widget.audioUrl)
                    //     : await _audioPlayer.pause();
                  },
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow)),
              Slider(
                min: 0,
                max: widget.duration.inSeconds.toDouble(),
                value: widget.position.inSeconds.toDouble(),
                onChanged: (double value) async {
                  final pos = Duration(seconds: value.toInt());
                  log('pos of audio player');
                  await _audioPlayer.seek(pos);
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(AudioProvider.formatDuration(widget.position)),
              Text(AudioProvider.formatDuration(
                  widget.duration - widget.position)),
            ],
          ),
        ],
      ),
    );
  }
}
*/


