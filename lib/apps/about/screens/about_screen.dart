import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import './qa_screen.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('關於'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('程式名稱: CCU Toolbox'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('版本: 1.1.2 (build 20200225)'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Edition: Public Edition'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('作者: Firecodev'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('開發套件: Flutter'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: <Widget>[
                  Text('原始碼: '),
                  GestureDetector(
                    onTap: () {
                      launch('https://github.com/firecodev/ccu_toolbox');
                    },
                    child: Text(
                      'https://github.com/firecodev/ccu_toolbox',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('封面照: Photo by Firecodev'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('資料來源:'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(' - 課程 : eCourse2、選課系統'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                  ' - 交通 : 公路汽車客運動態資訊管理系統 (www.taiwanbus.tw)、公共運輸整合資訊流通服務平臺 (PTX)'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(' - 行事曆 : 國立中正大學官網'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: <Widget>[
                  Text('Logo: From '),
                  GestureDetector(
                    onTap: () {
                      launch(
                          'https://pixabay.com/illustrations/hat-graduation-cap-education-1674894/');
                    },
                    child: Text(
                      'Pixabay',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: <Widget>[
                  Text('File icons: By '),
                  GestureDetector(
                    onTap: () {
                      launch(
                          'https://www.flaticon.com/authors/dimitry-miroliubov');
                    },
                    child: Text(
                      'Dimitry Miroliubov',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Text(' from '),
                  GestureDetector(
                    onTap: () {
                      launch('https://www.flaticon.com');
                    },
                    child: Text(
                      'www.flaticon.com',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: <Widget>[
                  Text('Q&A: '),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QAScreen()),
                      );
                    },
                    child: Text(
                      'Click me !',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: <Widget>[
                  Text('Made with '),
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  Text(' by Firecodev.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
