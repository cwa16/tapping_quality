import 'package:tapping_quality/helpers/database_helper.dart';
import 'package:tapping_quality/models/user_model.dart';

class UserService {
  final DatabaseHelper db = DatabaseHelper();

  Future<List<UserModel>> getTapper(String dept) async {
    final dbClient = await db.database;
    final result = await dbClient.query(
      'tappers',
      orderBy: 'name ASC',
    );
    print('Fetched Tappers: $result');
    return result.map((user) => UserModel.fromMap(user)).toList();
  }

  Future<List<UserModel>> getMandor(String department) async {
    final dbClient = await db.database;
    final result = await dbClient.query(
      'users',
      where: 'role = ? AND departemen = ?',
      whereArgs: ['Mandor'],
    );
    return result.map((user) => UserModel.fromMap(user)).toList();
  }
}
