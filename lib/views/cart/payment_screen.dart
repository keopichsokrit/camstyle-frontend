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
  // --- LOGIC PRESERVED ---
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
    final theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: theme.primaryColor.withOpacity(0.5)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Icon(Icons.check_circle_outline, color: theme.primaryColor, size: 80),
            const SizedBox(height: 20),
            Text(
              "PAYMENT SUCCESS",
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Your transaction was completed.",
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.hintColor),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: theme.scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.userHome, (route) => false),
                child: const Text("CONTINUE", style: TextStyle(fontWeight: FontWeight.bold)),
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
  // -----------------------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor; // Luxury Gold
    final scaffoldBg = theme.scaffoldBackgroundColor; // Midnight Black

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "CHECKOUT",
          style: TextStyle(color: primaryColor, letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [theme.colorScheme.surface.withOpacity(0.1), scaffoldBg],
          ),
        ),
        child: isLoading
            ? Center(child: CircularProgressIndicator(color: primaryColor))
            : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    children: [
                      // 1. Merchant Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: theme.cardColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "CAMSTYLE LUXE",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: primaryColor,
                                letterSpacing: 3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "INV #$billNumber",
                              style: TextStyle(color: theme.hintColor.withOpacity(0.5), fontSize: 12),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Divider(thickness: 0.5),
                            ),
                            const Text("Total Amount Due", style: TextStyle(fontSize: 14)),
                            const SizedBox(height: 5),
                            Text(
                              "\$${totalAmount.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30),

                      // 2. QR Section
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white, // QR needs white background to be scannable
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "SCAN KHQR TO PAY",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 25),
                            QrImageView(
                              data: qrString!,
                              version: QrVersions.auto,
                              size: 240.0,
                              eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Colors.black),
                              dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Colors.black),
                            ),
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.grey.shade400),
                                ),
                                const SizedBox(width: 15),
                                const Text(
                                  "Awaiting Payment...",
                                  style: TextStyle(color: Colors.grey, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      Text(
                        "Please do not close this screen while payment is processing.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.hintColor.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}