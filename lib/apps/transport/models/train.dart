import 'package:flutter/material.dart';

import '../data/TRA.dart';

class Train {
  Train({
    @required this.trainNo,
    this.direction = 0,
    this.trainTypeID = '0000',
    this.endingStationName = '未知',
    this.tripLine = 0,
    @required this.arrivalTime,
    @required this.departureTime,
    this.hasDelayTime = false,
    this.delayTime = 0,
  })  : trainTypeName = typeID2Name[trainTypeID] ?? '未知',
        trainTypeIcon = typeID2Icon[trainTypeID] ?? [],
        trainTypeColor = typeID2Color[trainTypeID] ?? Colors.black,
        tripLineName = line2Name[tripLine] ?? '未知';

  final String trainNo;
  final int direction;
  final String trainTypeID;
  final String trainTypeName;
  final List<IconData> trainTypeIcon;
  final Color trainTypeColor;
  final String endingStationName;
  final int tripLine;
  final String tripLineName;
  final DateTime arrivalTime;
  final DateTime departureTime;
  final bool hasDelayTime;
  final int delayTime;
}
