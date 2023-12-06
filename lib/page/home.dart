import 'package:flutter/material.dart';
import 'package:mymanage/manage/manage_page.dart';
import 'package:mymanage/socail/pages/social_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int _currentPageIndex;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
  }

  Widget? _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
        return const ManagePage();
      case 1:
        return SocialPage();
    }
    return null;
  }

  Widget _bottomWidget() {
    return BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        onTap: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        currentIndex: _currentPageIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.black,
        selectedFontSize: 13,
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(
                  Icons.home_rounded,
                  color: Colors.black,
                )),
            label: '나의 관리',
            activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(Icons.home_rounded, color: Colors.black)),
          ),
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(
                  Icons.chat_bubble_rounded,
                  color: Colors.black,
                )),
            label: '남의 관리',
            activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(Icons.chat_bubble_rounded, color: Colors.black)),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          final value = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('확인'),
                content: const Text('앱을 종료하시겠습니까?'),
                actions: [
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: const Text('네')),
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black),
                      child: const Text('아니요')),
                ],
              );
            },
          );
          if (value != null) {
            return Future.value(value);
          } else {
            return Future.value(false);
          }
        },
        child: Scaffold(
          body: _bodyWidget(),
          bottomNavigationBar: _bottomWidget(),
        ),
      ),
    );
  }
}
