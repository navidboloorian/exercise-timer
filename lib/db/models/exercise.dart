class Exercise {
  final int? id;
  final String name;
  final String description;
  final bool isTimed; // might switch to bool later
  final bool isWeighted;
  final List<String> tags;

  const Exercise({
    this.id,
    required this.name,
    required this.description,
    required this.isTimed,
    required this.isWeighted,
    required this.tags,
  });

  Exercise.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'],
        isTimed = map['isTimed'],
        isWeighted = map['isWeighted'],
        tags = map['tags'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isTimed': isTimed ? 1 : 0,
      'isWeighted': isWeighted ? 1 : 0,
      'tags': tags
    };
  }
}
