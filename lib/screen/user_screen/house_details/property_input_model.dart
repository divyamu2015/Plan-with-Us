class PropertyDetailModel {
  String message;
  List<PropertyImage> images;

  PropertyDetailModel({
    required this.message,
    required this.images,
  });

  factory PropertyDetailModel.fromJson(Map<String, dynamic> json) {
    return PropertyDetailModel(
      message: json['message'] ?? '',
      images: json['images'] != null
          ? (json['images'] as List)
              .map((img) => PropertyImage.fromJson(img))
              .toList()
          : [],
    );
  }
}

class PropertyImage {
  int id;
  int category;
  String image;

  PropertyImage({
    required this.id,
    required this.category,
    required this.image,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      id: json['id'] ?? 0,
      category: json['category'] ?? 0,
      image: json['image'] ?? '',
    );
  }
}
