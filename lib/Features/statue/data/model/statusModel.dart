import 'package:cloud_firestore/cloud_firestore.dart';

class StatueModel {
  final String id;
  final String? caption;
  final String userid;
  final String? imageurl;
  final String? videourl;
  final DateTime time;
  final List<dynamic> views;
  final String userimage, username;

  factory StatueModel.formJson(Map<String, dynamic> json) {
    return StatueModel(
        id: json['id'],
        caption: json['caption'],
        userid: json['userid'],
        imageurl: json['imageurl'],
        videourl: json['videourl'],
        time: (json['date'] as Timestamp).toDate(),
        views: json['views'],
        userimage: json['userimage'],
        username: json['username']);
  }

  Map<String, dynamic> toJson(StatueModel model) {
    return {
      'id': model.id,
      'caption': model.caption,
      'userid': model.userid,
      'imageurl': model.imageurl,
      'videourl': model.videourl,
      'date': model.time,
      'views': model.views,
      'userimage': model.userimage,
      'username': model.username
    };
  }

  StatueModel(
      {required this.id,
      required this.time,
      required this.caption,
      required this.userid,
      required this.imageurl,
      required this.videourl,
      required this.views,
      required this.userimage,
      required this.username});
}
