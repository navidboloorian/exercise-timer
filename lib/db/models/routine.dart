class Routine {
  final int? id;
  final String name;
  final String description;
  final List<String> tags;

  const Routine({
    this.id,
    required this.name,
    required this.description,
    required this.tags,
  });

  Routine.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'],
        tags = map['tags'].isNotEmpty ? map['tags'].split(',') : [];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'tags': tags.join(','),
    };
  }
}
