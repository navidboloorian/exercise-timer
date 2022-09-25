class Routine {
  final int? id;
  final String name;
  final String description;

  const Routine({
    this.id,
    required this.name,
    required this.description,
  });

  Routine.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
