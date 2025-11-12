import 'dart:io';
import 'package:get/get.dart';

class ConnectivityController extends GetxController {
  // Observable untuk menyimpan status koneksi
  // .obs membuat variabel ini menjadi reaktif (RxBool)
  final isConnectedToTarget = false.obs; 
  
  // Konfigurasi IP target
  final String targetIp = '192.168.99.202'; // GANTI dengan IP target Anda
  final int targetPort = 80; // GANTI dengan Port target Anda (misalnya 80, 443, dll.)
  
  // Status loading untuk UI
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Panggil pengecekan saat Controller pertama kali dibuat
    checkConnection(); 
  }

  // Fungsi inti untuk melakukan pengecekan "ping" ke IP spesifik
  Future<void> checkConnection() async {
    isLoading.value = true;
    try {
      // Coba koneksi soket TCP ke IP dan Port yang ditentukan
      final socket = await Socket.connect(
        targetIp,
        targetPort,
        timeout: const Duration(seconds: 5), // Batas waktu 5 detik
      );
      // Jika berhasil, update status
      socket.destroy();
      isConnectedToTarget.value = true;
      print('✅ GetX: Koneksi ke $targetIp berhasil!');

    } on SocketException catch (_) {
      // Jika gagal (SocketException), update status
      isConnectedToTarget.value = false;
      print('❌ GetX: Gagal koneksi ke $targetIp. Jaringan terputus atau server tidak merespons.');
    } catch (e) {
      isConnectedToTarget.value = false;
      print('❌ GetX: Error lain saat koneksi: $e');
    } finally {
      isLoading.value = false;
    }
  }
}