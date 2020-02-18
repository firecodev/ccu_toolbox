import 'package:flutter/material.dart';

final List<Widget> stationIcon = [
  Icon(
    Icons.directions_bus,
    size: 35.0,
    color: Colors.indigo[400],
  ),
  Icon(
    Icons.location_on,
    size: 35.0,
    color: Colors.brown,
  ),
  Icon(
    Icons.location_on,
    size: 35.0,
    color: Colors.green[600],
  ),
  Icon(
    Icons.location_on,
    size: 35.0,
    color: Colors.red[400],
  ),
  Icon(
    Icons.location_on,
    size: 35.0,
    color: Colors.grey,
  ),
  Stack(
    alignment: Alignment.center,
    children: [
      Icon(
        Icons.directions_bus,
        size: 35.0,
        color: Colors.indigo[400],
      ),
      Positioned(
        right: 0,
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.blue,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(3.0),
            ),
            child: Icon(
              Icons.accessible,
              color: Colors.blue,
              size: 15.0,
            ),
          ),
        ),
      )
    ],
  ),
];
