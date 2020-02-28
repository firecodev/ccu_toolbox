import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/bus_station.dart';
import '../models/train.dart';

import '../widgets/timeline.dart';
import '../widgets/liveboard.dart';

enum TransportType {
  bus,
  train,
}

class TransportData with ChangeNotifier {
  TransportType _selectedTransport = TransportType.bus; // 0 = Bus, 1 = Train
  String _busRouteNo = '0746';
  int _busGoBack = 1;
  String _trainStationID = '4060';
  int _trainDirection = 0;

  int _seq = 0;

  final List<List> type = [
    [TransportType.bus, '公車'],
    [TransportType.train, '火車'],
  ];

  final List<List<String>> busRoutes = [
    ['0746', '106 嘉義縣公車處 市區公車', '台鐵嘉義站', '高鐵嘉義站'],
    ['7309', '7309 嘉義縣公車處 一般公車', '大雅站', '南華大學'],
    ['7306', '7306 嘉義縣公車處 一般公車', '梅山', '民雄國中'],
    ['6187', '6187 台中客運 國道公車', '臺中車站', '嘉義市先期交通轉運中心'],
    ['7005', '7005 日統客運 國道公車 ', '民雄站', '台北站'],
  ];

  final List<List<String>> trainStations = [
    ['4060', '民雄火車站', '順行', '逆行'],
    ['4080', '嘉義火車站', '順行', '逆行'],
  ];

  TransportType get getSelectedTransport {
    return _selectedTransport;
  }

  StreamController<Widget> routeAndStationWidgetController =
      StreamController.broadcast();
  StreamController<Widget> displayWidgetController =
      StreamController.broadcast();
  StreamController<Widget> statusIndicatorWidgetController =
      StreamController.broadcast();

  Future<void> switchDirection() async {
    switch (_selectedTransport) {
      case TransportType.bus:
        _busGoBack = _busGoBack == 1 ? 2 : 1;
        break;
      case TransportType.train:
        _trainDirection = _trainDirection == 0 ? 1 : 0;
    }
    await updateAllWidgets();
  }

  Future<void> updateAllWidgets({
    TransportType selectedTransport,
    String busRouteNo,
    int busGoBack,
    String trainStationID,
    int trainDirection,
  }) async {
    _selectedTransport = selectedTransport ?? _selectedTransport;
    _busRouteNo = busRouteNo ?? _busRouteNo;
    _busGoBack = busGoBack ?? _busGoBack;
    _trainStationID = trainStationID ?? _trainStationID;
    _trainDirection = trainDirection ?? _trainDirection;

    final thisSeq = ++_seq;

    updateStatusIndicatorWidget(true);
    updateRouteAndStationWidget();
    await updateDisplayWidget(thisSeq);
    if (thisSeq == _seq && !statusIndicatorWidgetController.isClosed) {
      updateStatusIndicatorWidget(false);
    }
  }

  void updateStatusIndicatorWidget(bool isLoading) {
    if (isLoading) {
      statusIndicatorWidgetController.sink.add(Center(
        child: IconButton(
          icon: CircularProgressIndicator(
            backgroundColor: Colors.white,
          ),
          enableFeedback: false,
          onPressed: null,
          tooltip: '載入中',
        ),
      ));
    } else {
      statusIndicatorWidgetController.sink.add(IconButton(
        icon: Icon(Icons.refresh),
        onPressed: () {
          updateAllWidgets();
        },
        tooltip: '重新載入',
      ));
    }
  }

  void updateRouteAndStationWidget({
    TransportType selectedTransport,
    String busRouteNo,
    int busGoBack,
    String trainStationID,
    int trainDirection,
  }) {
    _selectedTransport = selectedTransport ?? _selectedTransport;
    _busRouteNo = busRouteNo ?? _busRouteNo;
    _busGoBack = busGoBack ?? _busGoBack;
    _trainStationID = trainStationID ?? _trainStationID;
    _trainDirection = trainDirection ?? _trainDirection;

    Widget tempWidget;

    if (_selectedTransport == TransportType.bus) {
      //
      tempWidget = DropdownButton<String>(
        value: _busRouteNo,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String newValue) {
          updateAllWidgets(busRouteNo: newValue);
        },
        itemHeight: 85.0,
        items: busRoutes.map((route) {
          return DropdownMenuItem<String>(
            value: route[0],
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(route[1], style: TextStyle(fontSize: 18.0)),
                  SizedBox(height: 3.0),
                  Text(
                    _busGoBack == 1
                        ? '${route[2]} -> ${route[3]}'
                        : '${route[3]} -> ${route[2]}',
                    style: TextStyle(fontSize: 13.0, color: Colors.grey),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      );
    } else if (_selectedTransport == TransportType.train) {
      //
      tempWidget = DropdownButton<String>(
        value: _trainStationID,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
        ),
        onChanged: (String newValue) {
          updateAllWidgets(trainStationID: newValue);
        },
        itemHeight: 85.0,
        items: trainStations.map((station) {
          return DropdownMenuItem<String>(
            value: station[0],
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(station[1], style: TextStyle(fontSize: 18.0)),
                  SizedBox(height: 3.0),
                  Text(
                    _trainDirection == 0 ? '${station[2]}' : '${station[3]}',
                    style: TextStyle(fontSize: 13.0, color: Colors.grey),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      );
    }

    routeAndStationWidgetController.sink.add(tempWidget);
  }

  Future<void> updateDisplayWidget(
    int thisSeq, {
    TransportType selectedTransport,
    String busRouteNo,
    int busGoBack,
    String trainStationID,
    int trainDirection,
  }) async {
    _selectedTransport = selectedTransport ?? _selectedTransport;
    _busRouteNo = busRouteNo ?? _busRouteNo;
    _busGoBack = busGoBack ?? _busGoBack;
    _trainStationID = trainStationID ?? _trainStationID;
    _trainDirection = trainDirection ?? _trainDirection;

    Widget tempWidget;

    if (_selectedTransport == TransportType.bus) {
      try {
        final busStationList = await getBusStationList(_busRouteNo, _busGoBack);
        if (thisSeq != _seq) {
          return;
        }
        tempWidget = Timeline(
          indicatorSize: 45.0,
          children: busStationList
              .map((station) => Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(station.name, style: TextStyle(fontSize: 25.0)),
                          SizedBox(height: 10.0),
                          Text(station.predictionTime,
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 18.0)),
                          Container(
                            child: station.carStatus == 0
                                ? SizedBox(height: 10.0)
                                : null,
                          ),
                          Container(
                            child: station.carStatus == 0
                                ? Text(station.carNo,
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18.0))
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ))
              .toList(),
          indicators: busStationList.map((station) => station.icon).toList(),
        );
      } catch (error) {
        tempWidget = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.cloud_off),
            Text('載入時發生錯誤'),
          ],
        );
      }
    } else if (_selectedTransport == TransportType.train) {
      try {
        final trainList = await getTrainList(_trainStationID, _trainDirection);
        if (thisSeq != _seq) {
          return;
        }
        if (trainList.isEmpty) {
          tempWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.nature_people,
                size: 50.0,
                color: Colors.grey,
              ),
              Text('當日已無班次',
                  style: TextStyle(fontSize: 20.0, color: Colors.grey)),
            ],
          );
        } else {
          tempWidget = Liveboard(trainList: trainList);
        }
      } catch (error) {
        tempWidget = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.cloud_off),
            Text('載入時發生錯誤'),
          ],
        );
      }
    }

    if (!displayWidgetController.isClosed)
      displayWidgetController.sink.add(tempWidget);
  }

  Future<List<BusStation>> getBusStationList(String routeNo, int goBack) async {
    final taiwanbusUrl =
        'https://www.taiwanbus.tw/app_api/SP_PredictionTime_V3.ashx?routeNo=$routeNo&branch=0&goBack=$goBack&Source=w';
    final taiwanbusResponseRaw = await http.get(taiwanbusUrl);
    final taiwanbusResponseDecoded =
        jsonDecode(taiwanbusResponseRaw.body)[0]['stopInfo'];

    List<BusStation> tempBusStationList = [];
    String tempName;
    String tempPredictionTime;
    String tempCarNo;
    bool tempCarLow;
    int tempCarStatus;
    String preCarNo = '';

    taiwanbusResponseDecoded.forEach((info) {
      tempName = info['name'];
      tempPredictionTime = info['predictionTime'];
      tempCarNo = info['carNo'];

      if (tempCarNo != preCarNo) {
        //有車且車在這裡
        tempCarStatus = 0;
        tempCarLow = info['carLow'] == 'Y' ? true : false;
      } else if (tempPredictionTime.contains(':')) {
        //稍晚發車
        tempCarStatus = 1;
        tempCarLow = false;
      } else if (tempPredictionTime.contains('分')) {
        //有車但車還沒到
        tempCarStatus = 2;
        tempCarLow = false;
      } else if (tempPredictionTime == '即將進站' || tempPredictionTime == '進站中') {
        //有車但車快到了
        tempCarStatus = 3;
        tempCarLow = false;
      } else {
        //末班車駛離或未發車
        tempCarStatus = 4;
        tempCarLow = false;
      }

      preCarNo = tempCarNo;

      tempBusStationList.add(BusStation(
        name: tempName,
        predictionTime: tempPredictionTime,
        carNo: tempCarNo,
        carLow: tempCarLow,
        carStatus: tempCarStatus,
      ));
    });

    return tempBusStationList;
  }

  Future<List<Train>> getTrainList(String stationID, int direction) async {
    final nowDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final liveboardUrl =
        'https://ptx.transportdata.tw/MOTC/v2/Rail/TRA/LiveBoard/Station/$stationID?\$filter=Direction%20eq%20$direction&\$format=JSON';
    final liveboardResponseRaw = await http.get(
      liveboardUrl,
      headers: {
        'User-Agent': 'Mozilla/5.0',
      },
    );
    final liveboardResponseDecoded = jsonDecode(liveboardResponseRaw.body);

    final dailyUrl =
        'https://ptx.transportdata.tw/MOTC/v2/Rail/TRA/DailyTimetable/Station/$stationID/$nowDate?\$filter=Direction%20eq%20$direction&\$format=json';
    final dailyResponseRaw = await http.get(
      dailyUrl,
      headers: {
        'User-Agent': 'Mozilla/5.0',
      },
    );
    final dailyResponseDecoded = jsonDecode(dailyResponseRaw.body);

    List<Train> tempTrainList = [];
    String tempTrainNo;
    int tempDirection;
    String tempTrainTypeID;
    String tempEndingStationName;
    int tempTripLine;
    DateTime tempArrivalTime;
    DateTime tempDepartureTime;
    bool tempHasDelayTime;
    int tempDelayTime;
    Map<String, dynamic> tempMatchItem;

    dailyResponseDecoded.forEach((info) {
      tempTrainNo = info['TrainNo'];
      tempDirection = info['Direction'];
      tempTrainTypeID = info['TrainTypeID'];
      tempEndingStationName = info['EndingStationName'];
      tempTripLine = info['TripLine'];
      tempArrivalTime = DateTime.parse('$nowDate ${info['ArrivalTime']}:00');
      tempDepartureTime =
          DateTime.parse('$nowDate ${info['DepartureTime']}:00');
      tempMatchItem = liveboardResponseDecoded.firstWhere(
          (test) => test['TrainNo'] == tempTrainNo,
          orElse: () => <String, dynamic>{});
      if (tempMatchItem.isNotEmpty) {
        tempHasDelayTime = true;
        tempDelayTime = tempMatchItem['DelayTime'];
      } else {
        tempHasDelayTime = false;
        tempDelayTime = 0;
      }

      tempTrainList.add(Train(
        trainNo: tempTrainNo,
        direction: tempDirection,
        trainTypeID: tempTrainTypeID,
        endingStationName: tempEndingStationName,
        tripLine: tempTripLine,
        arrivalTime: tempArrivalTime,
        departureTime: tempDepartureTime,
        hasDelayTime: tempHasDelayTime,
        delayTime: tempDelayTime,
      ));
    });

    final timeDivider = DateTime.now();
    tempTrainList = tempTrainList
        .where((train) => train.departureTime
            .add(Duration(minutes: train.delayTime))
            .isAfter(timeDivider))
        .toList();
    tempTrainList.sort((a, b) => a.arrivalTime.compareTo(b.arrivalTime));
    return tempTrainList;
  }
}
