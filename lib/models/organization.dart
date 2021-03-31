
class Organization {
  final String id;
  final UserDetails user;
  final String name;
  final String webSite;
  final String moreInfo;
  final String address;
  final String city;
  final String state;
  final String country;
  final String pinCode;
  final String socialMedia;
  final String status;
 

  Organization(
      {this.id,
      this.user,
      this.name,
      this.webSite,
      this.moreInfo,
      this.address,
      this.city,
      this.state,
      this.country,
      this.pinCode,
      this.socialMedia,
      this.status,
     });

  factory Organization.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw FormatException("Null JSON provided to Individual");
    }
    return Organization(
      id: json['id'],
      user: UserDetails.fromJson(json['user']),
      name:json['name'],
      webSite: json['webSite'],
      moreInfo: json['moreInfo'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      pinCode: json['pinCode'],
      socialMedia: json['socialMedia'],
      status: json['status'],
  
    );
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["user"] = user;
    map["name"]=name;
    map["webSite"] = webSite;
    map["moreInfo"] = moreInfo;
    map["address"] = address;
    map["city"] = city;
    map["state"] = state;
    map["country"] = country;
    map["pinCode"] = pinCode;
    map["socialMedia"] = socialMedia;
    map["status"] = status;
   
    return map;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "name":name,
        "webSite": webSite,
        "moreInfo": moreInfo,
        "address": address,
        "city": city,
        "state": state,
        "country": country,
        "pinCode": pinCode,
        "socialMedia": socialMedia,
        "status": status,
       
      };
}

class UserDetails {
  final String email;
  UserDetails({this.email});
  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(email: json['email']);
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["email"] = email;
    return map;
  }

  Map<String, dynamic> toJson() => {
        "email": email,
      };
}
