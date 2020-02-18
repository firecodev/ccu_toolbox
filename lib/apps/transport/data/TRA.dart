import 'package:flutter/material.dart';

const Map<String, String> typeID2Name = {
  '1101': '太魯閣', //自強(太，障)
  '1105': '自強(郵)',
  '1104': '自強(專)',
  '1112': '莒光(專)',
  '1120': '復興',
  '1131': '區間', //區間車
  '1132': '區間快',
  '1140': '普快車',
  '1141': '柴快車',
  '1150': '普通車(專)',
  '1151': '普通車',
  '1152': '行包專車',
  '1134': '兩鐵(專)',
  '1270': '普通貨車',
  '1280': '客迴',
  '1281': '柴迴',
  '12A0': '調車列車',
  '12A1': '單機迴送',
  '12B0': '試運轉',
  '4200': '特種(戰)',
  '5230': '特種(警)',
  '1111': '莒光', //莒光(障)
  '1103': '自強', //自強(障)
  '1102': '自強', //自強(腳，障)
  '1100': '自強',
  '1110': '莒光',
  '1121': '復興(專)',
  '1122': '復興(郵)',
  '1113': '莒光(郵)',
  '1282': '臨時客迴',
  '1130': '電車(專)',
  '1133': '電車(郵)',
  '1154': '柴客(專)',
  '1155': '柴客(郵)',
  '1107': '普悠瑪', //自強(普，障)
  '1135': '區間', //區間車(腳，障)
  '1108': '自強', //自強(PP障)
  '1114': '莒光', //莒光(腳)
  '1115': '莒光', //莒光(腳，障)
  '1109': '自強', //自強(PP親)
  '110A': '自強', //自強(PP障12)
  '110B': '自強', //自強(E12)
  '110C': '自強', //自強(E3)
  '110D': '自強', //自強(D28)
  '110E': '自強', //自強(D29)
  '110F': '自強', //自強(D31)
  '1106': '自強(商專)',
};

const Map<String, List<IconData>> typeID2Icon = {
  '1101': [Icons.accessible], //自強(太，障)
  '1111': [Icons.accessible], //莒光(障)
  '1103': [Icons.accessible], //自強(障)
  '1102': [Icons.directions_bike, Icons.accessible], //自強(腳，障)
  '1107': [Icons.accessible], //自強(普，障)
  '1135': [Icons.directions_bike, Icons.accessible], //區間車(腳，障)
  '1108': [Icons.accessible], //自強(PP障)
  '1114': [Icons.directions_bike], //莒光(腳)
  '1115': [Icons.directions_bike, Icons.accessible], //莒光(腳，障)
  '1109': [Icons.child_care], //自強(PP親)
  '110A': [Icons.accessible], //自強(PP障12)
};

final Map<String, Color> typeID2Color = {
  '1101': Colors.orange[600], //自強(太，障)
  '1105': Colors.orange[600],
  '1104': Colors.orange[600],
  '1112': Color.fromRGBO(230, 105, 80, 1),
  '1131': Colors.blue[800],
  '1132': Colors.blue[800],
  '1111': Color.fromRGBO(230, 105, 80, 1), //莒光(障)
  '1103': Colors.orange[600], //自強(障)
  '1102': Colors.orange[600], //自強(腳，障)
  '1100': Colors.orange[600],
  '1110': Color.fromRGBO(230, 105, 80, 1),
  '1113': Color.fromRGBO(230, 105, 80, 1),
  '1107': Color.fromRGBO(230, 80, 130, 1), //自強(普，障)
  '1135': Colors.blue[800], //區間車(腳，障)
  '1108': Colors.orange[600], //自強(PP障)
  '1114': Color.fromRGBO(230, 105, 80, 1), //莒光(腳)
  '1115': Color.fromRGBO(230, 105, 80, 1), //莒光(腳，障)
  '1109': Colors.orange[600], //自強(PP親)
  '110A': Colors.orange[600], //自強(PP障12)
  '110B': Colors.orange[600], //自強(E12)
  '110C': Colors.orange[600], //自強(E3)
  '110D': Colors.orange[600], //自強(D28)
  '110E': Colors.orange[600], //自強(D29)
  '110F': Colors.orange[600], //自強(D31)
  '1106': Colors.orange[600],
};

const Map<int, String> line2Name = {
  0: '不經過山海線',
  1: '山線',
  2: '海線',
  3: '成追',
  4: '山海',
};
