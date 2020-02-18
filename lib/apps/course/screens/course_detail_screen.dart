import 'package:flutter/material.dart';

import '../widgets/discussions_widget.dart';
import '../widgets/scores_widget.dart';
import '../widgets/assignments_widget.dart';
import '../widgets/about_widget.dart';
import '../models/course.dart';

class CourseDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Course course = ModalRoute.of(context).settings.arguments;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(course.name),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: false,
            tabs: <Widget>[
              Tab(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.message),
                      Text('公告'),
                    ],
                  ),
                ),
              ),
              Tab(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.assessment),
                      Text('成績'),
                    ],
                  ),
                ),
              ),
              Tab(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.description),
                      Text('作業'),
                    ],
                  ),
                ),
              ),
              // Tab(
              //   child: FittedBox(
              //     fit: BoxFit.contain,
              //     child: Column(
              //       children: <Widget>[
              //         Icon(Icons.people),
              //         Text('點名'),
              //       ],
              //     ),
              //   ),
              // ),
              Tab(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.info),
                      Text('關於'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            DiscussionsWidget(course.moodleId),
            ScoresWidget(course.moodleId),
            AssignmentsWidget(course.moodleId),
            // Text('點名'),
            AboutWidget(course),
          ],
        ),
      ),
    );
  }
}
