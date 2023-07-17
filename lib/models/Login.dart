import 'dart:convert';

Login loginResponseJson (String str) =>
    Login.fromJson(json.decode(str));

class Login {
  Login({
    required this.token,
    required this.user,
  });
  late final String token;
  late final User user;

  Login.fromJson(Map<String, dynamic> json){
    token = json['token'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['token'] = token;
    _data['user'] = user.toJson();
    return _data;
  }
}

class User {
  User({
    required this.phoneNum,
    required this.username,
  });
  late final int phoneNum;
  late final String username;

  User.fromJson(Map<String, dynamic> json){
    phoneNum = json['phoneNum'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['phoneNum'] = phoneNum;
    _data['username'] = username;
    return _data;
  }
}