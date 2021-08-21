class Wallpaper {
  int id;
  Uri imageUri;
  List<String> tags = [];

  Wallpaper({required this.id, required this.imageUri, required this.tags});

  static Wallpaper formJson(Map data) {
    return Wallpaper(
        id: data['id'] ?? 0,
        imageUri: data['image_url'] ?? '',
        tags: data['tags'] ?? []);
  }
}
