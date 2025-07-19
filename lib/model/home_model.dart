class HomeModel {
  List<Family>? family;
  List<Name>? name;
  List<Relation>? relation;
  List<Sex>? sex;
  List<Membership>? membership;
  List<Profession>? profession;
  List<Qualification>? qualification;
  List<LivingStatus>? livingStatus;
  List<MartialStatus>? martialStatus;
  List<BirthPlace>? birthPlace;
  List<BirthStar>? birthStar;
  List<BloodGroup>? bloodGroup;
  List<NativePlace>? nativePlace;
  List<SubCaste>? subCaste;
  List<SubSector>? subSector;

  HomeModel({
    this.family,
    this.name,
    this.relation,
    this.sex,
    this.membership,
    this.profession,
    this.qualification,
    this.livingStatus,
    this.martialStatus,
    this.birthPlace,
    this.birthStar,
    this.bloodGroup,
    this.nativePlace,
    this.subCaste,
    this.subSector,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    return HomeModel(
      family: (json['Family'] as List?)
          ?.map((e) => Family.fromJson(e))
          .toList(),
      name: (json['Name'] as List?)?.map((e) => Name.fromJson(e)).toList(),
      relation: (json['Relation'] as List?)
          ?.map((e) => Relation.fromJson(e))
          .toList(),
      sex: (json['Sex'] as List?)?.map((e) => Sex.fromJson(e)).toList(),
      membership: (json['Membership'] as List?)
          ?.map((e) => Membership.fromJson(e))
          .toList(),
      profession: (json['Profession'] as List?)
          ?.map((e) => Profession.fromJson(e))
          .toList(),
      qualification: (json['Qualification'] as List?)
          ?.map((e) => Qualification.fromJson(e))
          .toList(),
      livingStatus: (json['LivingStatus'] as List?)
          ?.map((e) => LivingStatus.fromJson(e))
          .toList(),
      martialStatus: (json['MartialStatus'] as List?)
          ?.map((e) => MartialStatus.fromJson(e))
          .toList(),
      birthPlace: (json['BirthPlace'] as List?)
          ?.map((e) => BirthPlace.fromJson(e))
          .toList(),
      birthStar: (json['BirthStar'] as List?)
          ?.map((e) => BirthStar.fromJson(e))
          .toList(),
      bloodGroup: (json['BloodGroup'] as List?)
          ?.map((e) => BloodGroup.fromJson(e))
          .toList(),
      nativePlace: (json['NativePlace'] as List?)
          ?.map((e) => NativePlace.fromJson(e))
          .toList(),
      subCaste: (json['SubCaste'] as List?)
          ?.map((e) => SubCaste.fromJson(e))
          .toList(),
      subSector: (json['SubSector'] as List?)
          ?.map((e) => SubSector.fromJson(e))
          .toList(),
    );
  }
}

// Family
class Family {
  int? pID;
  int? resID;
  String? code;
  String? photo;
  String? sex;
  String? name;
  String? address1;
  String? aDate;
  int? updated;

  Family({
    this.pID,
    this.resID,
    this.code,
    this.photo,
    this.sex,
    this.name,
    this.address1,
    this.aDate,
    this.updated,
  });

  factory Family.fromJson(Map<String, dynamic> json) => Family(
    pID: json['PID'],
    resID: json['ResID'],
    code: json['Code'],
    photo: json['Photo'],
    sex: json['sex'],
    name: json['name'],
    address1: json['Address1'],
    aDate: json['ADate'],
    updated: json['Updated'],
  );
}

// Simple model with value
class Name {
  String? value;
  Name({this.value});
  factory Name.fromJson(Map<String, dynamic> json) =>
      Name(value: json['value']);
}

class Relation {
  String? value;
  Relation({this.value});
  factory Relation.fromJson(Map<String, dynamic> json) =>
      Relation(value: json['value']);
}

class Sex {
  String? value;
  Sex({this.value});
  factory Sex.fromJson(Map<String, dynamic> json) => Sex(value: json['value']);
}

class Membership {
  String? value;
  Membership({this.value});
  factory Membership.fromJson(Map<String, dynamic> json) =>
      Membership(value: json['value']);
}

class Profession {
  String? value;
  Profession({this.value});
  factory Profession.fromJson(Map<String, dynamic> json) =>
      Profession(value: json['value']);
}

class Qualification {
  String? value;
  Qualification({this.value});
  factory Qualification.fromJson(Map<String, dynamic> json) =>
      Qualification(value: json['value']);
}

class LivingStatus {
  String? value;
  LivingStatus({this.value});
  factory LivingStatus.fromJson(Map<String, dynamic> json) =>
      LivingStatus(value: json['value']);
}

class MartialStatus {
  String? value;
  MartialStatus({this.value});
  factory MartialStatus.fromJson(Map<String, dynamic> json) =>
      MartialStatus(value: json['value']);
}

class BirthPlace {
  String? value;
  BirthPlace({this.value});
  factory BirthPlace.fromJson(Map<String, dynamic> json) =>
      BirthPlace(value: json['value']);
}

class BirthStar {
  String? value;
  BirthStar({this.value});
  factory BirthStar.fromJson(Map<String, dynamic> json) =>
      BirthStar(value: json['value']);
}

class BloodGroup {
  String? value;
  BloodGroup({this.value});
  factory BloodGroup.fromJson(Map<String, dynamic> json) =>
      BloodGroup(value: json['value']);
}

class NativePlace {
  String? value;
  NativePlace({this.value});
  factory NativePlace.fromJson(Map<String, dynamic> json) =>
      NativePlace(value: json['value']);
}

class SubCaste {
  String? value;
  SubCaste({this.value});
  factory SubCaste.fromJson(Map<String, dynamic> json) =>
      SubCaste(value: json['value']);
}

class SubSector {
  String? value;
  SubSector({this.value});
  factory SubSector.fromJson(Map<String, dynamic> json) =>
      SubSector(value: json['value']);
}
