import 'package:hive_flutter/hive_flutter.dart';
part 'model_class.g.dart';
@HiveType(typeId: 0)
class UserModel {
  int? userId;
  int? id;
  String? title;
  String? body;

  UserModel({this.userId, this.id, this.title, this.body});

  UserModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}
