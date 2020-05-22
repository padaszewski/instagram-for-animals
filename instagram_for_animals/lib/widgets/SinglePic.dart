import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_for_animals/SinglePhoto.dart';
import 'package:instagram_for_animals/TokenAuth.dart';

import '../CurrentUser.dart';
import '../Photos.dart';
import '../main.dart';
import 'PublicPics.dart';

class SinglePic extends StatefulWidget {
  final Data image;
  final String username;
  final TokenAuth tokenAuth;

  const SinglePic({Key key, this.image, this.username, this.tokenAuth})
      : super(key: key);

  @override
  _SinglePicState createState() => _SinglePicState();
}

class _SinglePicState extends State<SinglePic> {
  SinglePhoto singlePhoto;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    if (widget.tokenAuth != null)
      widget.tokenAuth.tokenData = CurrentUser.tokenData;
    super.initState();
    fetchSinglePhoto(widget.image.id);
  }

  @override
  Widget build(BuildContext context) {
    if (singlePhoto == null) {
      // This is what we show while we're loading
      return new Container();
    }
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          title: new Text("Photo of " + singlePhoto.data.attributes.username),
          actions: <Widget>[
            widget.tokenAuth != null
                ? IconButton(
                    icon: Icon(Icons.comment),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.height / 2,
                                  child: TextField(
                                    controller: controller,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        labelText: "Comment",
                                        prefixIcon: Icon(Icons.textsms),
                                        border: InputBorder.none,
                                        hintText: 'Enter a search term'),
                                  ),
                                ),
                                FlatButton(
                                  child: Text("Publish"),
                                  onPressed: () {
                                    controller.text.isEmpty
                                        ? _showToast()
                                        : _postComment(
                                            context, controller.text);
                                  },
                                )
                              ],
                            );
                          });
                    },
                  )
                : new Container()
          ],
        ),
        body: Center(
          child: new Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.all(20),
                constraints: BoxConstraints.tightFor(
                    height: MediaQuery.of(context).size.height / 3),
                child: Image.network(
                  "http://10.0.2.2:4000" + singlePhoto.data.attributes.path,
                  fit: BoxFit.fill,
                ),
              ),
              Column(
                children: <Widget>[
                  new ListTile(
                      title: widget.username == null
                          ? new FlatButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PublicPics(
                                          tokenAuth: widget.tokenAuth,
                                          username: singlePhoto
                                              .data.attributes.username,
                                          userId: singlePhoto
                                              .data.attributes.userId),
                                    ));
                              },
                              child: new Text(
                                  singlePhoto.data.attributes.username))
                          : Center(
                              child: new Text(
                                singlePhoto.data.attributes.username,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                      subtitle: Center(
                          child: Text(
                        singlePhoto.data.attributes.description,
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ))),
                  Container(
                    child: new Text("Comment section: "),
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 10),
                  )
                ],
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () {
                    return fetchSinglePhoto(widget.image.id);
                  },
                  child: singlePhoto.data.attributes.comments.length == 0
                      ? ListView.builder(
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(children: <Widget>[
                              new Divider(
                                color: Colors.black,
                              ),
                              new Text("No comments so far."),
                            ]);
                          })
                      : ListView.builder(
                          itemCount:
                              singlePhoto.data.attributes.comments.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: <Widget>[
                                new Divider(
                                  color: Colors.black,
                                ),
                                new ListTile(
                                  title: new FlatButton(
                                    child: new Text(singlePhoto.data.attributes
                                        .comments[index].username),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => PublicPics(
                                              tokenAuth: widget.tokenAuth,
                                                username: singlePhoto
                                                    .data
                                                    .attributes
                                                    .comments[index]
                                                    .username,
                                                userId: singlePhoto
                                                    .data
                                                    .attributes
                                                    .comments[index]
                                                    .userId),
                                          ));
                                    },
                                  ),
                                  subtitle: new Text(singlePhoto
                                      .data.attributes.comments[index].content),
                                ),
                              ],
                            );
                          }),
                ),
              ),
            ],
          ),
        ));
  }

  Future<SinglePhoto> fetchSinglePhoto(String id) async {
    var url = 'http://10.0.2.2:4000/api/photos/$id';
    var headers = widget.tokenAuth != null
        ? {"Authorization": widget.tokenAuth.tokenData.token}
        : null;
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      setState(() {
        singlePhoto = SinglePhoto.fromJson(json.decode(response.body));
      });
      return SinglePhoto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<void> logoutRequest() async {
    var url = 'http://10.0.2.2:4000/api/session';
    final response = await http.delete(url,
        headers: {"Authorization": widget.tokenAuth.tokenData.token});
  }

  _showToast() {
    FocusScope.of(context).requestFocus(FocusNode());
    Fluttertoast.showToast(
        msg: "Comment can't be empty!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1);
  }

  _postComment(BuildContext context, String text) async {
    var url = 'http://10.0.2.2:4000/api/comments';
    final response = await http.post(url,
        headers: {"Authorization": widget.tokenAuth.tokenData.token},
        body: {"comment[photo_id]": widget.image.id, "comment[content]": text});

    if (response.statusCode == 201) {
      await fetchSinglePhoto(widget.image.id);
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "Sucessfully commented!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    } else {
      Fluttertoast.showToast(
          msg: "Something wrong!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
    }
  }
}
