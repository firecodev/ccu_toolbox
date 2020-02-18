import 'package:flutter/material.dart';

class OthersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('更多工具'),
      ),
      body: Container(
        height: deviceSize.height,
        width: deviceSize.width,
        color: Color.fromRGBO(0, 15, 46, 1),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Wrap(
              spacing: 30.0,
              runSpacing: 30.0,
              alignment: WrapAlignment.center,
              children: <Widget>[
                _naviButton(
                  color: Colors.blueGrey,
                  icon: Icons.settings,
                  title: '設定',
                  routeName: '/apps/setting',
                  context: context,
                ),
                _naviButton(
                  color: Colors.grey[700],
                  icon: Icons.info,
                  title: '關於',
                  routeName: '/apps/about',
                  context: context,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _naviButton(
      {@required Color color,
      @required IconData icon,
      @required String title,
      @required String routeName,
      @required BuildContext context}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(routeName);
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(9.0),
                  child: SizedBox(
                    width: 60.0,
                    height: 60.0,
                    child: Material(
                      color: color,
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
