import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../controllers/payment_controller.dart';
import '../../core/routes/app_routes.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? qrString;
  String? md5;
  double totalAmount = 0.0;
  String? billNumber;
  Timer? _timer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initiatePayment();
  }

  Future<void> _initiatePayment() async {
    final data = await PaymentController.generateKHQR();
    if (data != null) {
      setState(() {
        qrString = data['qrString'];
        md5 = data['md5'];
        totalAmount = (data['totalAmount'] as num).toDouble();
        billNumber = data['billNumber'];
        isLoading = false;
      });
      _startPolling();
    } else {
      // Handle error (e.g., cart empty)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to generate QR. Is your cart empty?")),
      );
      Navigator.pop(context);
    }
  }

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (md5 != null) {
        final status = await PaymentController.verifyStatus(md5!);
        if (status == 'success') {
          timer.cancel();
          _showSuccessUI();
        }
      }
    });
  }

  void _showSuccessUI() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 100),
            const SizedBox(height: 20),
            const Text("Success!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text("Your payment was successful"),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, AppRoutes.userHome, (route) => false),
                child: const Text("Back to Home", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text("Bakong KHQR"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Merchant Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Text("CAMSTYLE SHOP", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 8),
                        Text("Bill: $billNumber", style: const TextStyle(color: Colors.grey)),
                        const Divider(height: 30),
                        const Text("Total Amount", style: TextStyle(fontSize: 16)),
                        Text("\$${totalAmount.toStringAsFixed(2)}",
                            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.red)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // QR Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
                    ),
                    child: Column(
                      children: [
                        const Text("Scan with Bakong or any Bank App", 
                            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.blueGrey)),
                        const SizedBox(height: 20),
                        QrImageView(
                          data: qrString!,
                          version: QrVersions.auto,
                          size: 260.0,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            CircularProgressIndicator(strokeWidth: 2),
                            SizedBox(width: 15),
                            Text("Waiting for payment...", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}