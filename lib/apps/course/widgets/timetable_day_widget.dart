import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/courses.dart';
import '../data/timetable.dart';

class TimetableDayWidget extends StatelessWidget {
  final String day;
  final Map<String, Course> courseList;

  TimetableDayWidget(this.day, this.courseList);

  @override
  Widget build(BuildContext context) {
    final coursesList =
        Provider.of<CourseData>(context, listen: false).getCoursesByDay(day);
    List<Widget> widgetsList = [];
    coursesList.forEach((idAndTime) {
      widgetsList.add(
        Card(
          elevation: 5,
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${timeChar2TimeString[idAndTime[1]][0]}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                      Container(
                        width: 50.0,
                        child: Divider(
                          height: 10,
                          thickness: 1,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${timeChar2TimeString[idAndTime[2]][1]}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            title: Text('${courseList[idAndTime[0]].name}'),
            subtitle: Text('${courseList[idAndTime[0]].location}'),
            onTap: () {
              Navigator.of(context).pushNamed('/apps/course/course-detail',
                  arguments: courseList[idAndTime[0]]);
            },
          ),
        ),
      );
    });
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 13.0),
      child: Column(
        children: <Widget>[
          Divider(
            height: 1,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              '星期$day',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          ...widgetsList,
        ],
      ),
    );
  }
}
