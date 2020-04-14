import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../functions/kiki.dart' as kiki;

class UserData with ChangeNotifier{
  String _username = '';
  String _password = '';
  String _ecourse2Token = '';
  int _ecourse2Userid = 0;

  Future<void> tryLoginAndSavePref(
      String username, String password, bool savePref) async {
    if (username != null && password != null) {
      if (username.isNotEmpty && password.isNotEmpty) {
        try {
          //_ecourse2Token = await _requestEcourse2Token(username, password);
          await kiki.getSessionid(username, password);
          _username = username;
          _password = password;
          if (savePref) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('username', username);
            await prefs.setString('password', password);
          }
          return;
        } catch (error) {
          throw error;
        }
      }
    }
    throw 'user_data.dart: (tryLoginAndSavePref) username or password is null or empty.';
  }

  Future<String> getEcourse2Token() async {
    if (_ecourse2Token != null && _ecourse2Token.isNotEmpty) {
      //check if token has exist
      return _ecourse2Token;
    }

    if (_username == null || //check whether have got username and password
        _password == null ||
        _username.isEmpty ||
        _password.isEmpty) {
      if (!await updateUsrAndPwdFromPref()) {
        throw 3; //can't find token and username password anywhere
      }
    }

    try {
      _ecourse2Token = await _requestEcourse2Token(_username, _password);

      return _ecourse2Token;
    } catch (error) {
      throw error;
    }
  }

  Future<String> _requestEcourse2Token(String username, String password) async {
    http.Response loginResponseRaw;

    try {
      final loginUrl = 'https://ecourse2.ccu.edu.tw/login/token.php';
      loginResponseRaw = await http.post(loginUrl, body: {
        'username': username,
        'password': password,
        'service': 'moodle_mobile_app',
      });
    } catch (error) {
      throw '網路連線錯誤';
    }

    final loginResponseDecode =
        jsonDecode(loginResponseRaw.body); // as Map<String, dynamic>
    if (loginResponseDecode.containsKey('error')) {
      if (loginResponseDecode.containsValue('invalidlogin')) {
        throw 2; //帳號或密碼錯誤
      } else {
        throw 1; //未知的登入錯誤
      }
    }
    final token = loginResponseDecode['token'].toString();

    return token;
  }

  Future<int> getEcourse2Userid(String token) async {
    try {
      if (_ecourse2Userid.bitLength == 0) {
        _ecourse2Userid = await _requestEcourse2Userid(token);
      }
      return _ecourse2Userid;
    } catch (error) {
      throw error;
    }
  }

  Future<int> _requestEcourse2Userid(String token) async {
    try {
      final restUrl = 'https://ecourse2.ccu.edu.tw/webservice/rest/server.php';
      final response = await http.post(restUrl, body: {
        'moodlewssettingfilter': 'true',
        'moodlewssettingfileurl': 'true',
        'moodlewsrestformat': 'json',
        'wsfunction': 'core_webservice_get_site_info',
        'wstoken': token,
      });

      final userid = jsonDecode(response.body)['userid'];

      return userid;
    } catch (error) {
      throw error;
    }
  }

  Future<bool> updateUsrAndPwdFromPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('username') == null ||
        prefs.getString('username').isEmpty) {
      return false;
    }
    if (prefs.getString('password') == null ||
        prefs.getString('password').isEmpty) {
      return false;
    }
    _username = prefs.getString('username');
    _password = prefs.getString('password');
    return true;
  }

  Map<String, String> getCurrentUsrAndPwd() {
    return {'username': _username, 'password': _password};
  }

  Future<String> getSavedUsername() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString('username') == null ||
          prefs.getString('username').isEmpty) {
        throw '未登入';
      }
      return prefs.getString('username');
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    _ecourse2Token = '';
    _ecourse2Userid = 0;
    _username = '';
    _password = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', '');
    await prefs.setString('password', '');
    return;
  }

  String getCurrentEcourse2Token() {
    return _ecourse2Token;
  }

  Future<int> getCourseStartupIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getInt('courseStartupIndex') == null) {
        await prefs.setInt('courseStartupIndex', 0);
        return 0;
      }
      return prefs.getInt('courseStartupIndex');
  }

  Future<void> setCourseStartupIndex(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('courseStartupIndex', index);
  }
}
