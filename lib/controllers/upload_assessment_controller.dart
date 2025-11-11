import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapping_quality/services/assessment_upload_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UploadAssessmentController extends GetxController {
  var assessmentDetails = <Map<String, dynamic>>[].obs;
  var uploadedAssessmentDetails = <Map<String, dynamic>>[].obs;
  var isUploading = false.obs;
  var isUploadingMap = <String, bool>{}.obs;
  var isAnyUploading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAssessmentDetails();
    getUploadedAssessmentDetails();
  }

  void getAssessmentDetails() async {
    // final prefs = await SharedPreferences.getInstance();
    // final userId = prefs.getInt('userId') ?? 0;
    final service = AssessmentUploadService();
    final data = await service.getAssessmentDetails();
    assessmentDetails.assignAll(data);
    // print('userId: $userId');
    // print('Assessment Details: $assessmentDetails');
  }

  void getUploadedAssessmentDetails() async {
    // final prefs = await SharedPreferences.getInstance();
    // final userId = prefs.getInt('userId') ?? 0;
    final service = AssessmentUploadService();
    final data = await service.getUploadedAssessmentDetails();
    uploadedAssessmentDetails.assignAll(data);
  }

  void uploadAssessment(Map<String, dynamic> data) async {
    isUploading.value = true;
    final url = Uri.parse('http://192.168.99.202/bskp-gate-tapping-qty/public/api/assessment-upload');
    final service = AssessmentUploadService();
    final id = data['assessment_id'].toString();
    final assessmentId = data['assessment_id'].toString();
    isUploadingMap[id] = true;
    isAnyUploading.value = true;
    try {
      print('Uploading assessment: ${data['assessment_id']}');

      // Get the transformed data ready for backend
      final payload = await service.getAssessmentForUpload(assessmentId);
      
      if (payload == null) {
        throw Exception('No assessment data found');
      }

      print('Payload: ${jsonEncode(payload)}');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successfully uploaded
        print('Assessment uploaded successfully');
        final responseData = jsonDecode(response.body);
        print('Success: ${responseData['success']}');
        print('Message: ${responseData['message']}');

        // Update assessment as uploaded
        await service.updateAssessmentDetails(data['assessment_code']);
        getAssessmentDetails();

        Get.snackbar(
          'Success',
          'Assessment uploaded successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        isUploadingMap[id] = false;
        isAnyUploading.value = false;
      } else {
        // Handle error
        Get.snackbar(
          'Error',
          'Failed to upload assessment: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print('Failed to upload assessment: ${response.body}');
        isUploading.value = false;
        isUploadingMap[id] = false;
        isAnyUploading.value = false;
      }
    } catch (e) {
      print('Error uploading assessment: $e');
      Get.snackbar(
        'Error',
        'An error occurred while uploading the assessment',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      isUploading.value = false;
      isUploadingMap[id] = false;
      isAnyUploading.value = false;
    } finally {
      isUploading.value = false;
      isUploadingMap[id] = false;
      isAnyUploading.value = false;
    }
  }
}
