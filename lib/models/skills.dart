class Skill {
  final String name;
  final String level;
  final String image;
  final String description;

  Skill({
    required this.name,
    required this.level,
    required this.image,
    required this.description,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'],
      level: json['level'],
      image: json['image'],
      description: json['description'] ?? "No description available.",
    );
  }
}
