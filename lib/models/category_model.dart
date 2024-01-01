// class HomeCategoryModel {
//   bool? status;
//   String? message;
//   List<Data>? data;

//   HomeCategoryModel({this.status, this.message, this.data});

//   HomeCategoryModel.fromJson(Map<String, dynamic> json) {
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
//   String? category;
//   List<CategoryDatas>? categoryData;

//   Data({this.category, this.categoryData});

//   Data.fromJson(Map<String, dynamic> json) {
//     category = json['category'];
//     if (json['category_data'] != null) {
//       categoryData = <CategoryDatas>[];
//       json['category_data'].forEach((v) {
//         categoryData!.add(CategoryDatas.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['category'] = category;
//     if (categoryData != null) {
//       data['category_data'] = categoryData!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class CategoryDatas {
//   String? id;
//   String? albumId;
//   String? title;
//   String? description;
//   String? duration;
//   String? audio;
//   String? image;
//   bool? isLiked;
//   // ignore: non_constant_identifier_names
//   bool? is_queue;

//   CategoryDatas(
//       {this.id,
//       this.albumId,
//       this.title,
//       this.description,
//       this.duration,
//       this.audio,
//       this.image,
//       this.isLiked,
//       // ignore: non_constant_identifier_names
//       this.is_queue});

//   CategoryDatas.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     albumId = json['album_id'];
//     title = json['title'];
//     description = json['description'];
//     duration = json['duration'];
//     audio = json['audio'];
//     image = json['image'];
//     isLiked = json['is_likes'];
//     is_queue = json['is_queue'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['album_id'] = albumId;
//     data['title'] = title;
//     data['description'] = description;
//     data['duration'] = duration;
//     data['audio'] = audio;
//     data['image'] = image;
//     data['is_likes'] = isLiked;
//     data['is_queue'] = is_queue;
//     return data;
//   }
// }


class HomeCategoryModel {
  bool? status;
  String? message;
  List<Data>? data;

  HomeCategoryModel({this.status, this.message, this.data});

  HomeCategoryModel.fromJson(Map<String, dynamic> json) {
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
  String? category;
  String? type;
  List<CategoryDatas>? categoryData;

  Data({this.category, this.type, this.categoryData});

  Data.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    type = json['type'];
    if (json['category_data'] != null) {
      categoryData = <CategoryDatas>[];
      json['category_data'].forEach((v) {
        categoryData!.add(CategoryDatas.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    data['type'] = type;
    if (categoryData != null) {
      data['category_data'] =
          categoryData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CategoryDatas {
  String? id;
  String? albumId;
  String? title;
  String? description;
  String? duration;
  String? audio;
  String? image;
  bool? isLiked;
  // ignore: non_constant_identifier_names
  bool? is_queue;
  String? artistId;
  String? playlistId;
  String? songCount;

  CategoryDatas(
      {this.id,
      this.albumId,
      this.title,
      this.description,
      this.duration,
      this.audio,
      this.image,
      this.isLiked,
      // ignore: non_constant_identifier_names
      this.is_queue,
      this.artistId,
      this.playlistId,
      this.songCount,
      });

  CategoryDatas.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    albumId = json['album_id'];
    title = json['title'];
    description = json['description'];
    duration = json['duration'];
    audio = json['audio'];
    image = json['image'];
    isLiked = json['is_likes'];
    is_queue = json['is_queue'];
    artistId = json['artist_id'];
    playlistId = json['playlist_id'];
    songCount = json['songCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['album_id'] = albumId;
    data['title'] = title;
    data['description'] = description;
    data['duration'] = duration;
    data['audio'] = audio;
    data['image'] = image;
    data['is_likes'] = isLiked;
    data['is_queue'] = is_queue;
    data['artist_id'] = artistId;
    data['playlist_id'] = playlistId;
    data['songCount'] = songCount;
    return data;
  }
}
