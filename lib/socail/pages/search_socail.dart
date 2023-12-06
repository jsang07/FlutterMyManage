// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ranking/socail/bloc/social_bloc.dart';
// import 'package:ranking/socail/bloc/social_event.dart';
// import 'package:ranking/socail/bloc/social_state.dart';

// class searchSocial extends StatefulWidget {
//   const searchSocial({super.key});

//   @override
//   State<searchSocial> createState() => _searchSocialState();
// }

// class _searchSocialState extends State<searchSocial> {
//   @override
//   void initState() {
//     BlocProvider.of<SocialBloc>(context).add(ReadSocial());
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final SocialBloc socialBloc = BlocProvider.of<SocialBloc>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Padding(
//           padding: EdgeInsets.all(8.0),
//           child: TextField(
//             decoration: InputDecoration(hintText: '이름 검색'),
//             onChanged: (value) {
//               context.read<SocialBloc>().add(SearchSocial(value));
//             },
//           ),
//         ),
//       ),
//       body: BlocBuilder<SocialBloc, SocialState>(
//         builder: (context, state) {
//           if (state is SocialLoading) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (state is SocialLoaded) {
//             final socials = state.Socials;
//             return Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
//                 child: ListView.builder(
//                   itemCount: socials.length,
//                   itemBuilder: (context, index) {
//                     final social = socials[index];
//                     return Padding(
//                       padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
//                       child: Container(
//                         decoration: BoxDecoration(
//                             color: Colors.grey.shade200,
//                             borderRadius: BorderRadius.circular(10)),
//                         child: Row(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(12),
//                               child: Image.network(
//                                 social.images![0].toString(),
//                                 scale: 1.5,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             const SizedBox(
//                               width: 15,
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(social.title.toString()),
//                                 Text(social.content.toString()),
//                                 Text(social.userMail.toString()),
//                                 ElevatedButton(
//                                     onPressed: () {}, child: Text('문의하기'))
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ));
//           } else if (state is SocialOperationSuccess) {
//             socialBloc.add(ReadSocial());
//             return Container();
//           } else if (state is SocialError) {
//             return Center(
//               child: Text(state.errorMessage),
//             );
//           }
//           return Container();
//         },
//       ),
//     );
//   }
// }
