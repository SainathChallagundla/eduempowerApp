class User {
  final String id;
  final String name;
  final String email;
  final String mobile;
  final String userCategory;
  final String userType;
  final String role;
  final String password;
  final String status;
  final String lastUpdated;

  User(
      {this.id,
      this.name,
      this.email,
      this.mobile,
      this.userCategory,
      this.userType,
      this.role,
      this.password,
      this.status,
      this.lastUpdated});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      userCategory: json['userCategory'],
      userType: json['userType'],
      role: json['role'],
      password: json['password'],
      status: json['status'],
      lastUpdated: json['lastUpdated'],
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["name"] = name;
    map["email"] = email;
    map["mobile"] = mobile;
    map["userCategory"] = userCategory;
    map["userType"] = userType;
    map["role"] = role;
    map["password"] = password;
    map["status"] = status;
    return map;
  }
}

class UserLogIn {
  final String email;
  final String password;

  UserLogIn({this.email, this.password});

  factory UserLogIn.fromJson(Map<String, dynamic> json) {
    return UserLogIn(
      email: json['email'],
      password: json['password'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["email"] = email;
    map["password"] = password;
    return map;
  }

  Map<String, dynamic> toJson() => {"email": email, "password": password};
}

class ResetPassword {
  final String email;
  final String verifyCode;
  final String password;

  ResetPassword({this.email, this.verifyCode, this.password});
  factory ResetPassword.fromJson(Map<String, dynamic> json) {
    return ResetPassword(
      email: json['email'],
      verifyCode: json['verifyCode'],
      password: json['password'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["email"] = email;
    map["verifyCode"] = verifyCode;
    map["password"] = password;
    return map;
  }

  Map<String, dynamic> toJson() =>
      {"email": email, "verifyCode": verifyCode, "password": password};
}
