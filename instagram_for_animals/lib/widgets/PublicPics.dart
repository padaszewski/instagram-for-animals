import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_for_animals/Photos.dart';
import 'package:instagram_for_animals/TokenAuth.dart';
import 'package:instagram_for_animals/main.dart';

import '../CurrentUser.dart';
import 'Profile.dart';
import 'SinglePic.dart';

class PublicPics extends StatefulWidget {
  final int userId;
  final String username;
  final TokenAuth tokenAuth;

  const PublicPics({Key key, this.userId, this.username, this.tokenAuth})
      : super(key: key);

  @override
  _PublicPicsState createState() => _PublicPicsState();
}

class _PublicPicsState extends State<PublicPics> {
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
        title: new Text(widget.userId == null
            ? "Image feed"
            : "Public pics by " + widget.username),
        actions: <Widget>[
          widget.tokenAuth != null
              ? Row(
                  children: <Widget>[
                    new IconButton(
                        icon: Icon(Icons.account_circle),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Profile(
                                      tokenAuth: widget.tokenAuth,
                                    )),
                          );
                        }),
//                    new IconButton(
//                      icon: Icon(Icons.exit_to_app),
//                      onPressed: () async {
//                        await logoutRequest();
//                        Navigator.pushReplacement(
//                          context,
//                          MaterialPageRoute(builder: (context) => LoginPage()),
//                        );
//                      },
//                    ),
                  ],
                )
              : new Container()
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return fetch();
        },
        child: ListView.builder(
          itemCount: images.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: <Widget>[
                widget.userId == null
                    ? new FlatButton(
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
                      )
                    : Container(
                        child: new Text(
                          images[index].attributes.username,
                          style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        ),
                        margin: EdgeInsetsDirectional.only(top: 10),
                      ),
                new Container(
                  margin: EdgeInsets.all(20),
                  constraints: BoxConstraints.tightFor(height: 300.0),
                  child: GestureDetector(
                    onTap: () {
                      print(widget.tokenAuth);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SinglePic(
                                  image: images[index],
                                  username: widget.username,
                                  tokenAuth: widget.tokenAuth,
                                )),
                      );
                    },
                    child: Image.network(
                      "http://10.0.2.2:4000" + images[index].attributes.path,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                new Text(images[index].attributes.description),
                new Divider(color: Colors.black)
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> fetch() async {
    String additor = "";
    if (widget.userId != null) {
      additor = "?user=${widget.userId}";
    }
    var url = 'http://10.0.2.2:4000/api/photos' + additor;
    final response = await http.get(url);
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
  }
}
