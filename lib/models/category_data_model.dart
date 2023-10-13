class CategoryData {
  bool? status;
  String? message;
  List<Data>? data;

  CategoryData({this.status, this.message, this.data});

  CategoryData.fromJson(Map<String, dynamic> json) {
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
  String? albumId;
  String? title;
  String? description;
  String? duration;
  String? audio;
  late String? image;
  bool? isLiked;
  String? totalLikes;

  Data({
    this.id,
    this.albumId,
    this.title,
    this.description,
    this.duration,
    this.audio,
    required this.image,
    this.isLiked,
    this.totalLikes,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    albumId = json['album_id'];
    title = json['title'];
    description = json['description'];
    duration = json['duration'];
    audio = json['audio'];
    image = json['image'];
    isLiked = json['is_likes'];
    totalLikes = json['total_likes'];
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
    data['total_likes'] = totalLikes;
    return data;
  }
}
