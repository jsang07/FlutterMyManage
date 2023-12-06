import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mymanage/api_helper/diaglog_firebase.dart';
import 'package:mymanage/api_helper/helper_method.dart';
import 'package:mymanage/manage/post.dart';
import 'package:mymanage/page/profile.dart';

class ManagePage extends StatefulWidget {
  const ManagePage({super.key});

  @override
  State<ManagePage> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final post = showPost();
  final categoryEditingController = TextEditingController();
  final titleEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey.shade900,
        elevation: 0,
        onPressed: () {
          post.postManage(context, categoryEditingController,
              titleEditingController, currentUser?.email);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          '나의 관리일지',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ));
              },
              child: const Icon(
                Icons.person_pin_rounded,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(children: [
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(currentUser!.email.toString())
                .orderBy('Timestamp', descending: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final post = snapshot.data!.docs[index];
                    return Post(
                      category: post['Category'],
                      title: post['Title'],
                      user: post['UserEmail'],
                      time: formDate(post['Timestamp']),
                      postId: post.id,
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              return Center(
                child: Container(),
              );
            },
          )),
        ]),
      ),
    );
  }
}
