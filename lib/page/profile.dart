import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mymanage/auth/auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final userCollection = FirebaseFirestore.instance.collection('Users');

  Future<void> editField(String field) async {
    String newValue = '';
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          '$field 수정하기',
          style: const TextStyle(color: Colors.black),
        ),
        content: TextField(
          style: const TextStyle(color: Colors.black),
          autofocus: true,
          decoration: InputDecoration(
              hintText: field, hintStyle: const TextStyle(color: Colors.black)),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    if (newValue.trim().length > 0) {
                      await userCollection
                          .doc(currentUser!.email)
                          .update({field: newValue});
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0.2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      fixedSize: const Size(110, 45),
                      backgroundColor: Colors.black),
                  child: const Text('수정하기',
                      style: TextStyle(fontWeight: FontWeight.w600))),
              ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop(newValue);
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0.2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      fixedSize: const Size(110, 45),
                      backgroundColor: Colors.black),
                  child: const Text('취소',
                      style: TextStyle(fontWeight: FontWeight.w600)))
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: const Text(
          '내 프로필',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(currentUser?.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return ListView(
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      const Icon(
                        Icons.person,
                        size: 70,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Text(
                          '프로필',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        padding: const EdgeInsets.fromLTRB(20, 5, 20, 18),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '닉네임',
                                  style: TextStyle(color: Colors.black),
                                ),
                                IconButton(
                                  onPressed: () => editField('username'),
                                  icon: const Icon(Icons.edit),
                                  color: Colors.black,
                                )
                              ],
                            ),
                            Text(
                              userData['username'],
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error ${snapshot.error}'),
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthPage(),
                        ),
                        (route) => false);
                  },
                  child: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.grey),
                  )),
              const Text('  /  '),
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    '계정 탈퇴',
                    style: TextStyle(color: Colors.grey),
                  )),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
