class LoginResponse {
  final int key;
  final int associationID;
  final String associationName;
  final String name;
  final int type;
  final String mobile;

  LoginResponse({
    required this.key,
    required this.associationID,
    required this.associationName,
    required this.name,
    required this.type,
    required this.mobile,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      key: json['key'],
      associationID: json['AssociationID'],
      associationName: json['AssociationName'],
      name: json['name'],
      type: json['type'],
      mobile: json['Mobile'],
    );
  }
}
