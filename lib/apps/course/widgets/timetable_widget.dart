import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/courses.dart';

class TimetableWidget extends StatefulWidget {
  @override
  _TimetableWidgetState createState() => _TimetableWidgetState();
}

class _TimetableWidgetState extends State<TimetableWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final courseData = Provider.of<CourseData>(context, listen: false);
        courseData.updateTimetableWidget();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final courseData = Provider.of<CourseData>(context, listen: false);
    return StreamBuilder<Widget>(
      stream: courseData.timetableWidgetController.stream,
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
