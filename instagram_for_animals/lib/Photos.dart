class Photos {
  List<Data> data;

  Photos({this.data});

  Photos.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String type;
  String id;
  Attributes attributes;

  Data({this.type, this.id, this.attributes});

  Data.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    if (this.attributes != null) {
      data['attributes'] = this.attributes.toJson();
    }
    return data;
  }
}

class Attributes {
  String username;
  int userId;
  int size;
  bool public;
  String path;
  String filename;
  String extension;
  String description;
  String contentType;
  List<Comments> comments;

  Attributes(
      {this.username,
      this.userId,
      this.size,
      this.public,
      this.path,
      this.filename,
      this.extension,
      this.description,
      this.contentType,
      this.comments});

  Attributes.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    userId = json['user-id'];
    size = json['size'];
    public = json['public'];
    path = json['path'];
    filename = json['filename'];
    extension = json['extension'];
    description = json['description'];
    contentType = json['content-type'];
    if (json['comments'] != null) {
      comments = new List<Comments>();
      json['comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['user-id'] = this.userId;
    data['size'] = this.size;
    data['public'] = this.public;
    data['path'] = this.path;
    data['filename'] = this.filename;
    data['extension'] = this.extension;
    data['description'] = this.description;
    data['content-type'] = this.contentType;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comments {
  String username;
  int userId;
  String updatedAt;
  int photoId;
  String insertedAt;
  int id;
  String content;

  Comments(
      {this.username,
      this.userId,
      this.updatedAt,
      this.photoId,
      this.insertedAt,
      this.id,
      this.content});

  Comments.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    userId = json['user_id'];
    updatedAt = json['updated_at'];
    photoId = json['photo_id'];
    insertedAt = json['inserted_at'];
    id = json['id'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['user_id'] = this.userId;
    data['updated_at'] = this.updatedAt;
    data['photo_id'] = this.photoId;
    data['inserted_at'] = this.insertedAt;
    data['id'] = this.id;
    data['content'] = this.content;
    return data;
  }
}
