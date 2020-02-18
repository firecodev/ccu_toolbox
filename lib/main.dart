import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import './apps/course/providers/user_data.dart';
import './global/screens/main_screen.dart';
import './global/screens/others_screen.dart';
import './apps/course/screens/auth_screen.dart';

import './apps/setting/screens/setting_screen.dart';
import './apps/about/screens/about_screen.dart';
import './apps/calendar/screens/calendar_screen.dart';
import './apps/course/providers/courses.dart';
import './apps/course/screens/course_screen.dart';
import './apps/course/screens/course_detail_screen.dart';
import './apps/course/screens/discussion_detail_screen.dart';
import './apps/course/screens/assignment_detail_screen.dart';
import './apps/transport/main.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserData>(create: (_) => UserData()),
        ChangeNotifierProvider<CourseData>(create: (_) => CourseData()),
      ],
      child: MaterialApp(
        title: 'CCU Toolbox',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainScreen(),
        routes: {
          '/others': (ctx) => OthersScreen(),
          '/apps/course/auth': (ctx) => AuthScreen(),
          '/apps/course': (ctx) => CourseScreen(),
          '/apps/course/course-detail': (ctx) => CourseDetailScreen(),
          '/apps/course/course-detail/discussion-detail': (ctx) =>
              DiscussionDetailScreen(),
          '/apps/course/course-detail/assignment-detail': (ctx) =>
              AssignmentDetailScreen(),
          '/apps/transport': (ctx) => TransportMain(),
          '/apps/calendar': (ctx) => CalendarScreen(),
          '/apps/setting': (ctx) => SettingScreen(),
          '/apps/about': (ctx) => AboutScreen(),
        },
      ),
    );
  }
}
