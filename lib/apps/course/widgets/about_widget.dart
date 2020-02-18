import 'package:flutter/material.dart';

import '../models/course.dart';

class AboutWidget extends StatelessWidget {
  final Course course;

  AboutWidget(this.course);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: FittedBox(
                  child: Text('${course.courseType}'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            title: Text(
              '${course.name}',
              style: TextStyle(fontSize: 30.0),
            ),
            subtitle: Text('${course.id}_${course.clas}'),
          ),
          Divider(),
          info('教師', '${course.teacher}'),
          Divider(),
          info('時間', '${course.period}'),
          Divider(),
          info('教室', '${course.location}'),
          Divider(),
          info('學分', '${course.credit}'),
          Divider(),
          info('系所', '${course.category}'),
        ],
      ),
    );
  }

  Widget info(String title, String content) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              title,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              content,
              style: TextStyle(fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}
