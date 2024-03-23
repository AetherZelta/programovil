class VideoModel {
  String? name;
  String? key;
  String? site;

  VideoModel({this.name, this.key, this.site});
  factory VideoModel.fromMap(Map<String, dynamic> video) {
    return VideoModel(
        name: video['name'], key: video['key'], site: video['site']);
  }
}
