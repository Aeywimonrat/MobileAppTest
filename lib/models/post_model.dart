import 'dart:convert';

class PostModel {
  final String title;
  final String detail;
  final String uidPost;
  final String timePost;
  final String urlImage;
  final String namePost;
  PostModel({
    this.title,
    this.detail,
    this.uidPost,
    this.timePost,
    this.urlImage,
    this.namePost,
  });


  PostModel copyWith({
    String title,
    String detail,
    String uidPost,
    String timePost,
    String urlImage,
    String namePost,
  }) {
    return PostModel(
      title: title ?? this.title,
      detail: detail ?? this.detail,
      uidPost: uidPost ?? this.uidPost,
      timePost: timePost ?? this.timePost,
      urlImage: urlImage ?? this.urlImage,
      namePost: namePost ?? this.namePost,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'detail': detail,
      'uidPost': uidPost,
      'timePost': timePost,
      'urlImage': urlImage,
      'namePost': namePost,
    };
  }

  factory PostModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return PostModel(
      title: map['title'],
      detail: map['detail'],
      uidPost: map['uidPost'],
      timePost: map['timePost'],
      urlImage: map['urlImage'],
      namePost: map['namePost'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PostModel.fromJson(String source) => PostModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PostModel(title: $title, detail: $detail, uidPost: $uidPost, timePost: $timePost, urlImage: $urlImage, namePost: $namePost)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is PostModel &&
      o.title == title &&
      o.detail == detail &&
      o.uidPost == uidPost &&
      o.timePost == timePost &&
      o.urlImage == urlImage &&
      o.namePost == namePost;
  }

  @override
  int get hashCode {
    return title.hashCode ^
      detail.hashCode ^
      uidPost.hashCode ^
      timePost.hashCode ^
      urlImage.hashCode ^
      namePost.hashCode;
  }
  }
