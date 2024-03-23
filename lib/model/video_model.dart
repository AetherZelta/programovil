class VideoModel {
  String? name;
  String? key;
  String? site;
  String? type;

  VideoModel({this.name, this.key, this.site, this.type});
  factory VideoModel.fromMap(Map<String, dynamic> video) {
    return VideoModel(
        name: video['name'],
        key: video['key'],
        site: video['site'],
        type: video['type']);
  }
}
