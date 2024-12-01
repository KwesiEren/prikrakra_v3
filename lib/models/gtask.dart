import 'dart:convert';

class Task {
  String id;
  String title;
  String? details;

  bool status;

  Task({
    required this.id,
    required this.title,
    required this.details,
    required this.status,
  });

  // Create a copy of the Task with some updated fields
  Task copyWith({
    String? id,
    String? title,
    String? details,
    bool? status,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      details: details ?? this.details,
      status: status ?? this.status,
    );
  }

  // Convert a Todo object to a Map for storage in SharedPreferences
  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'details': details, 'status': status};
  }

  // Convert a Map to a Todo object
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        id: map['id'],
        title: map['title'],
        details: map['details'],
        status: map['status']);
  }

  // Convert Todo to a JSON string for easier storage in SharedPreferences
  String toJson() => json.encode(toMap());

  // Create a Todo from a JSON string
  factory Task.fromJson(String source) {
    return Task.fromMap(json.decode(source));
  }
}
