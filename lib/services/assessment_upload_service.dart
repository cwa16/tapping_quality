import 'package:tapping_quality/helpers/database_helper.dart';

class AssessmentUploadService {
  Future<List<Map<String, dynamic>>> getAssessmentDetails() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT assessment_details.*, assessment_details.id as assessment_id, tappers.*, tappers.id as tapper_id FROM assessment_details LEFT JOIN tappers ON assessment_details.nik_penyadap = tappers.nik WHERE assessment_details.foreman_upload_at IS NULL ORDER BY created_at DESC',
    );
    // print(userId);
    // print('Assessment Details: $result');

    return result;
  }

  Future<List<Map<String, dynamic>>> getTreeAssessment(int assessmentId) async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT tree_assessments.*, assessment_details.assessment_code FROM tree_assessments LEFT JOIN assessment_details ON assessment_details.id = tree_assessments.assessment_detail_id WHERE assessment_detail_id = ?',
      [assessmentId],
    );
    // print('Tree Assessment: $result');

    return result;
  }

  Future<List<Map<String, dynamic>>> getUploadedAssessmentDetails() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT assessment_details.*, tappers.* FROM assessment_details LEFT JOIN tappers ON assessment_details.nik_penyadap = tappers.nik WHERE assessment_details.foreman_upload_at IS NOT NULL ORDER BY created_at DESC',
    );
    // print(userId);
    // print('Uploaded Assessment Details: $result');

    return result;
  }

  Future<List<Map<String, dynamic>>> updateAssessmentDetails(
    String assessmentCode,
  ) {
    final db = DatabaseHelper().database;
    return db.then((database) async {
      final result = await database.rawQuery(
        'UPDATE assessment_details SET foreman_upload_at = datetime("now") WHERE assessment_code = ?',
        [assessmentCode],
      );
      return result;
    });
  }

  Future<Map<String, dynamic>?> getAssessmentForUpload(String assessmentId) async {
    final db = await DatabaseHelper().database;

    // First get the grouped criteria data
    final List<Map<String, dynamic>> criteriaResults = await db.rawQuery(
      '''SELECT assessment_details.nik_penyadap, tappers.name, tappers.kemandoran, 
       tappers.departemen, tappers.status, assessment_details.task, assessment_details.jenis_kulit_pohon, 
       assessment_details.panel_sadap, assessment_details.tahun_tanam, assessment_details.clone,
       assessment_details.blok, criteria.name as criteria_name, criteria.description as desc, 
       SUM(criteria.score) as sum_score, assessment_details.tanggal_inspeksi, 
       assessment_details.inspection_by, tree_assessments.tree_id, criteria.id as criteria_id
       FROM tree_assessments 
       LEFT JOIN assessment_details ON tree_assessments.assessment_detail_id = assessment_details.id 
       LEFT JOIN tappers ON assessment_details.nik_penyadap = tappers.nik 
       LEFT JOIN criteria ON criteria.id = tree_assessments.criteria_id 
        WHERE assessment_details.id = ?
       GROUP BY criteria.id 
       ORDER BY criteria.id ASC''',
       [assessmentId]
    );

    print('Criteria Results: $criteriaResults');

    if (criteriaResults.isEmpty) return null;

    // Transform to backend format
    return _transformToBackendFormat(criteriaResults);
  }

  Map<String, dynamic> _transformToBackendFormat(
    List<Map<String, dynamic>> criteriaResults,
  ) {
    if (criteriaResults.isEmpty) return {};

    // Get base data from first record (since all records have same base info)
    final baseRecord = criteriaResults.first;

    // Initialize the flattened payload with base assessment data
    final payload = <String, dynamic>{
      'tgl_inspeksi': baseRecord['tanggal_inspeksi'],
      'dept': baseRecord['departemen'],
      'nama_inspektur': baseRecord['inspection_by'],
      'nik_penyadap': baseRecord['nik_penyadap'],
      'nama_penyadap': baseRecord['name'],
      'status': baseRecord['status'],
      'kemandoran': baseRecord['kemandoran'],
      'blok': baseRecord['blok'],
      'task': baseRecord['task'],
      'tahun_tanam': baseRecord['tahun_tanam'],
      'clone': baseRecord['clone'],
      'panel_sadap': baseRecord['panel_sadap'],
      'jenis_kulit_pohon': baseRecord['jenis_kulit_pohon'],
    };

    // Map each criteria to its corresponding item column
    double totalScore = 0.0;
    for (final record in criteriaResults) {
      final criteriaId = record['criteria_id'] as int;
      final score = record['sum_score'] as double? ?? 0.0;
      totalScore += score;

      final itemKey = _mapCriteriaToItemKey(criteriaId);
      if (itemKey != null) {
        payload[itemKey] = score;
      }
    }

    // Calculate kelas based on jenis_kulit_pohon (using totalScore for calculation only)
    final jenisKulitPohon = baseRecord['jenis_kulit_pohon'] as String?;
    final kelasPerawan = _calculateKelasPerawan(jenisKulitPohon, totalScore);
    final kelasPulihan = _calculateKelasPulihan(jenisKulitPohon, totalScore);
    final kelasNta = _calculateKelasNta(jenisKulitPohon, totalScore);

    payload['kelas_perawan'] = kelasPerawan;
    payload['kelas_pulihan'] = kelasPulihan;
    payload['kelas_nta'] = kelasNta;

    return payload;
  }

  String? _mapCriteriaToItemKey(int criteriaId) {
    // Map your criteria IDs to backend item columns
    // Adjust this mapping based on your business logic:
    switch (criteriaId) {
      case 1 || 5:
        return 'item1_1';
      case 2 || 6:
        return 'item1_2';
      case 3 || 7:
        return 'item1_3';
      case 4:
        return 'item2_1';
      case 9:
        return 'item2_2';
      case 8:
        return 'item2_3';
      case 12:
        return 'item3_1';
      case 13:
        return 'item3_2';
      case 14:
        return 'item3_3';
      case 15:
        return 'item3_4';
      case 16:
        return 'item3_5';
      case 17:
        return 'item3_6';
      case 18:
        return 'item3_7';
      case 20 || 22:
        return 'item4_1';
      case 21 || 23:
        return 'item4_2';
      case 26:
        return 'item5_1';
      case 27:
        return 'item5_2';
      case 28:
        return 'item6_1';
      case 29:
        return 'item6_2';
      case 30:
        return 'item6_3';
      case 32:
        return 'item7_1';
      case 33:
        return 'item7_2';
      case 36:
        return 'item7_3';
      case 37:
        return 'item8';
      case 39:
        return 'item9';
      case 41:
        return 'item10';
      default:
        return null;
    }
  }

  String _calculateKelasPerawan(String? jenisKulitPohon, double totalScore) {
    if (jenisKulitPohon != "PERAWAN") return "-";

    if (totalScore <= 10.9) return "1";
    if (totalScore > 10 && totalScore <= 20.9) return "2";
    if (totalScore > 20 && totalScore <= 26.9) return "3";
    if (totalScore > 26 && totalScore <= 32.9) return "4";
    if (totalScore > 32) return "No Class";

    return "-";
  }

  String _calculateKelasPulihan(String? jenisKulitPohon, double totalScore) {
    if (jenisKulitPohon != "PULIHAN") return "-";

    if (totalScore <= 15.9) return "1";
    if (totalScore > 16 && totalScore <= 30.9) return "2";
    if (totalScore > 30 && totalScore <= 38.9) return "3";
    if (totalScore > 38 && totalScore <= 46.9) return "4";
    if (totalScore > 46) return "No Class";

    return "-";
  }

  String _calculateKelasNta(String? jenisKulitPohon, double totalScore) {
    // Same logic as pulihan for NTA
    if (jenisKulitPohon != "NTA") return "-";

    if (totalScore <= 15.9) return "1";
    if (totalScore > 16 && totalScore <= 30.9) return "2";
    if (totalScore > 30 && totalScore <= 38.9) return "3";
    if (totalScore > 38 && totalScore <= 46.9) return "4";
    if (totalScore > 46) return "No Class";

    return "-";
  }
}
