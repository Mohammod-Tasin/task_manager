import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Pages/forgot_password_verify_otp_page.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Widgets/screen_background.dart';

class ForgotPasswordVerifyByEmailPage extends StatefulWidget {
  const ForgotPasswordVerifyByEmailPage({super.key});

  @override
  State<ForgotPasswordVerifyByEmailPage> createState() =>
      _ForgotPasswordVerifyByEmailPageState();
}

class _ForgotPasswordVerifyByEmailPageState
    extends State<ForgotPasswordVerifyByEmailPage> {
  final TextEditingController _emailController = TextEditingController();
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
                  'Your Email Address',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'A 6 digit OTP will be sent to your email address',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: 'Email'),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _onTapNextButton,
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
                                ..onTap = _onTapLoginButton,
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

  void _onTapLoginButton() {
    Navigator.pop(context);
  }

  void _onTapNextButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPasswordVerifyOtpPage()),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
