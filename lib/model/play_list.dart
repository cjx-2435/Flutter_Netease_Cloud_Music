class PlayList {
  final int id;
  final int type;
  final String name;
  final String copywriter;
  final String picUrl;
  int? playcount;
  int? playCount;

  PlayList({
    required this.id,
    required this.type,
    required this.name,
    required this.copywriter,
    required this.picUrl,
    required this.playcount,
    required this.playCount,
  });

  PlayList.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        type = map['type'],
        name = map['name'],
        copywriter = map['copywriter'],
        picUrl = map['picUrl'],
        playcount = map['playcount'],
        playCount = map['playCount'];
}
