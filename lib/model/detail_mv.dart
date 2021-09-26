class DetailMV {
  final int id;
  final String url;
  final int r;
  final int size;

  DetailMV({
    required this.id,
    required this.url,
    required this.r,
    required this.size,
  });
  DetailMV.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        url = map['url'],
        r = map['r'],
        size = map['size'];
}
