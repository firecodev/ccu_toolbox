import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/courses.dart';
import '../widgets/courses_list.dart';
import '../widgets/timetable_widget.dart';
import '../widgets/week_timetable_widget.dart';

class CourseOverviewScreen extends StatefulWidget {
  final startupIndex;

  CourseOverviewScreen(this.startupIndex);

  @override
  _CourseOverviewScreenState createState() => _CourseOverviewScreenState();
}

class _CourseOverviewScreenState extends State<CourseOverviewScreen> {
  Widget tempTimetableWidget = Container();
  final GlobalKey weekTimetableWidgetKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final courseData = Provider.of<CourseData>(context, listen: false);
      courseData.updateAllWidgets(context).then((_) {
        weekTimetableWidgetKey.currentState?.setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseData = Provider.of<CourseData>(context, listen: false);
    return DefaultTabController(
      initialIndex: widget.startupIndex,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('課程總覽'),
          centerTitle: true,
          actions: <Widget>[
            StreamBuilder<Widget>(
              stream: courseData.statusIndicatorWidgetController.stream,
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data;
                } else if (snapshot.hasError) {
                  return Text('snapshot Error');
                } else {
                  return Container();
                }
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: false,
            tabs: <Widget>[
              Tab(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.book),
                      Text('我的課程'),
                    ],
                  ),
                ),
              ),
              Tab(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.schedule),
                      Text('每日課表'),
                    ],
                  ),
                ),
              ),
              Tab(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.event_note),
                      Text('每週課表'),
                    ],
                  ),
                ),
              ),
              // Tab(
              //   child: FittedBox(
              //     fit: BoxFit.contain,
              //     child: Column(
              //       children: <Widget>[
              //         Icon(Icons.assessment),
              //         Text('學期成績'),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            CourseListWidget(),
            TimetableWidget(),
            WeekTimetableWidget(weekTimetableWidgetKey),
            // Text(
            //     '呃...不好意思，開發者是大衣小菜機，成績資料過少，沒辦法確定和分析資料格式，暫時無法開發，待資料足夠定速速補上，真的很抱歉...'),
          ],
        ),
      ),
    );
  }
}
