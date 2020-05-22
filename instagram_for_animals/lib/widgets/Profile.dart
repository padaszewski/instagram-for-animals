import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_for_animals/CurrentUser.dart';
import 'package:instagram_for_animals/TokenAuth.dart';

import '../Photos.dart';
import '../main.dart';
import 'AddPage.dart';
import 'PublicPics.dart';
import 'SinglePic.dart';

class Profile extends StatefulWidget {
  final TokenAuth tokenAuth;

  const Profile({Key key, this.tokenAuth}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<Data> images = new List();

  @override
  void initState() {
    if (widget.tokenAuth != null)
      widget.tokenAuth.tokenData = CurrentUser.tokenData;
    super.initState();
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => PublicPics(
                        tokenAuth: widget.tokenAuth,
                      )),
            );
          },
        ),
        title: new Text("All Your pics"),
        actions: <Widget>[
          Row(
            children: <Widget>[
              new IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AddPage()),
                  );
                },
              ),
              new IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async {
                  await logoutRequest();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return fetch();
        },
        child: images.length != 0
            ? ListView.builder(
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      new FlatButton(
                        child: new Text(images[index].attributes.username),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PublicPics(
                                    tokenAuth: widget.tokenAuth,
                                    username: images[index].attributes.username,
                                    userId: images[index].attributes.userId),
                              ));
                        },
                      ),
                      new Text(
                        images[index].attributes.public == true
                            ? "Public photo"
                            : "Private photo",
                        style: TextStyle(color: Colors.red),
                      ),
                      new Container(
                        margin: EdgeInsets.all(20),
                        constraints: BoxConstraints.tightFor(height: 300.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SinglePic(
                                        image: images[index],
                                        username:
                                            widget.tokenAuth.tokenData.username,
                                        tokenAuth: widget.tokenAuth,
                                      )),
                            );
                          },
                          child: Image.network(
                            "http://10.0.2.2:4000" +
                                images[index].attributes.path,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      new Text(images[index].attributes.description),
                      new Divider(color: Colors.black)
                    ],
                  );
                },
              )
            : Center(child: new Text("No photos yet!")),
      ),
    );
  }

  Future<void> fetch() async {
    var url = 'http://10.0.2.2:4000/api/photos';
    print(widget.tokenAuth.tokenData.renewToken);
    final response = await http
        .get(url, headers: {"Authorization": widget.tokenAuth.tokenData.token});
    if (response.statusCode == 200) {
      setState(() {
        Photos s = Photos.fromJson(json.decode(response.body));
        images = s.data;
      });
    } else {
      throw Exception('Failed to load images');
    }
  }

  Future<void> logoutRequest() async {
    var url = 'http://10.0.2.2:4000/api/session';
    final response = await http.delete(url,
        headers: {"Authorization": widget.tokenAuth.tokenData.token});
    CurrentUser.tokenData = null;
  }
}
