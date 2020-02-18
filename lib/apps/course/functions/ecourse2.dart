import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:html_character_entities/html_character_entities.dart';

import '../models/discussion.dart';
import '../models/score.dart';
import '../models/assignment.dart';
import '../models/attachment.dart';

Future<List<Discussion>> getDiscussions(int courseid, String token) async {
  if (courseid == 0) {
    throw 'invalid courseid';
  }

  try {
    final restUrl = 'https://ecourse2.ccu.edu.tw/webservice/rest/server.php';
    final forumsResponse = await http.post(restUrl, body: {
      'courseids[0]': courseid.toString(),
      'moodlewssettingfilter': 'true',
      'moodlewssettingfileurl': 'true',
      'moodlewsrestformat': 'json',
      'wsfunction': 'mod_forum_get_forums_by_courses',
      'wstoken': token,
    });

    final forums =
        jsonDecode(forumsResponse.body); // as List<Map<String, Object>>
    final forumId =
        forums.firstWhere((forum) => forum['type'] == 'news')['id'].toString();

    final discussionResponse = await http.post(restUrl, body: {
      'forumid': forumId,
      'moodlewssettingfilter': 'true',
      'moodlewssettingfileurl': 'true',
      'moodlewsrestformat': 'json',
      'wsfunction': 'mod_forum_get_forum_discussions',
      'wstoken': token,
    });

    final tempDiscussions = jsonDecode(
        discussionResponse.body)['discussions']; // as List<Map<String, Object>>

    List<Discussion> result = [];

    tempDiscussions.forEach((tempDiscussion) {
      List<Attachment> tempAttachmentList = [];
      if (tempDiscussion['attachment']) {
        tempDiscussion['attachments'].forEach((attachment) {
          tempAttachmentList.add(Attachment(
            filename: attachment['filename'],
            filesize: attachment['filesize'],
            fileurl: attachment['fileurl'],
            timemodified: attachment['timemodified'],
            mimetype: attachment['mimetype'],
            isexternalfile: attachment['isexternalfile'],
          ));
        });
      }
      result.add(Discussion(
        id: tempDiscussion['id'],
        name: HtmlCharacterEntities.decode(tempDiscussion['name'].toString()),
        time: tempDiscussion['created'],
        message: tempDiscussion['message'].toString(),
        userfullname: tempDiscussion['userfullname'].toString(),
        userpictureurl: tempDiscussion['userpictureurl'].toString(),
        attachment: tempDiscussion['attachment'],
        attachments: tempAttachmentList,
      ));
    });

    return result;
  } catch (error) {
    throw error;
  }
}

Future<List<Score>> getScores(int courseid, int userid, String token) async {
  if (courseid == 0) {
    throw 'invalid courseid';
  }

  try {
    final restUrl = 'https://ecourse2.ccu.edu.tw/webservice/rest/server.php';
    final scoresResponse = await http.post(restUrl, body: {
      'courseid': courseid.toString(),
      'userid': userid.toString(),
      'moodlewssettingfilter': 'true',
      'moodlewssettingfileurl': 'true',
      'moodlewsrestformat': 'json',
      'wsfunction': 'gradereport_user_get_grade_items',
      'wstoken': token,
    });

    final scores = jsonDecode(scoresResponse.body)['usergrades'][0]
        ['gradeitems']; // as List<Map<String, Object>>

    List<Score> tempScoreItems = [];

    scores.forEach((item) {
      if (item['itemtype'] == 'category' || item['itemtype'] == 'course') {
        // tempScoreItems.add(ScoreItem(
        //   id: item['id'],
        //   itemtype: item['itemtype'],
        //   iteminstance: item['iteminstance'],
        //   weightraw: item['weightraw'],
        //   weightformatted: item['weightformatted'],
        //   graderaw: item['graderaw'],
        //   gradeformatted: item['gradeformatted'],
        //   grademin: item['grademin'],
        //   grademax: item['grademax'],
        //   rangeformatted: item['rangeformatted'],
        //   percentageformatted: item['percentageformatted'],
        //   rank: item['rank'],
        //   numusers: item['numusers'],
        // ));
      } else {
        String name;
        if (item['itemmodule'] == 'attendance') {
          name = '出缺席';
        } else {
          name = item['itemname'].toString();
        }

        tempScoreItems.add(Score(
          id: item['id'],
          itemname: name,
          itemtype: item['itemtype'].toString(),
          itemmodule: item['itemmodule'].toString(),
          iteminstance: item['iteminstance'],
          categoryid: item['categoryid'],
          weightraw: item['weightraw'],
          weightformatted: item['weightformatted'].toString(),
          graderaw: item['graderaw'],
          gradedategraded: item['gradedategraded'],
          gradeformatted: item['gradeformatted'].toString(),
          grademin: item['grademin'],
          grademax: item['grademax'],
          rangeformatted: item['rangeformatted'].toString(),
          percentageformatted: item['percentageformatted'].toString(),
          rank: item['rank'],
          numusers: item['numusers'],
        ));
      }
    });

    return tempScoreItems;
  } catch (error) {
    throw error;
  }
}

Future<List<Assignment>> getAssignments(int courseid, String token) async {
  if (courseid == 0) {
    throw 'invalid courseid';
  }

  try {
    final restUrl = 'https://ecourse2.ccu.edu.tw/webservice/rest/server.php';
    final assignmentsResponse = await http.post(restUrl, body: {
      'courseids[0]': courseid.toString(),
      'moodlewssettingfilter': 'true',
      'moodlewssettingfileurl': 'true',
      'moodlewsrestformat': 'json',
      'wsfunction': 'mod_assign_get_assignments',
      'wstoken': token,
    });

    final tempAssignments = jsonDecode(assignmentsResponse.body)['courses'][0]
        ['assignments']; // as List<Map<String, Object>>

    List<Assignment> result = [];

    tempAssignments.forEach((tempAssignment) {
      List<Attachment> tempIntroAttachmentList = [];
      if (tempAssignment.containsKey('introattachments')) {
        tempAssignment['introattachments'].forEach((attachment) {
          tempIntroAttachmentList.add(Attachment(
            filename: attachment['filename'],
            filesize: attachment['filesize'],
            fileurl: attachment['fileurl'],
            timemodified: attachment['timemodified'],
            mimetype: attachment['mimetype'],
            isexternalfile: attachment['isexternalfile'],
          ));
        });
      }
      result.add(Assignment(
        id: tempAssignment['id'],
        name: tempAssignment['name'].toString(),
        duedate: tempAssignment['duedate'],
        allowsubmissionsfromdate: tempAssignment['allowsubmissionsfromdate'],
        grade: tempAssignment['grade'],
        timemodified: tempAssignment['timemodified'],
        completionsubmit: tempAssignment['completionsubmit'],
        cutoffdate: tempAssignment['cutoffdate'],
        gradingduedate: tempAssignment['gradingduedate'],
        intro: tempAssignment['intro'].toString(),
        introattachments: tempIntroAttachmentList,
      ));
    });

    return result;
  } catch (error) {
    throw error;
  }
}

Future<AssignmentFeedback> getAssignmentFeedback(
    int assignid, int userid, String token) async {
  try {
    final restUrl = 'https://ecourse2.ccu.edu.tw/webservice/rest/server.php';
    final statusResponse = await http.post(restUrl, body: {
      'assignid': assignid.toString(),
      'userid': userid.toString(),
      'moodlewssettingfilter': 'true',
      'moodlewssettingfileurl': 'true',
      'moodlewsrestformat': 'json',
      'wsfunction': 'mod_assign_get_submission_status',
      'wstoken': token,
    });

    final tempStatus = json.decode(statusResponse.body);

    if (!tempStatus['lastattempt']['graded']) {
      throw 131;
    }

    final tempFeedback = tempStatus['feedback'];

    final result = AssignmentFeedback(
      grade: tempFeedback['grade']['grade'].toString(),
      gradefordisplay: HtmlCharacterEntities.decode(
          tempFeedback['gradefordisplay'].toString()),
      gradeddate: tempFeedback['gradeddate'],
      feedbackComment: tempFeedback['plugins']
          .firstWhere((plugin) => plugin['type'] == 'comments')['editorfields']
              [0]['text']
          .toString(),
    );

    return result;
  } catch (error) {
    throw error;
  }
}
