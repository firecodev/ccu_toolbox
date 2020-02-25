import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:flutter_widgets/flutter_widgets.dart';

import '../functions/kiki.dart' as kiki;
import '../data/timetable.dart';
import '../models/course.dart';
import '../models/timetable.dart';
import './user_data.dart';
import '../widgets/timetable_day_widget.dart';

class CourseData with ChangeNotifier {
  Map<String, Course> _courseList = {};
  Map<String, Course> _tempCourseList = {};
  Map<String, TimetableDay> _timetable = {
    '一': TimetableDay(),
    '二': TimetableDay(),
    '三': TimetableDay(),
    '四': TimetableDay(),
    '五': TimetableDay(),
  };

  StreamController<Widget> courseListWidgetController =
      StreamController.broadcast();
  StreamController<Widget> timetableWidgetController =
      StreamController.broadcast();
  StreamController<Widget> statusIndicatorWidgetController =
      StreamController.broadcast();

  ItemScrollController _scrollController = ItemScrollController();

  Future<void> updateAllWidgets(BuildContext context) async {
    updateStatusIndicatorWidget(true, false, context);
    int _hasError = 0;
    _tempCourseList = {};

    try {
      await updateCoursesFromEcourse(context);
    } catch (error) {
      if (error == 2 || error == 3) {
        updateStatusIndicatorWidget(false, true, context);
        Navigator.of(context).pushReplacementNamed('/apps/course/auth',
            arguments: '/apps/course');
        return;
      } else {
        _hasError++;
      }
    }

    try {
      await updateCoursesFromKiki(context);
    } catch (error) {
      _hasError++;
    }

    if (_hasError < 2) {
      _courseList = _tempCourseList;
      buildTimetableFromCourseList();
      updateCourseListWidget(context);
      updateTimetableWidget();
    }

    if (_hasError == 0) {
      updateStatusIndicatorWidget(false, false, context);
    } else {
      updateStatusIndicatorWidget(false, true, context);
    }
  }

  void updateStatusIndicatorWidget(
      bool isLoading, bool loadFailed, BuildContext context) {
    if (isLoading) {
      statusIndicatorWidgetController.sink.add(Center(
        child: IconButton(
          icon: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ),
          enableFeedback: false,
          onPressed: null,
          tooltip: '載入中',
        ),
      ));
    } else {
      statusIndicatorWidgetController.sink.add(IconButton(
        icon: Icon(loadFailed ? Icons.cloud_off : Icons.cloud_done),
        onPressed: () {
          updateAllWidgets(context);
        },
        tooltip: loadFailed ? '載入時發生錯誤' : '載入完成',
      ));
    }
  }

  void updateCourseListWidget(BuildContext context) {
    Widget tempWidget;

    final List<Course> courseList = _courseList.values.toList();
    tempWidget = Container(
      // height: constraints.maxHeight,
      child: ListView.builder(
        itemCount: _courseList.length,
        itemBuilder: (ctx, index) {
          final thisCourse = courseList[index];
          return Column(
            children: <Widget>[
              ListTile(
                  leading: CircleAvatar(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: FittedBox(
                        child: Text(thisCourse.courseType),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  title: Text(thisCourse.name),
                  subtitle:
                      Text('${thisCourse.credit} 學分 / ${thisCourse.teacher}'),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        '/apps/course/course-detail',
                        arguments: thisCourse);
                  }),
              Divider(
                height: 1,
                thickness: 1,
              ),
            ],
          );
        },
      ),
    );

    courseListWidgetController.sink.add(tempWidget);
  }

  void updateTimetableWidget() {
    Widget tempWidget;

    List<TimetableDayWidget> timetableDayWidgetList = _timetable
        .map((day, timetableDay) {
          return MapEntry(day, TimetableDayWidget(day, _courseList));
        })
        .values
        .toList();

    final int weekdayIndex = DateTime.now().weekday - 1;
    tempWidget = ScrollablePositionedList.builder(
      itemScrollController: _scrollController,
      initialScrollIndex: weekdayIndex < 5 ? weekdayIndex : 0,
      itemCount: timetableDayWidgetList.length,
      itemBuilder: (context, index) {
        return timetableDayWidgetList[index];
      },
    );

    timetableWidgetController.sink.add(tempWidget);

    timetableWidgetDoScroll();
  }

  void timetableWidgetDoScroll() {
    final int weekdayIndex = DateTime.now().weekday - 1;
    if (_scrollController.isAttached) {
      if (weekdayIndex < 5) {
        _scrollController.scrollTo(
          index: weekdayIndex,
          curve: Curves.ease,
          duration: Duration(milliseconds: 500),
        );
      }
    }
  }

  Future<void> updateCoursesFromEcourse(BuildContext context) async {
    try {
      final token = await Provider.of<UserData>(context, listen: false)
          .getEcourse2Token();

      // throw 'network error'; // this is for debugging

      final restUrl = 'https://ecourse2.ccu.edu.tw/webservice/rest/server.php';
      final response = await http.post(restUrl, body: {
        'classification': 'inprogress',
        'moodlewssettingfilter': 'true',
        'moodlewssettingfileurl': 'true',
        'moodlewsrestformat': 'json',
        'wsfunction':
            'core_course_get_enrolled_courses_by_timeline_classification',
        'wstoken': token,
      });
      final coursesData =
          jsonDecode(response.body)['courses']; //List<Map<String, Object>>
      coursesData.forEach((cour) {
        _tempCourseList.update(
            cour['idnumber'],
            (existingCourse) => Course(
                  moodleId: cour['id'],
                  idnumber: cour['idnumber'].toString(),
                  name: cour['fullname'].toString(),
                  category: cour['coursecategory'].toString(),
                  id: existingCourse.id,
                  clas: existingCourse.clas,
                  teacher: existingCourse.teacher,
                  credit: existingCourse.credit,
                  courseType: existingCourse.courseType,
                  period: existingCourse.period,
                  location: existingCourse.location,
                ),
            ifAbsent: () => Course(
                  moodleId: cour['id'],
                  idnumber: cour['idnumber'],
                  name: cour['fullname'],
                  category: cour['coursecategory'],
                ));
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateCoursesFromKiki(BuildContext context) async {
    try {
      // get year and term
      String term;
      String year;
      if (DateTime.now().month < 8) {
        year = (DateTime.now().year - 1912).toString();
      } else {
        year = (DateTime.now().year - 1911).toString();
      }
      if (DateTime.now().month > 1 && DateTime.now().month < 8) {
        term = '2';
      } else {
        term = '1';
      }

      // get sessionid
      final usrAndPwd =
          Provider.of<UserData>(context, listen: false).getCurrentUsrAndPwd();
      final username = usrAndPwd['username'];
      final password = usrAndPwd['password'];
      final sessionid = await kiki.getSessionid(username, password);

      // throw 'network error'; // this is for debugging

      // get courses data
      final viewUrl =
          'https://kiki.ccu.edu.tw/~ccmisp06/cgi-bin/class_new/Selected_View00.cgi?year=$year&term=$term&session_id=$sessionid';
      final viewResponse = await http.get(viewUrl);
      final viewResponseUtf8 = utf8.decode(viewResponse.bodyBytes);

      // logout
      kiki.logout(sessionid);

      // parse course data
      var document = parse(viewResponseUtf8);
      var coursesDOM = document.body.children[0]
          .getElementsByTagName('table')[1]
          .children[0];
      int courseNum = coursesDOM.children.length - 1;
      String tempId = '',
          tempClass = '',
          tempName = '',
          tempTeacher = '',
          tempCredit = '',
          tempCourseType = '',
          tempPeriod = '',
          tempLocation = '',
          tempIdnumber = '';
      for (int i = 1; i <= courseNum; i++) {
        tempId = coursesDOM.children[i].children[1].children[0].innerHtml;
        tempClass = coursesDOM.children[i].children[2].children[0].innerHtml;
        tempName = coursesDOM.children[i].children[3].children[0].innerHtml;
        tempTeacher = coursesDOM.children[i].children[4].children[0].innerHtml;
        tempCredit = coursesDOM.children[i].children[5].children[0].innerHtml;
        tempCourseType =
            coursesDOM.children[i].children[6].children[0].innerHtml;
        tempPeriod =
            coursesDOM.children[i].children[7].children[0].innerHtml.trimLeft();
        tempLocation = coursesDOM.children[i].children[8].children[0].innerHtml;
        tempIdnumber = year + '_' + term + '_' + tempId + '_' + tempClass;

        _tempCourseList.update(
            tempIdnumber,
            (existingCourse) => Course(
                  moodleId: existingCourse.moodleId,
                  idnumber: existingCourse.idnumber,
                  name: existingCourse.name,
                  category: existingCourse.category,
                  id: tempId,
                  clas: tempClass,
                  teacher: tempTeacher,
                  credit: tempCredit,
                  courseType: tempCourseType,
                  period: tempPeriod,
                  location: tempLocation,
                ),
            ifAbsent: () => Course(
                  idnumber: tempIdnumber,
                  name: tempName,
                  id: tempId,
                  clas: tempClass,
                  teacher: tempTeacher,
                  credit: tempCredit,
                  courseType: tempCourseType,
                  period: tempPeriod,
                  location: tempLocation,
                ));
      }
    } catch (error) {
      throw (error);
    }
  }

  void buildTimetableFromCourseList() {
    final divideDaysRegex = RegExp(r'[^a-zA-Z\d\s,]([A-J]|\d|,)+',
        multiLine: true, unicode: true); // 三4,5
    final divideChineseRegex =
        RegExp(r'[^a-zA-Z\d,]', multiLine: true, unicode: true); // 三
    final divideTimeRegex =
        RegExp(r'[A-J\d]+', multiLine: true, unicode: true); // 4
    _courseList.forEach((idnumber, course) {
      divideDaysRegex.allMatches(course.period).forEach((day) {
        final String dayAndTime = day.group(0);
        final String chineseDay =
            divideChineseRegex.allMatches(dayAndTime).toList()[0].group(0);
        divideTimeRegex.allMatches(dayAndTime).forEach((timeRegex) {
          if (_timetable.containsKey(chineseDay)) {
            if (_timetable[chineseDay].time.containsKey(timeRegex.group(0))) {
              _timetable[chineseDay]
                  .time
                  .update(timeRegex.group(0), (_) => idnumber);
            }
          }
        });
      });
    });
  }

  List<List<String>> getCoursesByDay(String day) {
    var targetDayData = _timetable[day].time;
    List<List<String>> tempResult = [];
    String tempStartTime = '00:00';
    String tempEndTime = '00:00';
    String tempPreIdnumberNum = '';
    String tempPreIdnumberAlpha = '';
    targetDayData.forEach((time, idnumber) {
      if (time.contains(new RegExp(r'\d+'))) {
        if (idnumber.isNotEmpty) {
          if (idnumber != tempPreIdnumberNum) {
            tempStartTime = char2Time[time][0];
            tempEndTime = char2Time[time][1];
            tempResult.add([idnumber, tempStartTime, tempEndTime]);
          } else {
            tempEndTime = char2Time[time][1];
            tempResult.removeLast();
            tempResult.add([idnumber, tempStartTime, tempEndTime]);
          }
        }
        tempPreIdnumberNum = idnumber;
      } else {
        if (idnumber.isNotEmpty) {
          if (idnumber != tempPreIdnumberAlpha) {
            tempStartTime = char2Time[time][0];
            tempEndTime = char2Time[time][1];
            tempResult.add([idnumber, tempStartTime, tempEndTime]);
          } else {
            tempEndTime = char2Time[time][1];
            tempResult.removeLast();
            tempResult.add([idnumber, tempStartTime, tempEndTime]);
          }
        }
        tempPreIdnumberAlpha = idnumber;
      }
    });
    return tempResult;
  }
}
