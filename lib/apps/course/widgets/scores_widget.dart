import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../functions/ecourse2.dart' as ecourse2;
import '../providers/user_data.dart';
import '../models/score.dart';

class ScoresWidget extends StatefulWidget {
  final int courseid;

  ScoresWidget(this.courseid);

  @override
  _ScoresWidgetState createState() => _ScoresWidgetState();
}

class _ScoresWidgetState extends State<ScoresWidget>
    with AutomaticKeepAliveClientMixin {
  List<Widget> _scoreWidgetList = [];
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
      final int userid = await Provider.of<UserData>(context, listen: false)
          .getEcourse2Userid(token);
      final scoresList = await _getScores(widget.courseid, userid, token);
      List<Widget> tempScoreWidgetList = [];
      tempScoreWidgetList.add(
        Padding(
          padding: const EdgeInsets.all(13.0),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child:
                    Text('項目', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 1,
                child:
                    Text('分數', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '排名',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
      tempScoreWidgetList.add(
        Divider(
          thickness: 0.7,
          height: 0.7,
        ),
      );

      scoresList.forEach((score) {
        tempScoreWidgetList.add(
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('${score.itemname}',
                      overflow: TextOverflow.ellipsis),
                  content: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        // _scoreDataField('類別加權:', '${score.weightformatted}'),
                        _scoreDataField('成績:', '${score.gradeformatted}'),
                        _scoreDataField(
                            '排名:', '${score.rank}/${score.numusers ?? '-'}'),
                        _scoreDataField(
                          '登記時間:',
                          score.gradedategraded == null
                              ? '-'
                              : DateFormat('yyyy-MM-dd HH:mm:ss').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      score.gradedategraded * 1000)),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('好'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Text('${score.itemname}'),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('${score.gradeformatted}'),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${score.rank}/${score.numusers ?? '-'}',
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        tempScoreWidgetList.add(
          Divider(
            thickness: 0.7,
            height: 0.7,
          ),
        );
      });

      _scoreWidgetList = tempScoreWidgetList;
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

  List<Score> _scores = [];

  Future<List<Score>> _getScores(int courseid, int userid, String token) async {
    try {
      _scores = await ecourse2.getScores(courseid, userid, token);

      return _scores;
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
            : ListView.builder(
                itemCount: _scoreWidgetList.length,
                itemBuilder: (ctx, index) => _scoreWidgetList[index],
              );
  }

  Widget _scoreDataField(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(title),
          ),
          Expanded(
            flex: 3,
            child: Text(content),
          ),
        ],
      ),
    );
  }
}
