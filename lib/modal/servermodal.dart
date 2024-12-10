class ServerModal {
  String? type;
  String? expire;
  Server? server;
  Country? country;

  ServerModal({this.type, this.expire, this.server, this.country});

  ServerModal.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    expire = json['expire'];
    server =
    json['server'] != null ? new Server.fromJson(json['server']) : null;
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['expire'] = this.expire;
    if (this.server != null) {
      data['server'] = this.server!.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    return data;
  }
}

class Server {
  String? ip;
  int? port;
  String? method;
  String? password;

  Server({this.ip, this.port, this.method, this.password});

  Server.fromJson(Map<String, dynamic> json) {
    ip = json['ip'];
    port = json['port'];
    method = json['method'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ip'] = this.ip;
    data['port'] = this.port;
    data['method'] = this.method;
    data['password'] = this.password;
    return data;
  }
}

class Country {
  String? server;
  String? flag;

  Country({this.server, this.flag});

  Country.fromJson(Map<String, dynamic> json) {
    server = json['server'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['server'] = this.server;
    data['flag'] = this.flag;
    return data;
  }
}
