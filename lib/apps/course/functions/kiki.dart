import 'package:http/http.dart' as http;

Future<String> getSessionid(String username, String password) async {
  try {
    final bookmarkUrl =
        'https://kiki.ccu.edu.tw/~ccmisp06/cgi-bin/class_new/bookmark.php';
    final bookmarkResponse = await http.post(bookmarkUrl, body: {
      'id': username,
      'password': password,
    });
    final sessionid =
        Uri.dataFromString(bookmarkUrl + bookmarkResponse.headers['location'])
            .queryParameters['session_id']
            .toString();
    return sessionid;
  } catch (error) {
    throw error;
  }
}

Future<void> logout(String sessionid) async {
  try {
    final logoutUrl =
        'https://kiki.ccu.edu.tw/~ccmisp06/cgi-bin/class_new/logout.php?session_id=' +
            sessionid;
    await http.get(logoutUrl);
  } catch (error) {
    throw error;
  }
}
