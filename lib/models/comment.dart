class Comment {
  Comment({
    required this.comment,
    required this.label,
    required this.uid,
    required this.date,
  });

  String comment;
  String label;
  String uid;
  DateTime date;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        comment: json["comment"],
        label: json["label"],
        uid: json["uid"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "comment": comment,
        "label": label,
        "uid": uid,
        "date": date.toIso8601String(),
      };
}
