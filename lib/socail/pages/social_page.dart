import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mymanage/socail/bloc/social_bloc.dart';
import 'package:mymanage/socail/bloc/social_event.dart';
import 'package:mymanage/socail/bloc/social_state.dart';
import 'package:mymanage/socail/pages/social_add.dart';
import 'package:mymanage/socail/pages/social_detail.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({Key? key}) : super(key: key);

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    BlocProvider.of<SocialBloc>(context).add(ReadSocial());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SocialBloc socialBloc = BlocProvider.of<SocialBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('너희들은 무슨 관리해?'),
      ),
      body: BlocBuilder<SocialBloc, SocialState>(
        builder: (context, state) {
          if (state is SocialLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SocialLoaded) {
            final socials = state.Socials;
            return Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: GridView.builder(
                  itemCount: socials.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 10,
                    childAspectRatio: 5 / 7,
                  ),
                  itemBuilder: (context, index) {
                    final social = socials[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SocialDetail(
                                    title: social.title.toString(),
                                    content: social.content.toString(),
                                    user: social.userMail.toString(),
                                    postId: social.id.toString(),
                                    time: social.timestamp.toString(),
                                    img: social.images!)));
                      },
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            social.images![0].toString(),
                            fit: BoxFit.cover,
                          )),
                    );
                  },
                ));
          } else if (state is SocialOperationSuccess) {
            socialBloc.add(ReadSocial());
            return Container();
          } else if (state is SocialError) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.grey.shade900,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SocialAdd(),
              ));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
