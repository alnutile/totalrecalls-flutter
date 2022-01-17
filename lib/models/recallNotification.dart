class RecallNotification {
  int id;
  String title;
  String body;
  int read;
  int watch;

  RecallNotification(this.id, this.title, this.body, this.read, this.watch);

  factory RecallNotification.fromJson(Map<String, dynamic> json) {
    return RecallNotification(
        json['id'], json['title'], json['body'], json['read'], json['watch']);
  }
}
