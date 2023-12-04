// class MyPlaylistDataModel {
//   bool? success;
//   String? message;
//   List<Data>? data;

//   MyPlaylistDataModel({this.success, this.message, this.data});

//   MyPlaylistDataModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
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
//     data['success'] = success;
//     data['message'] = message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Data {
//   String? id;
//   String? plTitle;
//   String? plDescripton;
//   String? plImage;
//   String? tracks;
//   bool? inPlayList;

//   Data({this.id, this.plTitle, this.plDescripton, this.plImage,this.tracks, this.inPlayList});

//   Data.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     plTitle = json['pl_title'];
//     plDescripton = json['pl_descripton'];
//     plImage = json['pl_image'];
//     tracks = json['tracks'];
//     inPlayList = json['inPlayList'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['pl_title'] = plTitle;
//     data['pl_descripton'] = plDescripton;
//     data['pl_image'] = plImage;
//     data['tracks'] = tracks;
//     data['inPlayList'] = inPlayList;
//     return data;
//   }
// }

class MyPlaylistDataModel {
  bool? success;
  String? message;
  List<Data>? data;

  MyPlaylistDataModel({this.success, this.message, this.data});

  MyPlaylistDataModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
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
    data['success'] = success;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? plTitle;
  String? plDescripton;
  List<String>? plImage;
  String? tracks;
  bool? inPlayList;

  Data(
      {this.id,
      this.plTitle,
      this.plDescripton,
      this.plImage,
      this.tracks,
      this.inPlayList});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plTitle = json['pl_title'];
    plDescripton = json['pl_descripton'];
    plImage = json['pl_image'].cast<String>();
    tracks = json['tracks'];
    inPlayList = json['inPlayList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['pl_title'] = plTitle;
    data['pl_descripton'] = plDescripton;
    data['pl_image'] = plImage;
    data['tracks'] = tracks;
    data['inPlayList'] = inPlayList;
    return data;
  }
}
