// class ProfileModel {
//   bool? success;
//   String? message;
//   Data? data;

//   ProfileModel({this.success, this.message, this.data});

//   ProfileModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['success'] = success;
//     data['message'] = message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }

// class Data {
//   String? id;
//   String? name;
//   String? email;
//   String? mobileNo;
//   String? address;
//   String? profilePic;
//   String? createdAt;
//   String? updatedAt;

//   Data(
//       {this.id,
//       this.name,
//       this.email,
//       this.mobileNo,
//       this.address,
//       this.profilePic,
//       this.createdAt,
//       this.updatedAt});

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     email = json['email'];
//     mobileNo = json['mobile_no'];
//     address = json['address'];
//     profilePic = json['profile_pic'];
//     createdAt = json['created_at'];
//     updatedAt = json['updated_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['name'] = name;
//     data['email'] = email;
//     data['mobile_no'] = mobileNo;
//     data['address'] = address;
//     data['profile_pic'] = profilePic;
//     data['created_at'] = createdAt;
//     data['updated_at'] = updatedAt;
//     return data;
//   }
// }
