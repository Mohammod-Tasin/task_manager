import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/DATA/Models/user_model.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/DATA/Services/api_caller.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/DATA/Utils/urls.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Controllers/auth_controller.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Widgets/screen_background.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Widgets/snack_bar_message.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Widgets/t_m_app_bar.dart';

import '../Widgets/photo_picker_field.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  static String name = '/update-profile';

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;

  bool _updateProfileInProgress = false;

  @override
  void initState() {
    super.initState();
    UserModel user = AuthController.userModel!;
    _emailController.text = user.email;
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _mobileController.text = user.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(fromUpdateProfile: true),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 82),
                  Text(
                    'Update Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),

                  PhotoPickerField(
                    onTap: _pickImage,
                    selectedPhoto: _selectedImage,
                  ),

                  const SizedBox(height: 8),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _emailController,
                    decoration: InputDecoration(hintText: 'Email'),
                    enabled: false,
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
                    decoration: InputDecoration(hintText: 'Mobile'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    controller: _passWordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: 'Password(optional)'),
                    validator: (String? value) {
                      if ((value != null && value.isNotEmpty) &&
                          value.length < 6) {
                        return 'Enter a password more than 6 letter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _updateProfileInProgress == false,
                    replacement: Center(child: CircularProgressIndicator()),
                    child: FilledButton(
                      onPressed: _onTapUpdateButton,
                      child: Icon(Icons.arrow_circle_right_outlined),
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

  void _onTapUpdateButton() {
    if (_formKey.currentState!.validate()) {
      _updateUser();
    }
  }

  Future<void> _updateUser() async {
    _updateProfileInProgress = true;
    setState(() {});
    final Map<String, dynamic> requestBody = {
      "email": _emailController.text,
      "firstName": _firstNameController.text.trim(),
      "lastName": _lastNameController.text.trim(),
      "mobile": _mobileController.text.trim(),
    };
    if (_passWordController.text.isNotEmpty) {
      requestBody['password'] = _passWordController.text;
    }

    String? encodedPhoto;
    if (_selectedImage != null) {
      List<int> bytes = await _selectedImage!.readAsBytes();
      encodedPhoto = jsonEncode(bytes);
      requestBody['photo'] = encodedPhoto;
    }
    final ApiResponse response = await ApiCaller.postRequest(
      url: Urls.updateProfileUrl,
      body: requestBody,
    );
    _updateProfileInProgress = false;
    setState(() {});
    if (response.isSuccess) {
      _passWordController.clear();
      UserModel model = UserModel(
        id: AuthController.userModel!.id,
        email: _emailController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        mobile: _mobileController.text.trim(),
        photo: encodedPhoto ?? AuthController.userModel!.photo
      );
      await AuthController.updateUserData(model);
      showSnackBarMessage(context, 'Profile has been updated!');
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
  }

  Future<void> _pickImage() async {
    XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      _selectedImage = pickedImage;
      setState(() {});
    }
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
