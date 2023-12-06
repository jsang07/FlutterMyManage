import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mymanage/api_helper/diaglog_firebase.dart';
import 'package:mymanage/manage/detail_page.dart';

class Post extends StatefulWidget {
  final String category, title, user, postId, time;

  const Post({
    super.key,
    required this.user,
    required this.postId,
    required this.time,
    required this.title,
    required this.category,
  });

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final commenttextEditingController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  bool isliked = true;
  final post = showPost();
  final itemCollection = FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser!.email.toString());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(
                category: widget.category,
                title: widget.title,
                user: widget.user,
                postId: widget.postId,
                time: widget.time,
              ),
            ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 15, 10, 15),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.category,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.clip),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(
                          Icons.more_horiz_outlined,
                          color: Colors.grey.shade600,
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () {
                              post.showDeleteAllCheckDialog(
                                  context, itemCollection, widget.title);
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      )),
                ],
              ),
              Text(
                widget.title,
                style:
                    const TextStyle(fontSize: 16, overflow: TextOverflow.clip),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(widget.time,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}
