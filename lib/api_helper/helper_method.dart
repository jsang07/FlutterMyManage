import 'package:cloud_firestore/cloud_firestore.dart';

String formDate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();

  String year = dateTime.year.toString();
  String month = dateTime.month.toString();
  String day = dateTime.day.toString();

  String formattedData = '$year/$month/$day';

  return formattedData;
}

DateTime formTime(Timestamp timestamp) {
  // DateTime formTime =
  //     DateTime.fromMillisecondsSinceEpoch(timestamp.microsecondsSinceEpoch);

  DateTime formTime = timestamp.toDate();

  return formTime;
}
