import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mymanage/api_helper/media_picker.dart';
import 'package:mymanage/socail/bloc/social_bloc.dart';
import 'package:mymanage/socail/bloc/social_event.dart';
import 'package:mymanage/socail/model/social_model.dart';
import 'package:mymanage/widget/myTextField.dart';

class SocialAdd extends StatefulWidget {
  const SocialAdd({super.key});

  @override
  State<SocialAdd> createState() => _SocialAddState();
}

class _SocialAddState extends State<SocialAdd> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final titleEditingController = TextEditingController();
  final contentEditingController = TextEditingController();

  final List images = [];
  File? _image;
  var mediaPicker = MediaPicker();
  final List<Map<String, dynamic>> _mediaFiles = [];
  void pickImgaes() async {
    var pickFiles = await mediaPicker.pickImage();
    setState(() {
      _mediaFiles.addAll(pickFiles);
    });
  }

  removeMedia(index) {
    setState(() {
      _mediaFiles.removeAt(index - 1);
    });
  }

  Future<void> add() async {
    final SocialBloc socialBloc = BlocProvider.of<SocialBloc>(context);
    for (int i = 0; i < _mediaFiles.length; i++) {
      setState(() {
        _image = File(_mediaFiles[i]['mediaFile']);
      });
      final refImage = FirebaseStorage.instance
          .ref()
          .child('SocialPhotos')
          .child('SocialPhotos$i${Timestamp.now()}.png');
      await refImage.putFile(_image!);
      final imgUrl = await refImage.getDownloadURL();
      setState(() {
        images.add(imgUrl);
      });
    }

    if (titleEditingController.text.isNotEmpty &&
        contentEditingController.text.isNotEmpty) {
      final social = Social(
          id: Timestamp.now().toString(),
          title: titleEditingController.text,
          content: contentEditingController.text,
          userMail: currentUser!.email.toString(),
          userUid: currentUser!.uid.toString(),
          images: images,
          timestamp: Timestamp.now());
      socialBloc.add(CreateSocial(social));
    }
    FirebaseFirestore.instance
        .collection('searchUsers')
        .doc('username')
        .update({
      'names': FieldValue.arrayUnion([titleEditingController.text])
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // final SocialBloc socialBloc = BlocProvider.of<SocialBloc>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            '내 관리 자랑하기',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
              child: Column(
                children: [
                  myTextField(
                      textEditingController: titleEditingController,
                      hintText: '제목을 입력하세요'),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Colors.white,
                    child: TextField(
                      maxLines: 12,
                      controller: contentEditingController,
                      decoration: InputDecoration(
                          hintText: '내용을 입력하세요',
                          contentPadding:
                              const EdgeInsets.only(left: 20, top: 30),
                          filled: true,
                          fillColor: Colors.grey[200],
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20))),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: _mediaFiles.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index == 0) {
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12.0)),
                            child: IconButton(
                                onPressed: () {
                                  pickImgaes();
                                },
                                icon: const Icon(Icons.add_a_photo)),
                          );
                        }
                        var mediaFile = _mediaFiles[index - 1];
                        var thumbnailFile = File(mediaFile['thumbnailFile']);

                        return Stack(
                          children: [
                            Image.file(thumbnailFile,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover),
                            Positioned(
                                right: 5,
                                top: 5,
                                child: GestureDetector(
                                  onTap: () async {
                                    removeMedia(index);
                                  },
                                  child: const Icon(Icons.close_rounded),
                                ))
                          ],
                        );
                      }),
                  const Padding(padding: EdgeInsets.only(bottom: 100))
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: GestureDetector(
                onTap: () {
                  add();
                },
                child: Container(
                  width: width,
                  height: height * 0.065,
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(25)),
                  child: const Center(
                    child: Text(
                      '글 올리기',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
