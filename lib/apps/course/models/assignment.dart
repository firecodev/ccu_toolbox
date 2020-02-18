import 'package:flutter/foundation.dart';
import './attachment.dart';

class Assignment {
  final int id;
  final String name;
  final int duedate;
  final int allowsubmissionsfromdate;
  final int grade;
  final int timemodified;
  final int completionsubmit;
  final int cutoffdate;
  final int gradingduedate;
  final String intro;
  final List<Attachment> introattachments;

  Assignment({
    @required this.id,
    this.name = 'Unknown',
    this.duedate = 0,
    this.allowsubmissionsfromdate = 0,
    this.grade = 0,
    this.timemodified = 0,
    this.completionsubmit = 0,
    this.cutoffdate = 0,
    this.gradingduedate = 0,
    this.intro = '',
    this.introattachments,
  });
}

class AssignmentFeedback {
  final String grade;
  final String gradefordisplay;
  final int gradeddate;
  final String feedbackComment;

  AssignmentFeedback({
    this.grade,
    this.gradefordisplay,
    this.gradeddate,
    this.feedbackComment,
  });
}
