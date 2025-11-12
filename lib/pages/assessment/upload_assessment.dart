import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tapping_quality/controllers/connectivity_controller.dart';
import 'package:tapping_quality/controllers/upload_assessment_controller.dart';

class UploadAssessment extends StatelessWidget {
  const UploadAssessment({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UploadAssessmentController());
    final connectivityController = Get.put(ConnectivityController());

    String formatTanggalInspeksi(String? dateStr) {
      if (dateStr == null) return 'N/A';
      try {
        final date = DateTime.parse(dateStr);
        return DateFormat('d MMM y').format(date);
      } catch (e) {
        return 'N/A';
      }
    }

    return Obx(() {
      if (connectivityController.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      // 2. Tampilkan Peringatan Koneksi
      if (!connectivityController.isConnectedToTarget.value) {
        return Scaffold(
          appBar: AppBar(title: const Text('Status Jaringan')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.signal_wifi_off, size: 80, color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    '❌ Jaringan atau Wi-Fi belum terhubung ke IP target (${connectivityController.targetIp}).',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi', style: TextStyle(fontSize: 16)),
                    onPressed: connectivityController.checkConnection, // Panggil fungsi dari controller
                  ),
                ],
              ),
            ),
          ),
        );
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Unggah Asesmen',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          shadowColor: Colors.black12,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Obx(() {
                final assessment = controller.assessmentDetails;
                final isAllNull =
                    assessment.isNotEmpty &&
                    assessment.first.values.every((value) => value == null);
                if (isAllNull) {
                  return Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/images/404-page.png',
                        width: 300,
                        height: 500,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.assessmentDetails.length,
                    itemBuilder: (context, index) {
                      final data = controller.assessmentDetails[index];
                      // print(data);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          height: 130,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Inspeksi Tanggal ${formatTanggalInspeksi(data['tanggal_inspeksi'])}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2.0),

                                  Text(
                                    'NIK Penyadap:  ${data['nik_penyadap'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Nama Penyadap: ${data['name'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Panel Sadap: ${data['panel_sadap'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'No Hancak: ${data['no_hancak'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Blok:  ${data['blok'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Task:  ${data['task'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (controller.isAnyUploading.value) {
                                            return; // Prevent tap if uploading
                                          }
                                          try {
                                            controller.uploadAssessment(data);
                                          } catch (e) {
                                            Get.snackbar(
                                              'Error',
                                              'Gagal mengunggah asesmen: $e',
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white,
                                            );
                                          }
                                        },
                                        child: Obx(() {
                                          final id =
                                              data['assessment_id'].toString();
                                          final isUploading =
                                              controller.isUploadingMap[id] ??
                                              false;
                                          final isAnyUploading =
                                              controller.isAnyUploading.value;

                                          return AbsorbPointer(
                                            absorbing:
                                                isAnyUploading &&
                                                !isUploading, // disable if another upload is running
                                            child:
                                                isUploading
                                                    ? const SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: Colors.blue,
                                                          ),
                                                    )
                                                    : Icon(
                                                      Icons.cloud_upload,
                                                      color:
                                                          isAnyUploading
                                                              ? Colors.grey
                                                              : Colors.blue,
                                                    ),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ],
          ),
        ),
      );
    });
  }
}
