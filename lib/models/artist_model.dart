class ArtistsModel {
  bool? status;
  String? message;
  List<PopularArtitst>? popularArtitst;

  ArtistsModel({this.status, this.message, this.popularArtitst});

  ArtistsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['popularArtitst'] != null) {
      popularArtitst = <PopularArtitst>[];
      json['popularArtitst'].forEach((v) {
        popularArtitst!.add(PopularArtitst.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (popularArtitst != null) {
      data['popularArtitst'] =
          popularArtitst!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PopularArtitst {
  String? id;
  String? name;
  String? picture;

  PopularArtitst({this.id, this.name, this.picture});

  PopularArtitst.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['picture'] = picture;
    return data;
  }
}
