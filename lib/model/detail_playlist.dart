class DetailPlayList {
  final String name;
  final int id;
  final List<String> ar_name;
  final String al_name;
  final String picUrl;
  int? subscribedCount;
  bool subscribed;

  DetailPlayList({
    required this.name,
    required this.id,
    required this.ar_name,
    required this.al_name,
    required this.picUrl,
    this.subscribed = false,
    this.subscribedCount,
  });

  DetailPlayList.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        id = map['id'],
        ar_name = map['ar'].map<String>((e) => e['name'].toString()).toList(),
        al_name = map['al']['name'],
        picUrl = map['al']['picUrl'],
        subscribed = map['subscribed'] ?? false,
        subscribedCount = map['subscribedCount'];
}
