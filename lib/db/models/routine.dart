class Routine {
  final int? id;
  final String name;
  final String description;
  final List exerciseList;

  const Routine({
    this.id,
    required this.name,
    required this.description,
    required this.exerciseList,
  });

  Routine.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        description = map['description'],
        exerciseList = map['exerciseList'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'exerciseList': exerciseList.toString(),
    };
  }
}
