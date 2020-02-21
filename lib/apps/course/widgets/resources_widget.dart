import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:flutter_svg/flutter_svg.dart';

import '../functions/ecourse2.dart' as ecourse2;
import '../providers/user_data.dart';
import '../models/resource.dart';
import '../../../global/data/mime2svg.dart';

class ResourcesWidget extends StatefulWidget {
  final int courseid;

  ResourcesWidget(this.courseid);

  @override
  _ResourcesWidgetState createState() => _ResourcesWidgetState();
}

class _ResourcesWidgetState extends State<ResourcesWidget>
    with AutomaticKeepAliveClientMixin {
  List<Widget> _resourceWidgetList = [];
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

  String filesizeFormat(int filesize) {
    double tempSize = filesize.toDouble();
    String unit = 'B';
    if (tempSize > 1024) {
      unit = 'KB';
      tempSize /= 1024;
    }
    if (tempSize > 1024) {
      unit = 'MB';
      tempSize /= 1024;
    }
    if (tempSize > 1024) {
      unit = 'GB';
      tempSize /= 1024;
    }
    if (tempSize > 1024) {
      unit = 'TB';
      tempSize /= 1024;
    }
    return '${tempSize.toStringAsFixed(1)} $unit';
  }

  Future<void> _refresh() async {
    try {
      final String token = await Provider.of<UserData>(context, listen: false)
          .getEcourse2Token();
      final filesInTopics =
          await _getResourceListInTopics(widget.courseid, token);
      List<Widget> tempResourceWidgetList = [];
      ///////////////////////////////////////
      filesInTopics.forEach((topicAndResources) {
        String topic = topicAndResources[0];
        List<Resource> resourceList = topicAndResources[1];
        if (resourceList.isNotEmpty) {
          List<ListTile> tempSubResourceWidgetList = [];
          resourceList.forEach((resource) {
            tempSubResourceWidgetList.add(
              ListTile(
                title: Text("${resource.name}"),
                subtitle: Text(
                  '${resource.attachment.filename}',
                  overflow: TextOverflow.ellipsis,
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: mime2svg[resource.attachment.mimetype] == null
                      ? Icon(
                          Icons.insert_drive_file,
                          color: Colors.grey,
                        )
                      : SvgPicture.asset(
                          mime2svg[resource.attachment.mimetype],
                          width: 24.0,
                          height: 24.0,
                        ),
                ),
                trailing: Text(
                  filesizeFormat(resource.attachment.filesize),
                  style: TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  urlLauncher
                      .launch('${resource.attachment.fileurl}&token=$token');
                },
              ),
            );
          });

          tempResourceWidgetList.add(
            ExpansionTile(
              title: Text("$topic"),
              initiallyExpanded: true,
              children: tempSubResourceWidgetList,
            ),
          );
        }
      });
      ///////////////////////////////////////
      _resourceWidgetList = tempResourceWidgetList;
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

  List<List<dynamic>> _resourcesInTopics = [];

  Future<List<List<dynamic>>> _getResourceListInTopics(
      int courseid, String token) async {
    try {
      _resourcesInTopics = await ecourse2.getResourceListInTopics(
          courseid, token); // List<List<[String, List<Resource>]>>

      return _resourcesInTopics;
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
            : _resourceWidgetList.isEmpty
                ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.bubble_chart,
                          size: 50.0,
                          color: Colors.grey,
                        ),
                        Text('目前沒有檔案哦~',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _resourceWidgetList.length,
                    itemBuilder: (ctx, index) => _resourceWidgetList[index],
                  );
  }
}
