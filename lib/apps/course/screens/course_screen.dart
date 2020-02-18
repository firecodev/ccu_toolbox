import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './course_overview_screen.dart';
import '../providers/user_data.dart';

class CourseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
        future: Provider.of<UserData>(context, listen: false)
            .getCourseStartupIndex(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return CourseOverviewScreen(snapshot.data);
          } else if (snapshot.hasError) {
            return Scaffold(body: Text('error'));
          } else {
            return Scaffold();
          }
        });
  }
}
