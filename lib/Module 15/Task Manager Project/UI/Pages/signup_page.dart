import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/DATA/Services/api_caller.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Widgets/screen_background.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/DATA/Utils/urls.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Widgets/snack_bar_message.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  static const String name = '/sign-up';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _signUpInProgress = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 82),
                  Text(
                    'Join With Us',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator: (String? value) {
                      String inputText = value ?? '';
                      if (EmailValidator.validate(inputText) == false) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _firstNameController,
                    decoration: InputDecoration(hintText: 'First name'),
                    validator: (String? value) {
      
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter a first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _lastNameController,
                    decoration: InputDecoration(hintText: 'Last name'),
                    validator: (String? value) {
                      String inputText = value ?? '';
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter a last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _mobileController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Mobile'),
                    validator: (String? value) {
                      String inputText = value ?? '';
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter a valid mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passWordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Password'),
                    validator: (String? value) {
                      String inputText = value ?? '';
                      if ((value?.length ?? 0) <= 6) {
                        return 'Enter a password more than 6 letters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _signUpInProgress==false,
                    replacement: Center(child: CircularProgressIndicator(color: Colors.green,)),
                    child: FilledButton(
                      onPressed: _onTapSubmitBtn,
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
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
      ),
    );
  }

  void _onTapSubmitBtn() {
    if (_formKey.currentState!.validate()) {
      _signUpUser();
    }
  }

  Future<void> _signUpUser() async {
    _signUpInProgress = true;
    setState(() {});
    Map<String, dynamic> requestBody = {
      "email": _emailController.text.trim(),
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "mobile": _mobileController.text.trim(),
      "password": _passWordController.text,
    };

    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.registrationUrl,
      body: requestBody,
    );

    _signUpInProgress=false;
    setState(() {});

    if (response.isSuccess) {
      _clearTextFields();
      showSnackBarMessage(context, 'Registration successful! Please Login.');
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }

  }

  void _clearTextFields(){
    _emailController.clear();
    _firstNameController.clear();
    _lastNameController.clear();
    _mobileController.clear();
    _passWordController.clear();
  }

  void _onTapLoginButton() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passWordController.dispose();
    super.dispose();
  }
}