import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Pages/login_page.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Pages/signup_page.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Widgets/screen_background.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _confirmPassWordController = TextEditingController();
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
                  'Reset Password',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  'Password should be more than 6 letters and combination of numbers.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _passWordController,
                  decoration: InputDecoration(hintText: 'Password'),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _confirmPassWordController,
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'Confirm Password'),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _onTapResetPasswordButton,
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
                          text: "Don't have an account?",
                          children: [
                            TextSpan(
                              text: ' Sign Up',
                              style: TextStyle(color: Colors.green),
                              recognizer: TapGestureRecognizer()..onTap = _onTapSignUpButton,
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


  void _onTapSignUpButton(){
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context)=>SignupPage()),
        (predicate)=>false
    );
  }

  void _onTapResetPasswordButton(){
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context)=>LoginPage()),
        (predicate)=>false
    );
  }

  @override
  void dispose() {
    _passWordController.dispose();
    _confirmPassWordController.dispose();
    super.dispose();
  }
}
