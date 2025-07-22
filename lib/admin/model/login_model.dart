class LoginResponse {
  String? userType;
  int? key;
  int? associationID;
  String? associationName;
  String? name;
  int? type;
  String? mobile;

  LoginResponse(
      {this.userType,
        this.key,
        this.associationID,
        this.associationName,
        this.name,
        this.type,
        this.mobile});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    userType = json['UserType'];
    key = json['key'];
    associationID = json['AssociationID'];
    associationName = json['AssociationName'];
    name = json['name'];
    type = json['type'];
    mobile = json['Mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserType'] = this.userType;
    data['key'] = this.key;
    data['AssociationID'] = this.associationID;
    data['AssociationName'] = this.associationName;
    data['name'] = this.name;
    data['type'] = this.type;
    data['Mobile'] = this.mobile;
    return data;
  }
}

class LoginUserResponse {
  String? userType;
  int? userID;
  String? username;
  int? resID;
  int? associationID;
  String? associationName;
  String? mobile;

  LoginUserResponse(
      {this.userType,
        this.userID,
        this.username,
        this.resID,
        this.associationID,
        this.associationName,
        this.mobile});

  LoginUserResponse.fromJson(Map<String, dynamic> json) {
    userType = json['UserType'];
    userID = json['UserID'];
    username = json['Username'];
    resID = json['ResID'];
    associationID = json['AssociationID'];
    associationName = json['AssociationName'];
    mobile = json['Mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserType'] = this.userType;
    data['UserID'] = this.userID;
    data['Username'] = this.username;
    data['ResID'] = this.resID;
    data['AssociationID'] = this.associationID;
    data['AssociationName'] = this.associationName;
    data['Mobile'] = this.mobile;
    return data;
  }
}
