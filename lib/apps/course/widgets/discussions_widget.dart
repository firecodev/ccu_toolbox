import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../functions/ecourse2.dart' as ecourse2;
import '../providers/user_data.dart';
import '../models/discussion.dart';

class DiscussionsWidget extends StatefulWidget {
  final int courseid;

  DiscussionsWidget(this.courseid);

  @override
  _DiscussionsWidgetState createState() => _DiscussionsWidgetState();
}

class _DiscussionsWidgetState extends State<DiscussionsWidget>
    with AutomaticKeepAliveClientMixin {
  List<Widget> _discussionWidgetList = [];
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
      final discussionList = await _getDiscussions(widget.courseid, token);
      List<Discussion> pinnedDiscussions = [];
      List<Discussion> generalDiscussions = [];
      discussionList.forEach((discussion) {
        if (discussion.pinned) {
          pinnedDiscussions.add(discussion);
        } else {
          generalDiscussions.add(discussion);
        }
      });
      List<Widget> tempDiscussionWidgetList = [];
      if (pinnedDiscussions.isNotEmpty) {
        tempDiscussionWidgetList.add(
          Row(
            children: <Widget>[
              Icon(
                Icons.flag,
                color: Colors.grey,
              ),
              Text(
                '置頂',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
        pinnedDiscussions.forEach((discussion) {
          tempDiscussionWidgetList.add(Container(
            margin: const EdgeInsets.symmetric(vertical: 5.0),
            child: Card(
              elevation: 3,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(discussion.userpictureurl),
                ),
                title: Text(
                  discussion.name,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(DateFormat('yyyy-MM-dd').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        discussion.time * 1000))),
                onTap: () {
                  Navigator.of(context).pushNamed(
                      '/apps/course/course-detail/discussion-detail',
                      arguments: discussion);
                },
              ),
            ),
          ));
        });
        tempDiscussionWidgetList.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(thickness: 1.0, height: 1.0),
          ),
        );
      }
      generalDiscussions.forEach((discussion) {
        tempDiscussionWidgetList.add(Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          child: Card(
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(discussion.userpictureurl),
              ),
              title: Text(
                discussion.name,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(DateFormat('yyyy-MM-dd').format(
                  DateTime.fromMillisecondsSinceEpoch(discussion.time * 1000))),
              onTap: () {
                Navigator.of(context).pushNamed(
                    '/apps/course/course-detail/discussion-detail',
                    arguments: discussion);
              },
            ),
          ),
        ));
      });

      _discussionWidgetList = tempDiscussionWidgetList;
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

  List<Discussion> _discussions = [];

  Future<List<Discussion>> _getDiscussions(int courseid, String token) async {
    try {
      _discussions = await ecourse2.getDiscussions(courseid, token);

      return _discussions;
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
            : _discussionWidgetList.isEmpty
                ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.bubble_chart,
                          size: 50.0,
                          color: Colors.grey,
                        ),
                        Text('目前沒有公告哦~',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 8.0),
                    itemCount: _discussionWidgetList.length,
                    itemBuilder: (ctx, index) => _discussionWidgetList[index],
                  );
  }
}
