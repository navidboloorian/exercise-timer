class Exercise {
  String name;
  String description;
  List<String> tags;
  int isTimed; // might switch to bool later
  int isWeighted; // might swtich to bool later

  Exercise(
      this.name, this.isTimed, this.isWeighted, this.description, this.tags);
}
