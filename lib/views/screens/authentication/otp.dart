import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/controllers/auth.dart';
import 'package:store_app/services/manage_http_response.dart';
import 'package:store_app/views/screens/authentication/login.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  const OTPScreen({super.key, required this.email});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  List<String> otpDigits = List.filled(6, '');
  bool _isLoading = false;

  void verifyOTP() async {
    // Verify the OTP
    if (otpDigits.every((digit) => digit.isNotEmpty)) {
      setState(() {
        _isLoading = true;
      });

      final otp = otpDigits.join();

      await _authController
          .verifyOTP(context: context, email: widget.email, otp: otp)
          .then((value) {
            setState(() {
              _isLoading = false;
            });
          })
          .catchError((error) {
            setState(() {
              _isLoading = false;
            });
            showSnackBar(context, 'Error verifying OTP: $error');
          });
    } else {
      showSnackBar(context, 'Please fill all the OTP fields');
    }
  }

  Widget buildOTPField(int index) {
    return Container(
      width: 45,
      height: 55,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '';
          }
          return null;
        },
        onChanged: (value) {
          if (value.isNotEmpty && value.length == 1) {
            otpDigits[index] = value;

            // Focus the next field
            if (index < 5) {
              FocusScope.of(context).nextFocus();
            }
          }
        },
        onFieldSubmitted: (value) {
          // Trigger the OTP verification if the last field is filled
          if (value.isNotEmpty &&
              index == 5 &&
              _formKey.currentState!.validate()) {
            verifyOTP();
          }
        },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          fillColor: Colors.grey.shade200,
          filled: true,
          counterText: '',
        ),
        maxLength: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'OTP Verification',
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Enter the OTP sent to ${widget.email} to verify your account',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, buildOTPField),
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      verifyOTP();
                    },
                    child: Container(
                      width: 319,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [Color(0xFFF96161), Color(0xFFFF9663)],
                        ),
                      ),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Verify OTP',
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
