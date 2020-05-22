class TokenAuth {
  TokenData tokenData;

  TokenAuth({this.tokenData});

  TokenAuth.fromJson(Map<String, dynamic> json) {
    tokenData = json['data'] != null
        ? new TokenData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tokenData != null) {
      data['data'] = this.tokenData.toJson();
    }
    return data;
  }
}

class TokenData {
  String token;
  String renewToken;
  String username;
  int id;

  TokenData({this.token, this.renewToken, this.id, this.username});

  TokenData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    renewToken = json['renew_token'];
    username = json['username'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['renew_token'] = this.renewToken;
    data['username'] = this.username;
    data['id'] = this.id;
    return data;
  }
}