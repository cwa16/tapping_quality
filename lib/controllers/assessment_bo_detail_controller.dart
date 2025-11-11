import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapping_quality/models/block_model.dart';
import 'package:tapping_quality/models/user_model.dart';
import 'package:tapping_quality/services/block_service.dart';
import 'package:tapping_quality/services/user_service.dart';

class AssessmentBoDetailController extends GetxController {
  var selectedDate = DateTime.now().obs;

  var userList = <UserModel>[].obs;

  var filteredUsers = <UserModel>[].obs;
  var selectedUser = Rx<UserModel?>(null);
  var blockList = <BlockModel>[].obs;
  var filteredBlocks = <BlockModel>[].obs;
  var selectedBlock = Rx<BlockModel?>(null);

  var treeSkinType = ['Perawan', 'Pulihan', 'NTA'].obs;
  var tappingPanel = ['HO', 'VH', 'GO'].obs;
  var taskList = ['A', 'B', 'C', 'D'].obs;
  var userID = 0.obs;

  final nikController = TextEditingController();
  final kemandoranController = TextEditingController();
  final departemenController = TextEditingController();
  final statusController = TextEditingController();
  final blokController = TextEditingController();
  final taskController = TextEditingController();
  final noHancakController = TextEditingController();
  final tahunTanamController = TextEditingController();
  final cloneController = TextEditingController();
  final sistemSadapController = TextEditingController();
  final treeSkinTypeController = TextEditingController();
  final tappingPanelController = TextEditingController();

  void updateDate(DateTime date) {
    selectedDate.value = date;
  }

  @override
  void onInit() async {
    super.onInit();
    await getUserID();
    resetAllFields();
    // Initialize the user list
    treeSkinType = ['Perawan', 'Pulihan', 'NTA'].obs;
    tappingPanel = ['HO', 'VH', 'GO', 'BO'].obs;
    taskList = ['A', 'B', 'C', 'D'].obs;

    try {
      // Fetch users from the UserService
      final prefs = await SharedPreferences.getInstance();
      final dept = prefs.getString('department') ?? '';
      print('Department: $dept');
      final users = await UserService().getTapper(dept);
      userList.value = users;
      filteredUsers.value = users;
      blockList.value = await BlockService().getBlocks();
      filteredBlocks.value = blockList;
      print('filteredBlokks: $filteredBlocks');
    } catch (e) {
      print('Error fetching users: $e');
      userList.value = [];
      filteredUsers.value = [];
    }
  }

  Future<void> getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    userID.value = prefs.getInt('userId') ?? 0;
  }

  // Method to filter users based on search query
  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers.value = userList;
    } else {
      filteredUsers.value =
          userList
              .where(
                (user) => user.name.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
  }

  // Method to update the selected user
  void updateSelectedUser(UserModel? user) {
    selectedUser.value = user;
    nikController.text = user?.nik ?? '';
    kemandoranController.text = user?.kemandoran ?? '';
    departemenController.text = user?.departemen ?? '';
    statusController.text = user?.status ?? '';
  }

  void filterBlocks(String query) {
    if (query.isEmpty) {
      filteredBlocks.value = blockList;
    } else {
      filteredBlocks.value =
          blockList
              .where(
                (block) =>
                    block.blockName.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
    }
  }

  void updateSelectedBlock(BlockModel? block) {
    selectedBlock.value = block;
    blokController.text = block?.blockName ?? '';
    tahunTanamController.text = block?.tahunTanam.toString() ?? '';
    cloneController.text = block?.clone ?? '';
  }

  void updateTreeSkinType(String type) {
    treeSkinTypeController.text = type;
  }

  void updateTask(String task) {
    taskController.text = task;
  }

  void updateTappingPanel(String panel) {
    tappingPanelController.text = panel;
  }

  void resetAllFields() {
    nikController.clear();
    kemandoranController.clear();
    departemenController.clear();
    statusController.clear();
    blokController.clear();
    taskController.clear();
    noHancakController.clear();
    tahunTanamController.clear();
    cloneController.clear();
    sistemSadapController.clear();
    treeSkinTypeController.clear();
    tappingPanelController.clear();

    selectedUser.value = null;
  }
}
