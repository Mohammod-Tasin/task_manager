import 'package:flutter/material.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/DATA/Models/task_model.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/DATA/Models/task_status_count_model.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/DATA/Services/api_caller.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Pages/add_new_task_screen.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Widgets/snack_bar_message.dart';

import '../../DATA/Utils/urls.dart';
import '../Widgets/task_card.dart';
import '../Widgets/task_count_by_status_card.dart';

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({super.key});

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  bool _getTaskStatusCountInProgress = false;
  List<TaskStatusCountModel> _taskStatusCountList = [];
  bool _getNewTasksInProgress = false;
  List<TaskModel> _newTaskList = [];

  @override
  void initState() {
    super.initState();
    _getAllTaskStatusCount();
    _getAllNewTasks();
  }

  Future<void> _getAllTaskStatusCount() async {
    _getTaskStatusCountInProgress = true;
    setState(() {});
    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.taskStatusCountUrl
    );

    if (response.isSuccess) {
      List<TaskStatusCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskStatusCountModel.fromJson(jsonData));
      }
      _taskStatusCountList = list;
    } else {
      // ignore: use_build_context_synchronously
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getTaskStatusCountInProgress = false;
    setState(() {});
  }

  Future<void> _getAllNewTasks() async {
    _getNewTasksInProgress = true;
    setState(() {});
    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.newTaskListUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _newTaskList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getNewTasksInProgress = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 90,
              child: Visibility(
                visible: _getTaskStatusCountInProgress == false,
                replacement: Center(child: CircularProgressIndicator()),
                child: ListView.separated(
                  itemCount: _taskStatusCountList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return TaskCountByStatusCard(
                      title: _taskStatusCountList[index].status,
                      count: _taskStatusCountList[index].count,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 4);
                  },
                ),
              ),
            ),
            Expanded(
              child: Visibility(
                visible: _getNewTasksInProgress == false,
                replacement: Center(child: CircularProgressIndicator()),
                child: ListView.separated(
                  itemCount: _newTaskList.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskColor: Colors.blue,
                      taskStatus: 'New',
                      taskModel: _newTaskList[index],
                      refreshParent: _getAllNewTasks, 
                      refreshCount: _getAllTaskStatusCount,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 8);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTaskPage,
        child: Icon(Icons.add),
      ),
    );
  }

  void _onTapAddNewTaskPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNewTaskScreen()),
    );
  }
}
