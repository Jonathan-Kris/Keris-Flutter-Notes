import 'package:flutternotes/services/crud/constants/db_column.dart';

class DatabaseNote {
  final int id;
  final int userId;
  final String? content;
  final bool isSyncWithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    this.content,
    required this.isSyncWithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object> map)
      : id = map[idCol] as int,
        userId = map[userCol] as int,
        content = map[contentCol] as String?,
        isSyncWithCloud = map[isSyncWithCloudCol] == 1 ? true : false;

  @override
  String toString() =>
      "Notes, ID = $id, UserID = $userId, isSyncWithCloud = $isSyncWithCloud";

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
