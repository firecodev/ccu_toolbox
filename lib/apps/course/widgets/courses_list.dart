import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/courses.dart';

class CourseListWidget extends StatefulWidget {
  @override
  _CourseListWidgetState createState() => _CourseListWidgetState();
}

class _CourseListWidgetState extends State<CourseListWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final courseData = Provider.of<CourseData>(context, listen: false);
      courseData.updateCourseListWidget(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final courseData = Provider.of<CourseData>(context, listen: false);
    return StreamBuilder<Widget>(
      stream: courseData.courseListWidgetController.stream,
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data;
        } else if (snapshot.hasError) {
          return Text('snapshot Error');
        } else {
          return Container();
        }
      },
    );
  }
}
