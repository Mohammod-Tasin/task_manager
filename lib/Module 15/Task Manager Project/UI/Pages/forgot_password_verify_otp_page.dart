import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Pages/login_page.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Pages/reset_password_page.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Widgets/screen_background.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPasswordVerifyOtpPage extends StatefulWidget {
  const ForgotPasswordVerifyOtpPage({super.key});

  @override
  State<ForgotPasswordVerifyOtpPage> createState() =>
      _ForgotPasswordVerifyOtpPageState();
}

class _ForgotPasswordVerifyOtpPageState
    extends State<ForgotPasswordVerifyOtpPage> {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 82),
                Text(
                  'Enter Your OTP',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'A 6 digit OTP has been sent to your email address',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                PinCodeTextField(
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  controller: _otpController,
                  appContext: context,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _onTapToResetPassPage,
                  child: Icon(Icons.arrow_circle_right_outlined),
                ),
                const SizedBox(height: 36),
                Center(
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          text: "Already have an account?",
                          children: [
                            TextSpan(
                              text: ' Login',
                              style: TextStyle(color: Colors.green),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _onTapSignupButton,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignupButton() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (predicate) => false,
    );
  }

  void _onTapToResetPassPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResetPasswordPage()),
    );
  }

  @override
  void dispose() {
    // _otpController.dispose(); // pin code text field er darai ei page dispose hoe jay
    super.dispose();
  }
}
