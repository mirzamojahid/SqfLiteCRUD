import 'dart:convert';

List<Mirza> mirzaFromJson(String str) => List<Mirza>.from(json.decode(str).map((x) => Mirza.fromJson(x)));

String mirzaToJson(List<Mirza> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Mirza {
    Mirza({
        required this.userId,
        required this.id,
        required this.title,
        required this.completed,
    });

    final int userId;
    final int id;
    final String title;
    final bool completed;

    factory Mirza.fromJson(Map<String, dynamic> json) => Mirza(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        completed: json["completed"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "completed": completed,
    };
}
