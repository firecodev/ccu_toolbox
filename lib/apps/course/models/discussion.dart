import 'package:flutter/foundation.dart';
import './attachment.dart';

class Discussion {
  final int id;
  final String name;
  final int time;
  final String message;
  final String userfullname;
  final String userpictureurl;
  final bool attachment;
  final List<Attachment> attachments;
  final bool pinned;

  Discussion({
    @required this.id,
    this.name = 'Unknown',
    this.time = 0,
    this.message = '',
    this.userfullname = 'Unknown',
    this.userpictureurl = '',
    this.attachment = false,
    this.attachments,
    this.pinned = false,
  });
}
