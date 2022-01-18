class Subscribable {
  int id;
  String name;

  Subscribable(this.id, this.name);

  factory Subscribable.fromJson(Map<String, dynamic> json) {
    return Subscribable(json['id'], json['name']);
  }
}
