class Attachment {
  final String filename;
  final int filesize;
  final String fileurl;
  final int timemodified;
  final String mimetype;
  final bool isexternalfile;

  Attachment({
    this.filename,
    this.filesize,
    this.fileurl,
    this.timemodified,
    this.mimetype,
    this.isexternalfile,
  });
}
