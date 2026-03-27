import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isOtpSent = false;
  bool _isLoading = false;

  // STEP 1: Request the OTP
  void _handleSendOtp() async {
    if (_emailController.text.isEmpty) {
      _showLocalError("Please enter your email");
      return;
    }
    
    setState(() => _isLoading = true);
    bool success = await AuthController.sendOTP(context, _emailController.text.trim());
    
    if (success) {
      setState(() => _isOtpSent = true);
    }
    setState(() => _isLoading = false);
  }

  // STEP 2: Verify OTP and Reset Password
  void _handleResetPassword() async {
    if (_otpController.text.length < 6) {
      _showLocalError("Enter a valid 6-digit OTP");
      return;
    }
    if (_passwordController.text.length < 6) {
      _showLocalError("Password must be at least 6 characters");
      return;
    }

    setState(() => _isLoading = true);
    await AuthController.resetPassword(
      context, 
      _emailController.text.trim(), 
      _otpController.text.trim(), 
      _passwordController.text.trim()
    );
    setState(() => _isLoading = false);
  }

  void _showLocalError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.orange),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset Password"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lock_reset, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              _isOtpSent ? "Check your Email" : "Forgot Password?",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _isOtpSent 
                ? "We sent a 6-digit code to ${_emailController.text}. Enter it below with your new password."
                : "Enter your email address to receive a password reset OTP code.",
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 40),

            // --- EMAIL FIELD ---
            TextField(
              controller: _emailController,
              enabled: !_isOtpSent, // Disable after sending OTP
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email Address",
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            // --- OTP & NEW PASSWORD FIELDS (Hidden until OTP is sent) ---
            if (_isOtpSent) ...[
              const SizedBox(height: 20),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: "6-Digit OTP",
                  counterText: "",
                  prefixIcon: const Icon(Icons.security),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  prefixIcon: const Icon(Icons.vpn_key_outlined),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],

            const SizedBox(height: 40),

            // --- ACTION BUTTON ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : (_isOtpSent ? _handleResetPassword : _handleSendOtp),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      _isOtpSent ? "Reset Password" : "Send OTP",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
              ),
            ),

            if (_isOtpSent)
              Center(
                child: TextButton(
                  onPressed: () => setState(() => _isOtpSent = false),
                  child: const Text("Use a different email"),
                ),
              ),
          ],
        ),
      ),
    );
  }
}