import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

import '../functions/ecourse2.dart' as ecourse2;
import '../models/assignment.dart';
import '../models/attachment.dart';
import '../providers/user_data.dart';

class AssignmentDetailScreen extends StatelessWidget {
  List<Widget> introAttachmentsWidgetList(
      List<Attachment> attachments, String token) {
    List<Widget> tempWidgetList = [];
    attachments.forEach((attachment) {
      if (attachment.mimetype.contains('image')) {
        tempWidgetList.add(GestureDetector(
          onTap: () {
            urlLauncher.launch('${attachment.fileurl}?token=$token');
          },
          child: Image.network('${attachment.fileurl}?token=$token'),
        ));
      } else {
        tempWidgetList.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: GestureDetector(
            onTap: () {
              urlLauncher.launch('${attachment.fileurl}?token=$token');
            },
            child: Text(
              '${attachment.filename}',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blue,
              ),
            ),
          ),
        ));
      }
    });
    return tempWidgetList;
  }

  @override
  Widget build(BuildContext context) {
    final Assignment assignment = ModalRoute.of(context).settings.arguments;
    final token = Provider.of<UserData>(context).getCurrentEcourse2Token();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('詳細資訊'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  assignment.name,
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      DateFormat('開始日期: yyyy年MM月dd日 HH:mm:ss').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              assignment.allowsubmissionsfromdate * 1000)),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      DateFormat('截止日期: yyyy年MM月dd日 HH:mm:ss').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              assignment.duedate * 1000)),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                height: 15.0,
                thickness: 1.0,
              ),
              Container(
                child: html.Html(
                  data: assignment.intro,
                  onLinkTap: (url) {
                    urlLauncher.launch(url);
                  },
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: introAttachmentsWidgetList(
                    assignment.introattachments, token),
              ),
              SizedBox(
                height: 40.0,
              ),
              Text(
                '回饋',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey,
                ),
              ),
              Divider(
                height: 15.0,
                thickness: 1.0,
              ),
              AssignmentFeedbackWidget(assignment.id),
            ],
          ),
        ),
      ),
    );
  }
}

class AssignmentFeedbackWidget extends StatefulWidget {
  final int assignid;

  AssignmentFeedbackWidget(this.assignid);

  @override
  _AssignmentFeedbackWidgetState createState() =>
      _AssignmentFeedbackWidgetState();
}

class _AssignmentFeedbackWidgetState extends State<AssignmentFeedbackWidget> {
  bool _isloading = false;
  bool _loadFailed = false;
  bool _hasFeedback = false;
  List<Widget> widgetList = [];

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
    List<Widget> tempWidgetList = [];
    try {
      final String token =
          await Provider.of<UserData>(context, listen: false).getEcourse2Token();
      final int userid =
          await Provider.of<UserData>(context, listen: false).getEcourse2Userid(token);
      final feedback =
          await ecourse2.getAssignmentFeedback(widget.assignid, userid, token);

      tempWidgetList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Text(
          DateFormat('評分時間: yyyy年MM月dd日 HH:mm:ss').format(
              DateTime.fromMillisecondsSinceEpoch(feedback.gradeddate * 1000)),
          style: TextStyle(color: Colors.grey),
        ),
      ));

      tempWidgetList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Text(
          '分數: ${feedback.gradefordisplay}',
          style: TextStyle(color: Colors.grey),
        ),
      ));

      tempWidgetList.add(SizedBox(height: 30.0));

      tempWidgetList.add(Container(
        child: html.Html(
          data: feedback.feedbackComment,
          onLinkTap: (url) {
            urlLauncher.launch(url);
          },
        ),
      ));

      setState(() {
        _hasFeedback = true;
        _loadFailed = false;
        _isloading = false;
      });

      widgetList = tempWidgetList;
    } catch (error) {
      if (error == 131) {
        setState(() {
          _hasFeedback = false;
          _loadFailed = false;
          _isloading = false;
        });
      } else {
        setState(() {
          _hasFeedback = false;
          _loadFailed = true;
          _isloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : _hasFeedback
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widgetList,
              )
            : _loadFailed
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.cloud_off,
                        color: Colors.grey,
                      ),
                      Text(
                        '載入時發生錯誤',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )
                : Text(
                    '尚未評分',
                    style: TextStyle(color: Colors.grey),
                  );
  }
}
