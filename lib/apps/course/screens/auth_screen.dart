import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_data.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String routeName = ModalRoute.of(context).settings.arguments ?? '';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('登入'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: AuthCard(routeName),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  final String routeName;

  AuthCard(this.routeName);

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final TextEditingController _usrController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _showPwd = false;
  bool _isLoading = false;
  bool _rememberMe = true;

  Map<String, String> _authData = {
    'username': '',
    'password': '',
  };

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('登入錯誤'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('好'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<UserData>(context, listen: false).tryLoginAndSavePref(
        _authData['username'],
        _authData['password'],
        _rememberMe,
      );
      if (widget.routeName.isEmpty) {
        Navigator.of(context).pop();
      } else {
        Navigator.of(context).pushReplacementNamed(widget.routeName);
      }
    } catch (error) {
      if (error == 1) {
        _showErrorDialog('未知的登入錯誤');
      } else if (error == 2) {
        _showErrorDialog('帳號或密碼錯誤');
      } else {
        _showErrorDialog(error);
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: false,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _usrController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '學號',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (v) {
              return v.trim().isNotEmpty ? null : '學號不能為空';
            },
            onSaved: (value) {
              _authData['username'] = value;
            },
          ),
          TextFormField(
            controller: _pwdController,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
                labelText: '密碼',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon:
                      Icon(_showPwd ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _showPwd = !_showPwd;
                    });
                  },
                )),
            obscureText: !_showPwd,
            validator: (v) {
              if (v.isEmpty) {
                return '密碼不能為空';
              } else if (v.length < 4 || v.length > 10) {
                return '密碼長度需介於4-10';
              }
              return null;
            },
            onSaved: (value) {
              _authData['password'] = value;
            },
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _rememberMe = !_rememberMe;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Checkbox(
                    value: _rememberMe,
                    onChanged: (newValue) {
                      setState(() {
                        _rememberMe = newValue;
                      });
                    }),
                Text('記住我'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RaisedButton(
                    color: Colors.blueGrey,
                    onPressed: _submit,
                    textColor: Colors.white,
                    child: Text('登入'),
                  ),
          ),
        ],
      ),
    );
  }
}
