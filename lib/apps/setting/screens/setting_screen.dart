import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../course/providers/user_data.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('設定'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 15.0),
                  child: Text(
                    '課程',
                    style: TextStyle(color: Colors.blue[800], fontSize: 18.0),
                  ),
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                CourseAccountWidget(),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
                CourseStartupIndexMenuWidget(),
                Divider(
                  height: 1,
                  thickness: 1,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CourseAccountWidget extends StatefulWidget {
  @override
  _CourseAccountWidgetState createState() => _CourseAccountWidgetState();
}

class _CourseAccountWidgetState extends State<CourseAccountWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:
            Provider.of<UserData>(context, listen: false).getSavedUsername(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _accountInfo(
              snapshot.data,
              FlatButton(
                onPressed: () {
                  Provider.of<UserData>(context, listen: false)
                      .logout()
                      .then((_) {
                    setState(() {});
                  });
                },
                child: Text('登出'),
                textColor: Colors.red,
              ),
            );
          } else if (snapshot.hasError) {
            return _accountInfo(
              snapshot.error,
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/apps/course/auth');
                },
                child: Text('登入'),
                textColor: Colors.green,
              ),
            );
          } else {
            return _accountInfo(
              '讀取中',
              FlatButton(
                onPressed: null,
                child: Text('登入'),
              ),
            );
          }
        });
  }

  Widget _accountInfo(String username, Widget button) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      title: Text('帳號'),
      subtitle: Text(username),
      trailing: button,
    );
  }
}

class CourseStartupIndexMenuWidget extends StatefulWidget {
  @override
  _CourseStartupIndexMenuWidgetState createState() =>
      _CourseStartupIndexMenuWidgetState();
}

class _CourseStartupIndexMenuWidgetState
    extends State<CourseStartupIndexMenuWidget> {
  final List<String> indexNameList = ['我的課程', '每日課表'];
  int dropdownValue = 0;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      title: Text('起始分頁'),
      trailing: FutureBuilder(
        future: Provider.of<UserData>(context, listen: false)
            .getCourseStartupIndex(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            dropdownValue = snapshot.data;
            return DropdownButton<int>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              elevation: 16,
              underline: Container(
                height: 0,
                color: Colors.transparent,
              ),
              onChanged: (int newValue) {
                Provider.of<UserData>(context, listen: false)
                    .setCourseStartupIndex(newValue);
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: indexNameList
                  .asMap()
                  .map((index, name) {
                    return MapEntry(
                      index,
                      DropdownMenuItem<int>(
                        value: index,
                        child: Text(name),
                      ),
                    );
                  })
                  .values
                  .toList(),
            );
          } else if (snapshot.hasError) {
            return Text('Error');
          } else {
            return Text('讀取中');
          }
        },
      ),
    );
  }
}
