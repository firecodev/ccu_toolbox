import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart' as html;
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

import '../models/discussion.dart';
import '../models/attachment.dart';
import '../providers/user_data.dart';

class DiscussionDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Discussion discussion = ModalRoute.of(context).settings.arguments;
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
                  discussion.name,
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 13.0,
                    backgroundImage: NetworkImage(discussion.userpictureurl),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      discussion.userfullname,
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
                      DateFormat('yyyy年MM月dd日 HH:mm:ss').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              discussion.time * 1000)),
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
                  data: discussion.message,
                  onLinkTap: (url) {
                    urlLauncher.launch(url);
                  },
                ),
              ),
              Column(
                children: attachmentsWidgetList(discussion.attachments, token),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> attachmentsWidgetList(
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
}
