import 'package:flutter/foundation.dart';

class Course {
  Course({
    @required this.idnumber, //108_1_4101033_01
    this.moodleId = 0, //6028
    this.name = 'Unknown', //程式設計(一)
    this.category = 'Unknown', //資訊工程學系
    this.id = 'Unknown', //4101033
    this.clas = 'Unknown', //01
    this.teacher = 'Unknown', //吳昇
    this.credit = 'Unknown', //3
    this.courseType = 'Unknown', //必修
    this.location = 'Unknown', //工學院A館101
    this.period = 'Unknown', //二E 四E
  });

  final String idnumber;
  int moodleId;
  String name;
  String category;
  String id;
  String clas;
  String teacher;
  String credit;
  String courseType;
  String location;
  String period;
}
