import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapping_quality/controllers/assessment_ho_detail_controller.dart';
import 'package:tapping_quality/controllers/assessment_ho_input_controller.dart';
import 'package:tapping_quality/models/block_model.dart';
import 'package:tapping_quality/models/user_model.dart';
import 'package:tapping_quality/pages/assessment/assessment_ho/input_assessment_ho.dart';
import 'package:tapping_quality/services/assessment_detail_ho_service.dart';

class AddAssessmentHo extends StatelessWidget {
  const AddAssessmentHo({super.key});

  @override
  Widget build(BuildContext context) {
    final AssessmentHoDetailController dateController = Get.put(
      AssessmentHoDetailController(),
    );

    final AssessmentHoDetailController userController = Get.put(
      AssessmentHoDetailController(),
    );

    final AssessmentHoDetailController blockController = Get.put(
      AssessmentHoDetailController(),
    );

    String generateRandomCode() {
      const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      final Random random = Random();

      // Generate 16 random characters
      String randomString =
          List.generate(
            16,
            (index) => chars[random.nextInt(chars.length)],
          ).join();

      // Insert dashes to format as XXXX-XXXX-XXXX-XXXX
      return '${randomString.substring(0, 4)}-${randomString.substring(4, 8)}-${randomString.substring(8, 12)}-${randomString.substring(12, 16)}';
    }

    final service = Get.put(AssessmentDetailHoService());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Asesmen Sadap Atas',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Tanggal Inspeksi',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                      child: Obx(() {
                        return TextButton(
                          onPressed: () async {
                            // Show the date picker dialog
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: dateController.selectedDate.value,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );

                            // Update the selected date in the controller
                            dateController.updateDate(pickedDate!);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${dateController.selectedDate.value.day}/${dateController.selectedDate.value.month}/${dateController.selectedDate.value.year}",
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: DropdownMenu<UserModel>(
                    width: double.infinity,
                    hintText: 'Pilih Penyadap',
                    requestFocusOnTap: true,
                    menuHeight: 200,
                    enableFilter: true,
                    dropdownMenuEntries:
                        userController.userList
                            .map(
                              (user) => DropdownMenuEntry<UserModel>(
                               label: '${user.nik} ${user.name} (${user.departemen})',
                                value: user,
                              ),
                            )
                            .toList(),
                    onSelected: (value) {
                      userController.updateSelectedUser(value);
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: TextField(
                  controller: userController.nikController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'NIK Penyadap',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: TextField(
                  controller: userController.statusController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: TextField(
                  controller: userController.kemandoranController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Kemandoran',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: TextField(
                  controller: userController.departemenController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Departemen',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: DropdownMenu<BlockModel>(
                    width: double.infinity,
                    hintText: 'Pilih Blok',
                    requestFocusOnTap: true,
                    enableFilter: true,
                    menuHeight: 200,
                    dropdownMenuEntries:
                        blockController.blockList
                            .map(
                              (block) => DropdownMenuEntry<BlockModel>(
                                label: block.blockCode,
                                value: block,
                              ),
                            )
                            .toList(),
                    onSelected: (value) {
                      blockController.updateSelectedBlock(value);
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: TextField(
                  controller: userController.tahunTanamController,
                  decoration: InputDecoration(
                    labelText: 'Tahun Tanam',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: TextField(
                  controller: userController.cloneController,
                  decoration: InputDecoration(
                    labelText: 'Clone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: DropdownMenu<String>(
                    controller:
                        TextEditingController(), // Optional: Add a controller if needed
                    width: double.infinity,
                    hintText: 'Task',
                    requestFocusOnTap: true,
                    dropdownMenuEntries:
                        userController.taskList
                            .map(
                              (type) => DropdownMenuEntry<String>(
                                label: type,
                                value: type,
                              ),
                            )
                            .toList(),
                    onSelected: (value) {
                      userController.updateTask(value!);
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: TextField(
                  controller: userController.noHancakController,
                  decoration: InputDecoration(
                    labelText: 'No. Hancak (1-25)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white),
                child: TextField(
                  controller: userController.sistemSadapController,
                  decoration: InputDecoration(
                    labelText: 'Sistem Sadap',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: DropdownMenu<String>(
                    controller:
                        TextEditingController(), // Optional: Add a controller if needed
                    width: double.infinity,
                    hintText: 'Panel Sadap',
                    requestFocusOnTap: true,
                    dropdownMenuEntries:
                        userController.tappingPanel
                            .map(
                              (type) => DropdownMenuEntry<String>(
                                label: type,
                                value: type,
                              ),
                            )
                            .toList(),
                    onSelected: (value) {
                      userController.updateTappingPanel(value!);
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 15),
            Obx(() {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: DropdownMenu<String>(
                    controller:
                        TextEditingController(), // Optional: Add a controller if needed
                    width: double.infinity,
                    hintText: 'Jenis Kulit Pohon',
                    requestFocusOnTap: true,
                    dropdownMenuEntries:
                        userController.treeSkinType
                            .map(
                              (type) => DropdownMenuEntry<String>(
                                label: type,
                                value: type,
                              ),
                            )
                            .toList(),
                    onSelected: (value) {
                      userController.updateTreeSkinType(value!);
                    },
                  ),
                ),
              );
            }),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                top: 8.0,
                right: 8.0,
                bottom: 100.0,
              ),
              child: GestureDetector(
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final String? inspectionBy = prefs.getString('name');
                  print('Inspection By: $inspectionBy');
                  final Map<String, dynamic> data = {
                    'assessment_code': generateRandomCode(),
                    'tanggal_inspeksi':
                        dateController.selectedDate.value.toString(),
                    'blok': blockController.blokController.text,
                    'task': userController.taskController.text,
                    'no_hancak': userController.noHancakController.text,
                    'tahun_tanam': blockController.tahunTanamController.text,
                    'clone': blockController.cloneController.text,
                    'kemandoran': userController.kemandoranController.text,
                    'sistem_sadap': userController.sistemSadapController.text,
                    'jenis_sadap': 'HO',
                    'panel_sadap': userController.tappingPanelController.text,
                    'jenis_kulit_pohon':
                        userController.treeSkinTypeController.text,
                    'nik_penyadap': userController.nikController.text,
                    'inspection_by': inspectionBy,
                  };

                  final Map<String, dynamic> details = await service
                      .insertAssessmentDetails(data);
                  Get.delete<AssessmentHoInputController>();
                  Get.to(
                    () => InputAssessmentHo(
                      assessmentDetailId: details['id'],
                      inspectionDate: details['tanggal_inspeksi'],
                      nikPenyadap: details['nik_penyadap'],
                    ),
                  );
                  userController.resetAllFields();
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue[600],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'SUBMIT',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
