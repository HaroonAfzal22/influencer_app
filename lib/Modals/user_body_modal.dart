class UserModelBody {
  String? uid;
  String? name;
  String? surename;
  String? email;
  String? photoUrl = '';
  String? userRole = '';
  String? phone;
  var time;
  String? status = '';
  var password;

  UserModelBody(
      {this.email,
      this.name,
      this.surename,
      this.photoUrl,
      this.uid,
      this.userRole,
      this.phone,
      this.time,
      this.status,
      this.password});

  factory UserModelBody.fromJson(Map<String, dynamic> json) {
    return UserModelBody(
      email: json['email'],
      name: json['firstName'],
      surename: json['surename'],
      photoUrl: json['photoUrl'],
      userRole: json['userRole'],
      uid: json['uid'],
      phone: json['phone'],
      status: json['status'],
      time: json['time'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['uid'] = uid;
    data['firstName'] = name;
    data['surename'] = surename;
    data['password'] = password;
    data['email'] = email;
    data['photoUrl'] = photoUrl;
    data['phone'] = phone;
    data['time'] = time;
    data['userRole'] = userRole;
    data['time'] = time;
    data['status'] = status;

    return data;
  }
}
