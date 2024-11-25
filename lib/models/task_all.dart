import 'package:uuid/uuid.dart';

import 'task_type.dart';

// Database table field notations
const String tableName = "todoTable";

const String idFN = "id";
const String titleFN = "title";
const String detailsFN = "details";
const String taskTypeFN = "tasktype";
const String userFN = "user";
const String teamFN = "team";
const String crtedDateFN = "crtedDate";
const String statusFN = "status";
const String isSyncedFN = "isSynced"; // New field for sync status

const List<String> taskColumns = [
  idFN,
  titleFN,
  detailsFN,
  taskTypeFN,
  userFN,
  teamFN,
  crtedDateFN,
  statusFN,
  isSyncedFN, // Include in columns
];

// Task model to describe needed parameters the object task takes
class TaskAll {
  final String id; // Updated to String for UUID support
  final String title;
  final String? details;
  final DateTime crtedDate;
  final String user;
  final String? team;
  final TaskType taskType;
  bool status;
  bool isSynced; // New field to track sync status

  TaskAll({
    String? id,
    required this.title,
    this.details,
    required this.user,
    this.team,
    required this.taskType,
    required this.crtedDate,
    required this.status,
    this.isSynced = false, // Default value for new todos
  }) : id = id ?? Uuid().v4(); // Assign UUID if id is null

  static TaskAll fromJson(Map<String, dynamic> json) => TaskAll(
        id: json[idFN] as String, // Expecting id to be a String
        title: json[titleFN] as String,
        details: json[detailsFN] as String?,
        taskType: TaskTypeExtn.fromString(json[taskTypeFN] as String),
        user: json[userFN] as String,
        team: json[teamFN] as String?,
        crtedDate: DateTime.parse(json[crtedDateFN] as String),
        status: json[statusFN] == 1,
        isSynced: json[isSyncedFN] == 1, // Read sync status
      );

  Map<String, dynamic> toJson() {
    final data = {
      idFN: id, // Ensure id is included as a String
      titleFN: title,
      detailsFN: details,
      taskTypeFN: taskType.name,
      userFN: user,
      teamFN: team,
      crtedDateFN: crtedDate.toIso8601String(),
      statusFN: status ? 1 : 0,
      isSyncedFN: isSynced ? 1 : 0, // Write sync status
    };
    return data;
  }

  TaskAll copyWith({
    String? id, // Changed to String
    String? title,
    String? details,
    TaskType? taskType,
    String? user,
    String? team,
    DateTime? crtedDate,
    bool? status,
    bool? isSynced, // Include in copyWith
  }) =>
      TaskAll(
        id: id ?? this.id,
        title: title ?? this.title,
        details: details ?? this.details,
        taskType: taskType ?? this.taskType,
        user: user ?? this.user,
        team: team ?? this.team,
        crtedDate: crtedDate ?? this.crtedDate,
        status: status ?? this.status,
        isSynced: isSynced ?? this.isSynced,
      );
}
