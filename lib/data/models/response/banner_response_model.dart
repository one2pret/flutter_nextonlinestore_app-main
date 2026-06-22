class Banner {
  final int? id;
  final String? title;
  final String? description;
  final String? image;
  final String? link;
  final int? sortOrder;
  final bool? isActive;

  Banner({
    this.id,
    this.title,
    this.description,
    this.image,
    this.link,
    this.sortOrder,
    this.isActive,
  });

  factory Banner.fromMap(Map<String, dynamic> map) {
    return Banner(
      id: map['id']?.toInt(),
      title: map['title'],
      description: map['description'],
      image: map['image'],
      link: map['link'],
      sortOrder: map['sortOrder']?.toInt(),
      isActive: map['isActive'],
    );
  }
}
