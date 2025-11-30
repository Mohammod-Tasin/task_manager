import 'package:flutter/material.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/DATA/Models/task_model.dart';

import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/DATA/Models/task_status_count_model.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/DATA/Services/api_caller.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/DATA/Utils/urls.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Widgets/snack_bar_message.dart';

import '../Widgets/task_card.dart';
import '../Widgets/task_count_by_status_card.dart';

class ProgressTaskPage extends StatefulWidget {
  const ProgressTaskPage({super.key});

  @override
  State<ProgressTaskPage> createState() => _ProgressTaskPageState();
}

class _ProgressTaskPageState extends State<ProgressTaskPage> {

  @override
  void initState() {
    super.initState();
    // Page load howar sathe sathe data ana shuru hobe
    _getAllTaskStatusCount();
    _getAllProgressTasksList();
  }


  bool _getTaskStatusCountInProgress = false;
  List<TaskStatusCountModel> _taskStatusCountList = [];

  bool _getPendingTasksInProgress = false;
  List<TaskModel> _pendingTaskList = [];

  Future<void> _getAllTaskStatusCount() async {
    _getTaskStatusCountInProgress = true;
    setState(() {});
    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.taskStatusCountUrl,
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

  Future<void> _getAllProgressTasksList() async {
    _getPendingTasksInProgress = true;
    setState(() {});
    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.pendingTaskListUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _pendingTaskList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getPendingTasksInProgress = false;
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
                replacement: Center(child: CircularProgressIndicator(),),
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
                visible: _getPendingTasksInProgress == false,
                replacement: Center(child: CircularProgressIndicator(),),
                child: ListView.separated(
                  // CHANGE THIS LINE
                  itemCount: _pendingTaskList.length, 
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskColor: Colors.purpleAccent,
                      taskStatus: 'Pending',
                      taskModel: _pendingTaskList[index],
                      refreshParent: _getAllProgressTasksList,
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
    );
  }
}
