//This widget needs Train model
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/train.dart';

class Liveboard extends StatelessWidget {
  const Liveboard({
    @required this.trainList,
    this.itemGap = 1.0,
  })  : itemCount = trainList.length,
        assert(itemGap >= 0);

  final List<Train> trainList;
  final double itemGap;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      separatorBuilder: (_, __) => Divider(
        height: itemGap,
        thickness: 1.0,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final Train train = trainList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: <Widget>[
              Text(
                DateFormat('HH:mm').format(train.arrivalTime),
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(width: 15.0),
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Text(
                          train.trainTypeName,
                          style: TextStyle(
                              color: train.trainTypeColor, fontSize: 23.0),
                        ),
                        SizedBox(width: 5.0),
                        ...train.trainTypeIcon
                            .map((icon) => Icon(icon, color: Colors.grey)),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      '#${train.trainNo}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20.0,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: train.hasDelayTime
                    ? DelayChip(delayTime: train.delayTime)
                    : null,
              ),
              SizedBox(
                width: 5.0,
              ),
              Row(
                children: <Widget>[
                  Text(
                    '往',
                    style: TextStyle(color: Colors.grey, fontSize: 18.0),
                  ),
                  Text(
                    ' ${train.endingStationName}',
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class DelayChip extends StatelessWidget {
  DelayChip({
    @required this.delayTime,
  });

  final int delayTime;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        delayTime == 0 ? '準點' : '晚$delayTime分',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: delayTime == 0 ? Colors.green : Colors.red,
    );
  }
}
