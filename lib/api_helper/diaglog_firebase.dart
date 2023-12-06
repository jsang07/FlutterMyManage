import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mymanage/widget/myTextField.dart';

class showPost {
  void showDeleteCheckDialog(
      context, CollectionReference fbcoll, String title, postId) {
    showDialog(
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: AlertDialog(
          title: const Text('해당 관리 항목을 \n삭제하시겠습니까?',
              style: TextStyle(fontWeight: FontWeight.w500)),
          content: Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: const Text('삭제한 항목은 되돌릴 수 없습니다',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      fbcoll
                          .doc(title)
                          .collection('alarmItems')
                          .doc(postId)
                          .delete();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0.2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35)),
                        fixedSize: const Size(120, 50),
                        backgroundColor: Colors.black),
                    child: const Text('삭제하기',
                        style: TextStyle(fontWeight: FontWeight.w600))),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0.2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35)),
                        fixedSize: const Size(120, 50),
                        backgroundColor: Colors.black),
                    child: const Text('취소',
                        style: TextStyle(fontWeight: FontWeight.w600)))
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 첫 매니지 주제 추가
  void postManage(context, TextEditingController textController,
      textController2, String? user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          '관리 항목 추가',
          style: TextStyle(color: Colors.black),
        ),
        content: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.8,
          height: 300,
          child: Column(children: [
            myTextField(
                textEditingController: textController, hintText: '종류를 선택해주세요'),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: Text(
                    '관리하고싶은 요소를 적어주세요 \nEx: 자동차, 필수 소비물품',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                )
              ],
            ),
            myTextField(
                textEditingController: textController2, hintText: '제목을 입력하세요'),
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: Text(
                    '위에 적은 관리 요소 제목을 적어주세요\nEx: 필수 소비물품 선택시 기초 화장품 ',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                )
              ],
            ),
          ]),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    if (textController.text.isNotEmpty &&
                        textController2.text.isNotEmpty) {
                      FirebaseFirestore.instance
                          .collection(user!)
                          .doc(textController2.text)
                          .set({
                        'UserEmail': user,
                        'Category': textController.text,
                        'Title': textController2.text,
                        'Timestamp': Timestamp.now(),
                      });
                    }
                    textController.clear();
                    textController2.clear();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0.2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      fixedSize: const Size(110, 45),
                      backgroundColor: Colors.black),
                  child: const Text('추가하기',
                      style: TextStyle(fontWeight: FontWeight.w600))),
              SizedBox(
                width: 15,
              ),
              ElevatedButton(
                  onPressed: () {
                    textController.clear();
                    textController2.clear();
                    Navigator.of(context).pop();
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

  // 시간 선택
  DateTime _dateTime = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectDateTime(context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (pickedTime != selectedTime) {
          _dateTime = selectedDateTime;
        }
      }
    }
  }

  Future<void> addItem(
    context,
    TextEditingController textController,
    String title,
    postId,
    bool onOff,
    CollectionReference fbcoll,
  ) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          '관리 항목 추가',
          style: TextStyle(color: Colors.black),
        ),
        content: Container(
            height: 160,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text('시간 주기 날짜 설정'),
                ),
                GestureDetector(
                    onTap: () {
                      _selectDateTime(context);
                    },
                    child: const Icon(Icons.more_time_sharp)),
                myTextField(
                    textEditingController: textController,
                    hintText: '관리할 항목을 적어주세요')
              ],
            )),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    if (textController.text.isNotEmpty) {
                      await fbcoll
                          .doc(title)
                          .collection('alarmItems')
                          .doc(postId)
                          .set({
                        'PostId': postId,
                        'Items': textController.text,
                        'OnOff': onOff,
                        'Timestamp': Timestamp.now(),
                        'ScheduleTime': _dateTime
                      });
                    }
                    textController.clear();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 0.2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      fixedSize: const Size(110, 45),
                      backgroundColor: Colors.black),
                  child: const Text('추가하기',
                      style: TextStyle(fontWeight: FontWeight.w600))),
              ElevatedButton(
                  onPressed: () {
                    textController.clear();
                    Navigator.of(context).pop();
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

  // edit alarmItems
  Future<void> editField(context, TextEditingController textController,
      String title, postId, CollectionReference fbcoll) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          '항목 수정하기',
          style: TextStyle(color: Colors.black),
        ),
        content: SizedBox(
          height: 150,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text('시간 주기 날짜 설정'),
              ),
              GestureDetector(
                  onTap: () {
                    _selectDateTime(context);
                  },
                  child: const Icon(Icons.more_time_sharp)),
              TextField(
                controller: textController,
                style: const TextStyle(color: Colors.black),
                autofocus: true,
                decoration: const InputDecoration(
                    hintText: '수정할 항목을 적어주세요',
                    hintStyle: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    if (textController.text.isNotEmpty) {
                      await fbcoll
                          .doc(title)
                          .collection('alarmItems')
                          .doc(postId)
                          .update({
                        'Items': textController.text,
                        'ScheduleTime': _dateTime,
                      });
                    }
                    textController.clear();
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
                  onPressed: () {
                    textController.clear();
                    Navigator.of(context).pop();
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

  // delete all
  void showDeleteAllCheckDialog(
      context, CollectionReference fbcoll, String title) {
    showDialog(
      context: context,
      builder: (context) => ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: AlertDialog(
          title: const Text('해당 관리일지 전체를 \n삭제하시겠습니까?',
              style: TextStyle(fontWeight: FontWeight.w500)),
          content: Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: const Text('삭제한 관리일지는 되돌릴 수 없습니다',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      deletePost(fbcoll, title);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0.2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35)),
                        fixedSize: const Size(120, 50),
                        backgroundColor: Colors.black),
                    child: const Text('삭제하기',
                        style: TextStyle(fontWeight: FontWeight.w600))),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0.2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(35)),
                        fixedSize: const Size(120, 50),
                        backgroundColor: Colors.black),
                    child: const Text('취소',
                        style: TextStyle(fontWeight: FontWeight.w600)))
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 삭제 전부
  Future<void> deletePost(CollectionReference fbcoll, String title) async {
    final itemDocs = await fbcoll.doc(title).collection('alarmItems').get();

    for (var doc in itemDocs.docs) {
      fbcoll.doc(title).collection('alarmItems').doc(doc.id).delete();
    }

    // delete post
    fbcoll.doc(title).delete();
  }
}
