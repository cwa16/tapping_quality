import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tapping_quality/controllers/inspection_log_controller.dart';
import 'package:tapping_quality/controllers/upload_assessment_controller.dart';
import 'package:tapping_quality/controllers/user_controller.dart';
import 'package:tapping_quality/pages/assessment/choose_assessment_type.dart';
import 'package:tapping_quality/pages/assessment/upload_assessment.dart';
import 'package:tapping_quality/pages/assessment/upload_log_assessment.dart';
import 'package:tapping_quality/pages/inspection_log/inspection_log.dart';
import 'package:tapping_quality/pages/login_page.dart';
import 'package:tapping_quality/services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _topBar(),
            const SizedBox(height: 20),
            _topMenu(),
            const SizedBox(height: 10),
            _titleMenuSection(),
            const SizedBox(height: 10),
            _menuSection(context),
          ],
        ),
      ),
    );
  }

  Container _topMenu() {
    return Container(
      width: 360,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.blue,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            spreadRadius: 3.0,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(11),
      ),
    );
  }

  // Menu Section Start
  // This section contains the menu items that are displayed on the home page.
  Container _menuSection(BuildContext context) {
    return Container(
      width: 360,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.transparent,

        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to the Choose Assessment Type page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChooseAssessmentType(),
                      ),
                    );
                  },
                  child: _menuSection1(context),
                ),
                GestureDetector(
                  onTap: () {
                    Get.delete<InspectionLogController>();
                    // Navigate to the Choose Assessment Type page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InspectionLog(),
                      ),
                    );
                  },
                  child: _menuSection2(context),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.delete<UploadAssessmentController>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UploadAssessment(),
                      ),
                    );
                  },
                  child: _menuSection3(),
                ),
                GestureDetector(
                  onTap: () {
                    Get.delete<UploadAssessmentController>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UploadLogAssessment(),
                      ),
                    );
                  },
                  child: _menuSection4(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // This section is divided into four parts, each representing a menu item.
  // Menu 4
  Container _menuSection4() {
    return Container(
      width: 160,
      height: 135,
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(9),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            spreadRadius: 3.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  color: Colors.transparent,
                  child: Image.asset(
                    'assets/icons/file-history-line.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  color: Colors.transparent,
                  child: const Text(
                    'Log Upload\nAssessment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // // Menu 3
  Container _menuSection3() {
    return Container(
      width: 160,
      height: 135,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(9),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            spreadRadius: 3.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  color: Colors.transparent,
                  child: Image.asset(
                    'assets/icons/list-check-3.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  color: Colors.transparent,
                  child: const Text(
                    'Upload\nAssessment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Menu 2

  Container _menuSection2(context) {
    return Container(
      width: 160,
      height: 135,
      decoration: BoxDecoration(
        color: Colors.blue[400],
        borderRadius: BorderRadius.circular(9),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            spreadRadius: 3.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  color: Colors.transparent,
                  child: Image.asset(
                    'assets/icons/archive-stack-line.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  color: Colors.transparent,
                  child: const Text(
                    'Data\nAssessment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Menu 1
  Container _menuSection1(BuildContext context) {
    return Container(
      width: 160,
      height: 135,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(9),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            spreadRadius: 3.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  color: Colors.transparent,
                  child: Image.asset(
                    'assets/icons/file-add-line.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  color: Colors.transparent,
                  child: const Text(
                    'Tambah\nAssessment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // Menu Section End

  Container _titleMenuSection() {
    return Container(
      width: 360,
      height: 40,
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Menu',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Row _topBar() {
    final UserController userController = Get.put(UserController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 360,
                height: 50,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6.0,
                      spreadRadius: 3.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(
                        () => Text(
                          'Halo, ${userController.userName.value}',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Container(
                          //   margin: const EdgeInsets.only(),
                          //   width: 30,
                          //   height: 30,
                          //   decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.circular(50),
                          //     image: const DecorationImage(
                          //       image: AssetImage(
                          //         'assets/icons/notification-4-line.png',
                          //       ),
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () async {
                              // Call the logout function from AuthService
                              await AuthService().logout();
                              Get.to(() => LoginPage());
                            },
                            child: Container(
                              margin: const EdgeInsets.only(),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/icons/logout.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
