import 'package:flutter/foundation.dart';

class Score {
  final int id;
  String itemname;
  String itemtype;
  String itemmodule;
  int iteminstance;
  int categoryid;
  dynamic weightraw;
  String weightformatted;
  dynamic graderaw;
  int gradedategraded;
  String gradeformatted;
  dynamic grademin;
  dynamic grademax;
  String rangeformatted;
  String percentageformatted;
  int rank;
  int numusers;

  Score({
    @required this.id,
    this.itemname,
    this.itemtype,
    this.itemmodule,
    this.iteminstance,
    this.categoryid,
    this.weightraw,
    this.weightformatted,
    this.graderaw,
    this.gradedategraded,
    this.gradeformatted,
    this.grademin,
    this.grademax,
    this.rangeformatted,
    this.percentageformatted,
    this.rank,
    this.numusers,
  });
}

