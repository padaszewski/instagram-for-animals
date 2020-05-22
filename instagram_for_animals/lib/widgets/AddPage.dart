import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_for_animals/CurrentUser.dart';
import 'package:instagram_for_animals/TokenAuth.dart';
import 'package:multipart_request/multipart_request.dart';

import 'Profile.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  File _image;
  String urlToDeepDream;
  Image networkImage;
  bool _isSwitchedDeepDream = false;
  bool _private = false;
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Profile(
                            tokenAuth: new TokenAuth(),
                          )),
                );
              },
            ),
            title: new Text("Add Your pic!")),
        body: new Container(
          margin: EdgeInsets.only(top: 20),
          child: Center(
            child: Column(
              children: <Widget>[
                new RaisedButton(
                    onPressed: () async {
                      File file =
                          await FilePicker.getFile(type: FileType.image);
                      if (file != null) {
                        _fetchDeepDreamVersion(file);
                        setState(() {
                          _image = file;
                          urlToDeepDream = null;
                          _isSwitchedDeepDream = false;
                        });
                      }
                    },
                    child: Text("Choose Photo to add!")),
                _image != null
                    ? new Container(
                        margin: EdgeInsets.all(20),
                        constraints: BoxConstraints.tightFor(
                            height: MediaQuery.of(context).size.height / 3),
                        child: _isSwitchedDeepDream == false
                            ? Image.file(
                                _image,
                                fit: BoxFit.fill,
                              )
                            : networkImage)
                    : new Container(),
                urlToDeepDream != null
                    ? Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.height / 2,
                            child: TextField(
                              controller: controller,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                  labelText: "Description",
                                  prefixIcon: Icon(Icons.description),
                                  border: InputBorder.none,
                                  hintText: 'Enter a search term'),
                            ),
                          ),
                          Text("Private?"),
                          Switch(
                            value: _private,
                            onChanged: (value) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                _private = value;
                              });
                            },
                          ),
                          Text("DeepDream?"),
                          Switch(
                            value: _isSwitchedDeepDream,
                            onChanged: (value) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              setState(() {
                                _isSwitchedDeepDream = value;
                              });
                            },
                          ),
                          RaisedButton(
                            child: Text("Add this photo!"),
                            onPressed: () {
                              postPhotoToServer(_image);
                            },
                          )
                        ],
                      )
                    : _prep(),
              ],
            ),
          ),
        ));
  }

  Future<void> _fetchDeepDreamVersion(File file) async {
    var request = MultipartRequest();
    request.setUrl("https://api.deepai.org/api/deepdream");
    request.addHeader("api-key", 'fa468b24-db82-4c2a-aadb-2cd51aba36de');

    request.addFile("image", file.path);

    Response response = request.send();

    response.onError = () {
      print("Error");
    };

    response.onComplete = (response) {
      setState(() {
        urlToDeepDream = jsonDecode(response)["output_url"];
        networkImage = Image.network(
          urlToDeepDream,
          fit: BoxFit.fill,
        );
        precacheImage(networkImage.image, context);
      });
      print("------------------------------------------------------");
    };

//    response.progress.listen((int progress) {
//      print("progress from response object " + progress.toString());
//    });
  }

  _prep() {
    if (_image == null) return Container();
    return new Column(mainAxisSize: MainAxisSize.min, children: [
      new CircularProgressIndicator(),
      new Text("Preparing Your image.")
    ]);
  }

  Future<void> postPhotoToServer(File file) {
    if (controller.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please provide some desciption!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
      return null;
    }
    var request = MultipartRequest();
    request.setUrl("http://10.0.2.2:4000/api/photos");
    request.addHeader("Authorization", CurrentUser.tokenData.token);
    request.addField("photo[description]", controller.text);
    request.addField("photo[public]", (!_private).toString());

    request.addFile("photo[file]", file.path);

    Response response = request.send();

    response.onError = () {
      print("Error");
    };

    response.onComplete = (response) {
      Fluttertoast.showToast(
          msg: "Pic sucessfully added!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Profile(
                  tokenAuth: new TokenAuth(),
                )),
      );
    };
    return null;
  }
}
