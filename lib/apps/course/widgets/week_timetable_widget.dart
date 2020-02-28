import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/courses.dart';
import '../data/timetable.dart';

class WeekTimetableWidget extends StatefulWidget {
  final GlobalKey key;
  WeekTimetableWidget(this.key);

  @override
  _WeekTimetableWidgetState createState() => _WeekTimetableWidgetState();
}

class _WeekTimetableWidgetState extends State<WeekTimetableWidget> {
  final List weekday2CH = ['一', '二', '三', '四', '五'];

  @override
  Widget build(BuildContext context) {
    final DateTime nowTime = DateTime.now();
    final courseData = Provider.of<CourseData>(context, listen: false);
    final courseList =
        Provider.of<CourseData>(context, listen: false).getCourseList();
    return Align(
      alignment: Alignment.topLeft,
      child: SingleChildScrollView(
        child: SizedBox(
          height: 495,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 30.0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 30.0,
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(
                              color: Color.fromRGBO(215, 215, 215, 1),
                              width: 1.0),
                          bottom: BorderSide(
                              color: Color.fromRGBO(215, 215, 215, 1),
                              width: 1.0),
                        ),
                      ),
                    ),
                    ...List.generate(
                      15,
                      (int index) => Container(
                        height: 30.0,
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                                color: Color.fromRGBO(215, 215, 215, 1),
                                width: 1.0),
                          ),
                          color: index.isOdd
                              ? Colors.white
                              : Color.fromRGBO(215, 215, 215, 1),
                        ),
                        child: Center(
                          child: Text('${index + 1}'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ...List.generate(
                5,
                (int index) => Expanded(
                  child: LayoutBuilder(builder: (ctx, constraints) {
                    return Column(
                      children: <Widget>[
                        Container(
                          height: 30.0,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Color.fromRGBO(215, 215, 215, 1),
                                  width: 1.0),
                            ),
                            color: index.isOdd
                                ? Color.fromRGBO(215, 215, 215, 1)
                                : Colors.white,
                          ),
                          child: Center(
                            child: Text('星期${weekday2CH[index]}'),
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              ...courseData
                                  .getCoursesByDay(weekday2CH[index])
                                  .map((course) {
                                return Positioned(
                                  top: (timeChar2Min[course[1]][0] - 420) / 2,
                                  width: constraints.maxWidth,
                                  child: Material(
                                    color: courseList[course[0]].color,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            '/apps/course/course-detail',
                                            arguments: courseList[course[0]]);
                                      },
                                      child: Container(
                                        height: (timeChar2Min[course[2]][1] -
                                                timeChar2Min[course[1]][0]) /
                                            2,
                                        child: Stack(
                                          children: <Widget>[
                                            Positioned(
                                              top: 0,
                                              left: 0,
                                              child: Text(
                                                '${timeChar2TimeString[course[1]][0]}',
                                                style: TextStyle(fontSize: 5.0),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              child: Text(
                                                '${timeChar2TimeString[course[2]][1]}',
                                                style: TextStyle(fontSize: 5.0),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Center(
                                                child: FittedBox(
                                                  fit: BoxFit.scaleDown,
                                                  child: Text(
                                                    '${courseList[course[0]].name}',
                                                    style: TextStyle(
                                                        fontSize: 10.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              if (index == nowTime.weekday - 1 &&
                                  (nowTime.hour > 6 && nowTime.hour < 22))
                                Positioned(
                                  top: ((nowTime.hour * 60 + nowTime.minute) -
                                              420) /
                                          2 -
                                      1,
                                  width: constraints.maxWidth,
                                  child: Container(
                                    height: 2.0,
                                    child: Material(
                                      elevation: 3.0,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
