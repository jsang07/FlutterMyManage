import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  void signUp() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (passwordTextController.text != confirmPasswordTextController.text) {
      Navigator.pop(context);
      displayMessage('password do not match');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailTextController.text,
              password: passwordTextController.text);
      FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email)
          .set({
        'username': emailTextController.text.split('@')[0],
      });

      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      displayMessage(e.code);
    }
  }

  void displayMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.08),
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.15,
                  ),
                  Icon(
                    Icons.person_add_alt_1,
                    size: width * 0.3,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  const Text('가입할 정보를 입력해주세요'),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  TextField(
                      controller: emailTextController,
                      decoration: InputDecoration(
                          hintText: '이메일',
                          contentPadding: const EdgeInsets.only(left: 20),
                          filled: true,
                          fillColor: Colors.grey[200],
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(30)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(30))),
                      obscureText: false),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                      controller: passwordTextController,
                      decoration: InputDecoration(
                          hintText: '비밀번호',
                          contentPadding: const EdgeInsets.only(left: 20),
                          filled: true,
                          fillColor: Colors.grey[200],
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(30)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(30))),
                      obscureText: true),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                      controller: confirmPasswordTextController,
                      decoration: InputDecoration(
                          hintText: '비밀번호 확인',
                          contentPadding: const EdgeInsets.only(left: 20),
                          filled: true,
                          fillColor: Colors.grey[200],
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(30)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(30))),
                      obscureText: true),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: signUp,
                    child: Container(
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                        child: Text(
                          '회원 가입',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('이미 계정이 있으신가요?'),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            '로그인 페이지로',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
