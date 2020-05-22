import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_for_animals/CurrentUser.dart';
import 'package:instagram_for_animals/TokenAuth.dart';
import 'package:instagram_for_animals/widgets/PublicPics.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Simple Login Demo',
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: new LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

// Used for controlling whether the user is loggin or creating an account
enum FormType { login, register }

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  String _email = "test@test.com";
  String _password = "testtest";
  FormType _form = FormType
      .login; // our default setting is to login, and we should switch to creating an account when the user chooses to

  _LoginPageState() {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _email = "";
    } else {
      _email = _emailFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  // Swap in between our two forms, registering and logging in
  void _formChange() async {
    setState(() {
      if (_form == FormType.register) {
        _form = FormType.login;
      } else {
        _form = FormType.register;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("Instagram for Animals"),
      centerTitle: true,
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _emailFilter,
              decoration: new InputDecoration(labelText: 'Email'),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordFilter,
              decoration: new InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext contextScaffold) {
    if (_form == FormType.login) {
      return new Container(
        child: new Column(
          children: <Widget>[
            Builder(
              builder: (context) => RaisedButton(
                  child: Text('Login'),
                  onPressed: () async {
                    var loginReturn = await _loginPressed();
                    loginReturn == null
                        ? Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Wrong login credentials!"),
                            duration: Duration(seconds: 2),
                          ))
                        : Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PublicPics(
                                      tokenAuth: loginReturn,
                                    )),
                          );
                  }),
            ),
            new FlatButton(
              child: new Text('Dont have an account? Tap here to register.'),
              onPressed: _formChange,
            ),
            new FlatButton(
              child: new Text('Just show me the public pics!'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PublicPics()),
                );
              },
            )
          ],
        ),
      );
    } else {
      return new Container(
        child: new Column(
          children: <Widget>[
            Builder(
              builder: (context) => RaisedButton(
                  child: Text('Create an Account'),
                  onPressed: () async {
                    var message = await _createAccountPressed();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(message),
                      duration: Duration(seconds: 3),
                    ));
                  }),
            ),
            new FlatButton(
              child: new Text('Have an account? Click here to login.'),
              onPressed: _formChange,
            ),
          ],
        ),
      );
    }
  }

  // These functions can self contain any user auth logic required, they all have access to _email and _password

  Future<TokenAuth> _loginPressed() async {
    var url = 'http://10.0.2.2:4000/api/session';
    var response = await http.post(url, body: {
//      'user[email]': '${"test@test.com"}',
//      'user[password]': '${"testtest"}'
//    });
      'user[email]': '$_email', 'user[password]': '$_password'
    });

    if (response.statusCode == 200) {
      TokenAuth tokenAuth = TokenAuth.fromJson(json.decode(response.body));
      CurrentUser.tokenData = tokenAuth.tokenData;
      return tokenAuth;
    }
    return null;
  }

  Future<String> _createAccountPressed() async {
    var url = 'http://10.0.2.2:4000/api/registration';
    var response = await http.post(url, body: {
      'user[email]': "$_email",
      'user[password]': '$_password',
      'user[confirm_password]': '$_password'
    });
    if (response.statusCode == 500) {
      return "Please provide valid input.";
    }
    if (response.statusCode == 200) {
      return "Successfully registered and logged in.";
    }
    return "Unexpected error";
  }
}
