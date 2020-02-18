import 'package:flutter/material.dart';

import '../data/bus.dart';

class BusStation {
  BusStation({
    this.name = '未知',
    this.predictionTime = '未知',
    this.carNo = '未知',
    this.carLow = false,
    this.carStatus =
        4, // 0 = 有車且車在這裡, 1 = 稍晚發車, 2 = 有車但車還沒到, 3 = 有車但車快到了, 4 = 末班車駛離或未發車
  }) : icon = carStatus == 0
            ? carLow ? stationIcon[5] : stationIcon[0]
            : stationIcon[carStatus];

  final String name;
  final String predictionTime;
  final String carNo;
  final bool carLow;
  final int carStatus;
  final Widget icon;
}
