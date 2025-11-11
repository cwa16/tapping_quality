import 'package:get/get.dart';
import 'package:tapping_quality/helpers/database_helper.dart';

class AssessmentResultService extends GetxController {
  Future<List<Map<String, dynamic>>> getAssessmentResult(
    String nikPenyadap,
    dynamic date,
  ) async {
    final excludeIds = [4, 8, 19, 22, 25, 31, 34, 35, 38, 40, 42];
    final placeholders = List.filled(excludeIds.length, '?').join(', ');
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT assessment_details.nik_penyadap, tappers.name, tappers.status, tappers.kemandoran, tappers.departemen, assessment_details.task, assessment_details.jenis_kulit_pohon, assessment_details.panel_sadap, assessment_details.jenis_kulit_pohon, criteria.name as criteria_name, criteria.description as desc, SUM(criteria.score) as sum_score, assessment_details.tanggal_inspeksi, assessment_details.inspection_by, tree_assessments.tree_id FROM tree_assessments LEFT JOIN assessment_details ON tree_assessments.assessment_detail_id = assessment_details.id LEFT JOIN tappers ON assessment_details.nik_penyadap = tappers.nik LEFT JOIN criteria ON criteria.id = tree_assessments.criteria_id WHERE assessment_details.nik_penyadap = ? AND DATE(assessment_details.tanggal_inspeksi) = ? AND criteria.id NOT IN ($placeholders) GROUP BY criteria.id ORDER BY criteria.id ASC',
      [nikPenyadap, date, ...excludeIds],
    );
    print(date);
    print('Assessment Result: $result');
    return result;
  }

  // Future<List<Map<String, dynamic>>> getAssessmentResultTest() async {
  //   final db = await DatabaseHelper().database;
  //   final List<Map<String, dynamic>> result = await db.rawQuery(
  //     'SELECT assessment_details.nik_penyadap, users.name, users.kemandoran, users.departemen, assessment_details.task, assessment_details.jenis_kulit_pohon, AVG(criteria.score) as avg_score FROM assessment_details LEFT JOIN users ON assessment_details.nik_penyadap = users.nik LEFT JOIN tree_assessments ON assessment_details.id = tree_assessments.assessment_detail_id LEFT JOIN criteria ON criteria.id = tree_assessments.criteria_id',
  //   );
  //   print('Assessment Result: $result');
  //   return result;
  // }

  Future<List<Map<String, dynamic>>> getAssessmentReport(
    String nik,
    dynamic date,
  ) async {
    final excludeIds = [4, 8, 19, 22, 25, 31, 34, 35, 38, 40, 42];
    final placeholders = List.filled(excludeIds.length, '?').join(', ');
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT assessment_details.nik_penyadap, tappers.name, tappers.kemandoran, tappers.departemen, assessment_details.task, assessment_details.jenis_kulit_pohon, assessment_details.panel_sadap, assessment_details.jenis_kulit_pohon, criteria.name as criteria_name, criteria.description as desc, SUM(criteria.score) as sum_score, assessment_details.tanggal_inspeksi, assessment_details.inspection_by, tree_assessments.tree_id FROM tree_assessments LEFT JOIN assessment_details ON tree_assessments.assessment_detail_id = assessment_details.id LEFT JOIN tappers ON assessment_details.nik_penyadap = tappers.nik LEFT JOIN criteria ON criteria.id = tree_assessments.criteria_id WHERE assessment_details.nik_penyadap = ? AND DATE(assessment_details.tanggal_inspeksi) = ? AND criteria.id NOT IN ($placeholders) GROUP BY criteria.id ORDER BY criteria.id ASC',
      [nik, date, ...excludeIds],
    );

    print('Assessment Result: $result');
    return result;
  }
}
