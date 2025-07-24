class DetailsModel {
  int? resID;
  String? code;
  String? address1;
  String? phone1;
  String? phone2;
  int? associationID;
  List<Details>? details;
  String? location;
  String? latitude;
  String? longitude;

  DetailsModel({
    this.resID,
    this.code,
    this.address1,
    this.phone1,
    this.phone2,
    this.associationID,
    this.details,
    this.location,
    this.latitude,
    this.longitude,
  });

  DetailsModel.fromJson(Map<String, dynamic> json) {
    resID = json['ResID'];
    code = json['Code'];
    address1 = json['Address1'];
    phone1 = json['Phone1'];
    phone2 = json['Phone2'];
    associationID = json['AssociationID'];
    location = json['Location'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];

    if (json['Details'] != null) {
      details = <Details>[];
      json['Details'].forEach((v) {
        details!.add(Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResID'] = resID;
    data['Code'] = code;
    data['Address1'] = address1;
    data['Phone1'] = phone1;
    data['Phone2'] = phone2;
    data['AssociationID'] = associationID;
    data['Location'] = location;
    data['Latitude'] = latitude;
    data['Longitude'] = longitude;

    if (details != null) {
      data['Details'] = details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Details {
  int? pID;
  int? resID;
  String? photo;
  String? name;
  String? relation;
  String? sex;
  String? dob;
  String? profession;
  String? qualification;
  String? email;
  String? mobile;
  String? livingstatus;
  String? bename;
  String? fname;
  String? mname;
  String? status;
  String? birthplace;
  String? birthstar;
  String? bloodgroup;
  String? children;
  String? nativeplace;
  String? poffice;
  String? subcaste;
  String? subsector;

  Details(
      {this.pID,
        this.resID,
        this.photo,
        this.name,
        this.relation,
        this.sex,
        this.dob,
        this.profession,
        this.qualification,
        this.email,
        this.mobile,
        this.livingstatus,
        this.bename,
        this.fname,
        this.mname,
        this.status,
        this.birthplace,
        this.birthstar,
        this.bloodgroup,
        this.children,
        this.nativeplace,
        this.poffice,
        this.subcaste,
        this.subsector});

  Details.fromJson(Map<String, dynamic> json) {
    pID = json['PID'];
    resID = json['ResID'];
    photo = json['Photo'];
    name = json['name'];
    relation = json['relation'];
    sex = json['sex'];
    dob = json['dob'];
    profession = json['profession'];
    qualification = json['qualification'];
    email = json['email'];
    mobile = json['mobile'];
    livingstatus = json['livingstatus'];
    bename = json['bename'];
    fname = json['fname'];
    mname = json['mname'];
    status = json['status'];
    birthplace = json['birthplace'];
    birthstar = json['birthstar'];
    bloodgroup = json['bloodgroup'];
    children = json['children'];
    nativeplace = json['nativeplace'];
    poffice = json['poffice'];
    subcaste = json['subcaste'];
    subsector = json['subsector'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PID'] = this.pID;
    data['ResID'] = this.resID;
    data['Photo'] = this.photo;
    data['name'] = this.name;
    data['relation'] = this.relation;
    data['sex'] = this.sex;
    data['dob'] = this.dob;
    data['profession'] = this.profession;
    data['qualification'] = this.qualification;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['livingstatus'] = this.livingstatus;
    data['bename'] = this.bename;
    data['fname'] = this.fname;
    data['mname'] = this.mname;
    data['status'] = this.status;
    data['birthplace'] = this.birthplace;
    data['birthstar'] = this.birthstar;
    data['bloodgroup'] = this.bloodgroup;
    data['children'] = this.children;
    data['nativeplace'] = this.nativeplace;
    data['poffice'] = this.poffice;
    data['subcaste'] = this.subcaste;
    data['subsector'] = this.subsector;
    return data;
  }
}
