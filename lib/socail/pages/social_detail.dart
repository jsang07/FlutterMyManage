import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mymanage/api_helper/helper_method.dart';

class SocialDetail extends StatefulWidget {
  final String title, content, user, postId, time;
  final List img;
  const SocialDetail(
      {super.key,
      required this.title,
      required this.content,
      required this.user,
      required this.postId,
      required this.time,
      required this.img});

  @override
  State<SocialDetail> createState() => _SocialDetailState();
}

class _SocialDetailState extends State<SocialDetail> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final commenttextEditingController = TextEditingController();

  void addComment() {
    FirebaseFirestore.instance
        .collection('User Posts')
        .doc(widget.postId)
        .collection('Comments')
        .add({
      "CommentText": commenttextEditingController.text,
      "CommentedBy": currentUser?.email,
      "CommentTime": Timestamp.now()
    });
  }

  @override
  Widget build(BuildContext context) {
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
        ),
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CarouselSlider.builder(
                          itemCount: widget.img.length,
                          itemBuilder: (context, index, realIndex) {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                widget.img[index],
                                fit: BoxFit.contain,
                              ),
                            );
                          },
                          options: CarouselOptions(
                            enableInfiniteScroll: false,
                            autoPlay: false,
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(fontSize: 20),
                          ),
                          PopupMenuButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            child: Icon(
                              Icons.more_horiz_outlined,
                              color: Colors.grey.shade600,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                onTap: () {},
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.black,
                                    ),
                                    Text('삭제'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Text(widget.user.split('@')[0]),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[200],
                  thickness: 10,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  '댓글',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('User Posts')
                      .doc(widget.postId)
                      .collection('Comments')
                      .orderBy("CommentTime", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 90.0),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: snapshot.data!.docs.map((doc) {
                          final commentData = doc.data();
                          return Container(
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.fromLTRB(18, 10, 18, 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4)),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        commentData['CommentedBy']
                                            .split('@')[0],
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      PopupMenuButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Icon(
                                          Icons.more_horiz_outlined,
                                          color: Colors.grey.shade600,
                                        ),
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            onTap: () {},
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Icon(
                                                  Icons.delete,
                                                  color: Colors.black,
                                                ),
                                                Text('삭제'),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    commentData['CommentText'],
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Text(formDate(commentData['CommentTime']),
                                      style:
                                          const TextStyle(color: Colors.grey))
                                ]),
                          );
                        }).toList(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.fromLTRB(10, 13, 10, 13),
              child: TextField(
                controller: commenttextEditingController,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        addComment();
                        commenttextEditingController.clear();
                      },
                      child: const Icon(Icons.arrow_upward_rounded,
                          color: Colors.grey),
                    ),
                    hintText: '댓글을 입력하세요',
                    contentPadding: const EdgeInsets.only(left: 20),
                    filled: true,
                    fillColor: Colors.grey[200],
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30))),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
