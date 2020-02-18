import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../functions/ecourse2.dart' as ecourse2;
import '../providers/user_data.dart';
import '../models/assignment.dart';

class AssignmentsWidget extends StatefulWidget {
  final int courseid;

  AssignmentsWidget(this.courseid);
  @override
  _AssignmentsWidgetState createState() => _AssignmentsWidgetState();
}

class _AssignmentsWidgetState extends State<AssignmentsWidget>
    with AutomaticKeepAliveClientMixin {
  List<Widget> _assignmentWidgetList = [];
  bool _isloading = false;
  bool _loadFailed = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _isloading = true;
    _refresh();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> _refresh() async {
    try {
      final String token = await Provider.of<UserData>(context, listen: false)
          .getEcourse2Token();
      final assignmentList = await _getAssignments(widget.courseid, token);
      List<Widget> tempAssignmentWidgetList = [];
      assignmentList.forEach((assignment) {
        tempAssignmentWidgetList.add(Container(
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
          child: Card(
            elevation: 3,
            child: ListTile(
              title: Text(
                assignment.name,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text('截止日 ' +
                  DateFormat('yyyy-MM-dd HH:mm:ss').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          assignment.duedate * 1000))),
              onTap: () {
                Navigator.of(context).pushNamed(
                    '/apps/course/course-detail/assignment-detail',
                    arguments: assignment);
              },
            ),
          ),
        ));
      });
      _assignmentWidgetList = tempAssignmentWidgetList;
      setState(() {
        _loadFailed = false;
        _isloading = false;
      });
    } catch (error) {
      setState(() {
        _loadFailed = true;
        _isloading = false;
      });
    }
  }

  List<Assignment> assignments = [];

  Future<List<Assignment>> _getAssignments(int courseid, String token) async {
    try {
      assignments = await ecourse2.getAssignments(courseid, token);

      return assignments;
    } catch (error) {
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _isloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _loadFailed
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.cloud_off),
                  Text('載入時發生錯誤'),
                ],
              )
            : _assignmentWidgetList.isEmpty
                ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.bubble_chart,
                          size: 50.0,
                          color: Colors.grey,
                        ),
                        Text('目前沒有作業哦~',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _assignmentWidgetList.length,
                    itemBuilder: (ctx, index) => _assignmentWidgetList[index],
                  );
  }
}
