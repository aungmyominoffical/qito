class ProfileModal {
  String? username;
  String? password;
  String? expire;
  String? type;
  String? deviceid;

  ProfileModal({this.username, this.password, this.expire, this.type,required this.deviceid});

  ProfileModal.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    expire = json['expire'];
    type = json['type'];
    deviceid = json["deviceid"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['expire'] = this.expire;
    data['type'] = this.type;
    data["deviceid"] = this.deviceid;
    return data;
  }
}
