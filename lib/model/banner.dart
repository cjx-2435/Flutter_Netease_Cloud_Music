class BannerModel {
  BannerModel({
    required this.imageUrl,
    required this.targetId,
    required this.targetType,
    required this.titleColor,
    required this.typeTitle,
  });
  BannerModel.fromMap(Map<String, dynamic> map)
      : imageUrl = map['imageUrl'],
        targetId = map['targeetId'],
        targetType = map['targetType'],
        titleColor = map['titleColor'],
        typeTitle = map['typeTitle'];
  String imageUrl;
  int? targetId;
  int? targetType;
  String? titleColor;
  String? typeTitle;
}
