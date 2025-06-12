import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late String phoneNumber;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    phoneNumber = ModalRoute.of(context)!.settings.arguments as String;
  }

  void _verifyOtp() {
    if (_formKey.currentState!.validate()) {
      String otp = _otpController.text.trim();

      // TODO: Call backend endpoint /verify-otp with phoneNumber & otp
      print("Verifying OTP: $otp for $phoneNumber");

      // Simulate success and go to home
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  void _resendOtp() {
    // TODO: Optional: Call backend again to resend OTP
    print("Resending OTP to $phoneNumber");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                "Enter the OTP sent to +91-$phoneNumber",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: "OTP",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.length != 6) {
                    return "Enter 6-digit OTP";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOtp,
                child: const Text("Verify"),
              ),
              TextButton(
                onPressed: _resendOtp,
                child: const Text("Resend OTP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
