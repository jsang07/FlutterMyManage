import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mymanage/socail/model/social_model.dart';

class SocialService {
  final CollectionReference socialCollection =
      FirebaseFirestore.instance.collection('container');

  Stream<List<Social>> get() {
    return socialCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Social(
            id: doc.id,
            title: data['title'],
            content: data['content'],
            userMail: data['userMail'],
            userUid: data['userUid'],
            images: data['images'],
            timestamp: Timestamp.now());
      }).toList();
    });
  }

  Future<void> add(Social social) {
    return socialCollection.add({
      'title': social.title,
      'content': social.content,
      'userMail': social.userMail,
      'userUid': social.userUid,
      'images': social.images,
      'time': Timestamp.now()
    });
  }

  Future<void> update(Social social) {
    return socialCollection.doc(social.id).update({
      'title': social.title,
      'content': social.content,
    });
  }

  Future<void> delete(String socialId) {
    return socialCollection.doc(socialId).delete();
  }
}
