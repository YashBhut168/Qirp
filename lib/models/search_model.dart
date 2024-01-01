// class AllSearchModel {
//   bool? status;
//   String? message;
//   List<Data>? data;

//   AllSearchModel({this.status, this.message, this.data});

//   AllSearchModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(Data.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['message'] = message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }


// class Data {
//   String? id;
//   String? type;
//   String? title;
//   String? image;

//   Data({this.id, this.type, this.title, this.image});

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     type = json['type'];
//     title = json['title'];
//     image = json['image'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['type'] = type;
//     data['title'] = title;
//     data['image'] = image;
//     return data;
//   }
// }


class AllSearchModel {
  bool? status;
  String? message;
  List<Data>? data;

  AllSearchModel({this.status, this.message, this.data});

  AllSearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? type;
  String? title;
  String? description;
  String? image;
  String? audio;
  bool? isLiked;
  // ignore: non_constant_identifier_names
  bool? is_queue;

  Data(
      {this.id,
      this.type,
      this.title,
      this.description,
      this.image,
      this.audio,
      this.isLiked,
      // ignore: non_constant_identifier_names
      this.is_queue});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    audio = json['audio'];
    isLiked = json['is_likes'];
    is_queue = json['is_queue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['audio'] = audio;
    data['is_likes'] = isLiked;
    data['is_queue'] = is_queue;
    return data;
  }
}
