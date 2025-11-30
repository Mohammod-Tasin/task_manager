import 'package:flutter/material.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Pages/canceled_task_page.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Pages/completed_task_page.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Pages/new_task_page.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Pages/progress_task_page.dart';

import '../Widgets/t_m_app_bar.dart';

class MainNavBarHolderPage extends StatefulWidget {
  const MainNavBarHolderPage({super.key});

  static String name = "/dashboard";

  @override
  State<MainNavBarHolderPage> createState() => _MainNavBarHolderPageState();
}

class _MainNavBarHolderPageState extends State<MainNavBarHolderPage> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    NewTaskPage(),
    ProgressTaskPage(),
    CanceledTaskPage(),
    CompletedTaskPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          _selectedIndex = index;
          setState(() {});
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.new_label_outlined),
            label: 'New',
          ),
          NavigationDestination(
            icon: Icon(Icons.refresh),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.cancel_outlined),
            label: 'Canceled',
          ),
          NavigationDestination(icon: Icon(Icons.done), label: 'Completed'),
        ],
      ),
    );
  }
}

