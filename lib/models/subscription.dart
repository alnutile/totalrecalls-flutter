class Subscription {
  int id;
  String name;

  Subscription(this.id, this.name);

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(json['id'], json['name']);
  }
}
