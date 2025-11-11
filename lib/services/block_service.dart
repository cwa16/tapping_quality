import 'package:tapping_quality/helpers/database_helper.dart';
import 'package:tapping_quality/models/block_model.dart';

class BlockService {
  Future<List<BlockModel>> getBlocks() async {
    final db = await DatabaseHelper().database;
    final blocks = await db.query('blocks');
    print('Blocks from DB: $blocks');
    return blocks.map((block) => BlockModel.fromMap(block)).toList();
  }
}
