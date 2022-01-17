class RecallNotification {
  int id;
  String title;

  RecallNotification({required this.id, required this.title});

  factory RecallNotification.fromJson(Map<String, dynamic> json) {
    return RecallNotification(
      id: json['id'],
      title: json['title'],
    );
  }
}
