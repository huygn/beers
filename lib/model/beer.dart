class Beer {
  final int id;
  final String name;
  final String tagline;
  final String firstBrewed;
  final String description;
  final String imageUrl;
  final String contributedBy;

  Beer(
      {this.id,
      this.name,
      this.tagline,
      this.firstBrewed,
      this.description,
      this.imageUrl,
      this.contributedBy});

  factory Beer.fromJson(Map<String, dynamic> json) {
    return Beer(
      id: json['id'],
      name: json['name'],
      tagline: json['tagline'],
      firstBrewed: json['first_brewed'],
      description: json['description'],
      imageUrl: json['image_url'],
      contributedBy: json['contributed_by'],
    );
  }
}
