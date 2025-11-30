import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Controllers/auth_controller.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Pages/login_page.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Pages/main_nav_bar_holder_page.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Widgets/screen_background.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/utils/asset_paths.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String name = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    await Future.delayed(Duration(seconds: 3));
    final bool isLoggedIn = await AuthController.isUserAlreadyLoggedin();

    if(isLoggedIn){
      await AuthController.getUserData();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, MainNavBarHolderPage.name);
    }else{
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, LoginPage.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ScreenBackground(
            child: Center(child: SvgPicture.asset(AssetPaths.LogoSvg)),
          ),
        ],
      ),
    );
  }
}
