import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromRGBO(0, 15, 46, 1),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/20191128_175222.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'CCU Toolbox',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    'eCourse2相關功能可能暫時無法使用，敬請見諒',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
                fit: FlexFit.loose,
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _naviButton(
                          color: Colors.brown,
                          icon: Icons.school,
                          title: '課程',
                          routeName: '/apps/course',
                          context: context,
                        ),
                        _naviButton(
                          color: Color.fromRGBO(36, 128, 189, 1),
                          icon: Icons.directions_bus,
                          title: '交通',
                          routeName: '/apps/transport',
                          context: context,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _naviButton(
                          color: Color.fromRGBO(180, 60, 135, 1),
                          icon: Icons.event,
                          title: '行事曆',
                          routeName: '/apps/calendar',
                          context: context,
                        ),
                        _naviButton(
                          color: Colors.green,
                          icon: Icons.more_horiz,
                          title: '其他',
                          routeName: '/others',
                          context: context,
                        ),
                      ],
                    ),
                  ],
                )),
          ],
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
                ClipOval(
                  child: SizedBox(
                    width: 70.0,
                    height: 70.0,
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
