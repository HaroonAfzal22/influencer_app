import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:influencer/FirebaseServices/firebase_auth.dart';
import 'package:influencer/admin_module/two_way_channel/view/home_controller.dart';
import 'package:influencer/util/LoadingWidget.dart';
import 'package:influencer/util/dimension.dart';

class ImageView extends StatefulWidget {
  ImageView(
      {this.imageFile,
      this.fileName,
      this.imageUrl,
      this.pickedImage,
      required this.collection,
      required this.docId,
      required this.field});
  var imageFile;
  var fileName;
  var imageUrl;
  var pickedImage;
  String collection, docId, field;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  FirebaseStorage storage = FirebaseStorage.instance;

  final fireStore = FirebaseFirestore.instance;

  final cunUser = Get.find<CurrentUserController>();

  AuthProvider authProvider = AuthProvider();
  bool loader = false;

  uploadPicture() async {
    try {
      // Uploading the selected image with some custom meta data
      Reference ref =
          storage.ref('${cunUser.currentUser?.uid}/${widget.fileName}');
      UploadTask uploadTask = ref.putFile(
          widget.imageFile!,
          SettableMetadata(customMetadata: {
            'uploaded_by': 'A bad guy',
            'description': 'Some description...'
          }));
      uploadTask.then((value) async {
        var url = await value.ref.getDownloadURL();
        widget.imageUrl = url.toString();

        await fireStore
            .collection(widget.collection)
            .doc(widget.docId)
            .update({widget.field: widget.imageUrl});
      });

      // Refresh the UI

      if (widget.pickedImage != null) {
        widget.imageFile = File(widget.pickedImage!.path);
      } else {
        print('No image selected.');
      }
    } on FirebaseException catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: loader == true
            ? const LoaderWidget()
            : Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.file(
                        widget.imageFile!,
                        // width: Dimensions.height135,
                        // height: Dimensions.height120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 40,
                            )),
                        IconButton(
                            onPressed: () async {
                              setState(() {
                                loader = true;
                              });
                              await uploadPicture();

                              // widget.imageFile = File('');
                              widget.fileName = '';
                              widget.imageUrl = '';
                              widget.pickedImage = '';

                              setState(() {
                                loader = false;
                              });
                              Get.back();
                            },
                            icon: const Icon(
                              Icons.check_circle_outline,
                              color: Colors.blue,
                              size: 40,
                            ))
                      ],
                    )
                  ],
                ),
              ));
  }
}
