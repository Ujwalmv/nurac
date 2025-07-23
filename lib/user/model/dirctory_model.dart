class DirectoryModel {
  int? pID;
  int? resID;
  String? code;
  String? photo;
  String? sex;
  String? name;
  String? mobile;
  String? phone1;
  String? phone2;
  String? address1;

  DirectoryModel(
      {this.pID,
        this.resID,
        this.code,
        this.photo,
        this.sex,
        this.name,
        this.mobile,
        this.phone1,
        this.phone2,
        this.address1});

  DirectoryModel.fromJson(Map<String, dynamic> json) {
    pID = json['PID'];
    resID = json['ResID'];
    code = json['Code'];
    photo = json['Photo'];
    sex = json['sex'];
    name = json['name'];
    mobile = json['mobile'];
    phone1 = json['Phone1'];
    phone2 = json['Phone2'];
    address1 = json['Address1'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PID'] = this.pID;
    data['ResID'] = this.resID;
    data['Code'] = this.code;
    data['Photo'] = this.photo;
    data['sex'] = this.sex;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['Phone1'] = this.phone1;
    data['Phone2'] = this.phone2;
    data['Address1'] = this.address1;
    return data;
  }
}
