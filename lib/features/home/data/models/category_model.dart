// Dart imports:
import 'dart:convert';

class CategoryModel {
  String title;
  String image;
  CategoryModel({
    required this.title,
    required this.image,
  });

  CategoryModel copyWith({
    String? title,
    String? image,
  }) {
    return CategoryModel(
      title: title ?? this.title,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'image': image,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      title: map['title'] ?? '',
      image: map['image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));

  @override
  String toString() => 'CategoryModel(title: $title, image: $image)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.title == title &&
        other.image == image;
  }

  @override
  int get hashCode => title.hashCode ^ image.hashCode;
}

List<CategoryModel> listCategoryFake = [
  CategoryModel(title: 'Popular', image: 'assets/images/new_images/live.png'),
  CategoryModel(title: 'PK', image: 'assets/images/new_images/live.png'),
  CategoryModel(title: 'Stream', image: 'assets/images/new_images/live.png'),
  CategoryModel(title: 'New', image: 'assets/images/new_images/live.png'),
  CategoryModel(title: ' Party', image: 'assets/images/new_images/live.png'),
];
