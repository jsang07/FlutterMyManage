import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mymanage/api_helper/diaglog_firebase.dart';
import 'package:mymanage/api_helper/helper_method.dart';
import 'package:mymanage/api_helper/notiapi.dart';
import 'package:uuid/uuid.dart';

class DetailPage extends StatefulWidget {
  final String category, title, user, postId, time;
  const DetailPage(
      {super.key,
      required this.title,
      required this.user,
      required this.postId,
      required this.time,
      required this.category});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final itemCollection = FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser!.email.toString());
  final addItemtextEditingController = TextEditingController();
  final editItemtextEditingController = TextEditingController();
  final addTimetextEditingController = TextEditingController();
  final post = showPost();
  final noti = Noti();
  int notificationId = 0;
  bool _isChecked = false;
  bool onOff = false;
  var postid = const Uuid().v4();

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
          centerTitle: true,
          title: Text(
            widget.category,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () => post.addItem(
                        context,
                        addItemtextEditingController,
                        widget.title,
                        postid,
                        _isChecked,
                        itemCollection,
                      ),
                      child: const Icon(
                        Icons.add_box,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(currentUser!.email.toString())
                      .doc(widget.title.toString())
                      .collection('alarmItems')
                      .orderBy('Timestamp', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          // ignore: non_constant_identifier_names
                          final Items = snapshot.data!.docs[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 15, 13),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(formDate(Items['Timestamp'])),
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
                                            onTap: () {
                                              post.editField(
                                                  context,
                                                  editItemtextEditingController,
                                                  widget.title,
                                                  Items['PostId'],
                                                  itemCollection);
                                            },
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Icon(
                                                  Icons.edit,
                                                  color: Colors.black,
                                                ),
                                                Text('수정'),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            onTap: () {
                                              post.showDeleteCheckDialog(
                                                  context,
                                                  itemCollection,
                                                  widget.title,
                                                  Items['PostId']);
                                            },
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Items['Items'],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          CupertinoSwitch(
                                            value: Items['OnOff'],
                                            activeColor: Colors.black,
                                            onChanged: (bool? value) async {
                                              setState(() {
                                                _isChecked = value ?? false;
                                              });
                                              itemCollection
                                                  .doc(widget.title)
                                                  .collection('alarmItems')
                                                  .doc(Items['PostId'])
                                                  .update({
                                                'OnOff': _isChecked,
                                              });
                                              if (_isChecked == true) {
                                                await noti.schedulNotification(
                                                    Items['Items'],
                                                    DateFormat(
                                                            'yyyy-MM-dd HH:mm')
                                                        .format(
                                                      formTime(Items[
                                                          'ScheduleTime']),
                                                    ),
                                                    formTime(
                                                        Items['ScheduleTime']),
                                                    notificationId);
                                                setState(() {
                                                  notificationId++;
                                                });
                                              }
                                            },
                                          ),
                                          Text(DateFormat('yyyy-MM-dd HH:mm')
                                              .format(
                                            formTime(Items['ScheduleTime']),
                                          )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
