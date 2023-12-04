class ProfileModel {
  String? message;
  Profile? profile;

  ProfileModel({this.message, this.profile});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    profile =
        json['profile'] != null ? Profile.fromJson(json['profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

class Profile {
  String? id;
  String? name;
  String? email;
  String? mobileNo;
  String? address;
  String? profilePic;
  String? age;
  String? gender;
  String? createdAt;
  String? updatedAt;

  Profile(
      {this.id,
      this.name,
      this.email,
      this.mobileNo,
      this.address,
      this.profilePic,
      this.age,
      this.gender,
      this.createdAt,
      this.updatedAt});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    address = json['address'];
    profilePic = json['profile_pic'];
    age = json['age'];
    gender = json['gender'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['mobile_no'] = mobileNo;
    data['address'] = address;
    data['profile_pic'] = profilePic;
    data['age'] = age;
    data['gender'] = gender;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
