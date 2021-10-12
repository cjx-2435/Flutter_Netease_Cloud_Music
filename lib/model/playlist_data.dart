class PlayListData {
  final int id;
  final String name;
  final String coverImgUrl;
  final int updateTime;
  bool? subscribed;
  final int subscribedCount;

  PlayListData(
      {required this.id,
      required this.name,
      required this.coverImgUrl,
      required this.updateTime,
      required this.subscribed,
      required this.subscribedCount});

  PlayListData.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        coverImgUrl = map['coverImgUrl'],
        updateTime = map['updateTime'],
        subscribed = map['subscribed'],
        subscribedCount = map['subscribedCount'];
}
