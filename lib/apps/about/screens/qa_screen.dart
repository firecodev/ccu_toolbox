import 'package:flutter/material.dart';

const List<List<String>> qaCollection = [
  [
    '為什麼我的火車資訊會載入失敗，明明別人的都正常呀?',
    '因為這個 APP 所使用的火車 API (PTX) 有次數限制，可能是短時間內存取(或重新整理)太多次了導致暫時無法使用，可以稍後再試試看或更換 IP (如果您有相關能力的話)。'
  ],
  [
    '火車的準誤點資訊怎麼和現場不一樣呀?',
    '因為這個 APP 所使用的火車 API (PTX) 與最新資料有約 2 分鐘的延遲，如果有不一樣，請以現場的即時資訊看板為準，詳請參閱 PTX 網站。'
  ],
  [
    '為什麼沒有學期總成績? CCU Life 裡有欸',
    '呃...不好意思，開發者是大衣小菜機，成績資料過少，沒辦法確定和分析資料格式，暫時無法開發，待資料足夠定速速補上，真的很抱歉...'
  ],
  [
    '為什麼沒有點名資訊?',
    '因為沒有點名的 API (老實說其實是有啦，只是它不能列出所有點名紀錄，只能看總點名次數和總出缺席次數，實用價值不大)，然後直接做網頁解析太麻煩且出錯機率很大又很耗流量，所以索性放棄，如果真的要做的話，可能學校得先開發相關 API 這個 APP 才會加上點名查詢功能哦。'
  ],
  ['作者讀什麼系? 幾年級?', '資工大一。'],
  [
    '為什麼想做這個 APP ?',
    '因為 CCU Life 好用啊，可是在學校把課程系統換成 eCourse2 後它就不能用了，再加上我想加其他功能，於是乎就有了自己寫 APP 的想法。'
  ],
  [
    'J個 APP 花了多久完成呢?',
    '由於小弟我之前從沒寫過任何 APP 甚至沒碰過物件導向的程式語言，因此在正式開工之前大概就花了整整10天學基礎的物件導向概念和新的程式語言，接著再花15天才寫出現在這個樣子，剩下的時間就是修一些小 Bug 囉。'
  ],
  ['UI 好醜 !', '我也這麼覺得欸，但我真的已經盡力了啦，如果你有藝術細胞，非常歡迎提供想法哦 ^^'],
  ['你的邏輯寫得好爛喔~', '啊我就第一次學和寫物件導向的程式和 APP 齁，是能好到哪裡去啦，啊不然來一起討論看看呀 ^^'],
  ['以後還會繼續維護嗎?', '在學期間應該會，但畢業後很有可能就不會囉，因為時間真的不夠用 QQ'],
  ['我可以找你學 APP 嗎?', '抱歉，可能沒辦法欸，因為時間真的不夠啊。'],
  ['為什麼選擇用 Flutter 開發呢?', '跨平台、高性能。'],
  ['iOS 會上架嗎?', '目前不會，每年 NT\$ 3000 的上架費用太貴了呀，負擔不起 TT'],
  [
    'iOS 也想用，怎麼辦?',
    '如果你有蘋果電腦(或會安裝黑蘋果)的話，那你就可以自己編譯並安裝到 iPhone 上囉，原則上只要修改設定檔幾個小地方就能用囉，不必改動主要程式碼哦，這也是我選擇 Flutter 作為開發語言的主要原因之一。'
  ],
  ['我認識你欸 !', '喔，好哦。所以呢?\n\n開玩笑的啦XD，想一起研究資工的東西嗎，都來都來~\n(純粹想找我 debug 作業就算了吧XD)'],
];

class QAScreen extends StatefulWidget {
  @override
  _QAScreenState createState() => _QAScreenState();
}

class _QAScreenState extends State<QAScreen> {
  List<Item> _data = generateItems(qaCollection);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Q&A'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: _buildPanel(),
        ),
      ),
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          canTapOnHeader: true,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
            title: Text(item.expandedValue),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(List<List<String>> qaCollection) {
  return qaCollection.map((qa) {
    return Item(
      headerValue: qa[0] ?? '',
      expandedValue: qa[1] ?? '',
    );
  }).toList();
}
