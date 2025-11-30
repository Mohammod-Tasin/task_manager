import 'package:flutter/material.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/DATA/Models/task_model.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/DATA/Models/task_status_count_model.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/DATA/Services/api_caller.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/DATA/Utils/urls.dart';
import 'package:m_ten_to_inf/Module%2015/Task%20Manager%20Project/UI/Widgets/snack_bar_message.dart';

import '../Widgets/task_card.dart';
import '../Widgets/task_count_by_status_card.dart';

class CanceledTaskPage extends StatefulWidget {
  const CanceledTaskPage({super.key});

  @override
  State<CanceledTaskPage> createState() => _CanceledTaskPageState();
}

class _CanceledTaskPageState extends State<CanceledTaskPage> {

  @override
  void initState() {
    super.initState();
    // Page load howar sathe sathe data ana shuru hobe
    _getAllTaskStatusCount();
    _getAllCancelledTasksList();
  }

  bool _getTaskStatusCountInProgress = false;
  List<TaskStatusCountModel> _taskStatusCountList = [];

  bool _getCancelledTasksInProgress = false;
  List<TaskModel> _cancelledTaskList = [];

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


  Future<void> _getAllCancelledTasksList() async {
    _getCancelledTasksInProgress = true;
    setState(() {});
    final ApiResponse response = await ApiCaller.getRequest(
      url: Urls.cancelledTaskListUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _cancelledTaskList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }
    _getCancelledTasksInProgress = false;
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
              child:Visibility(
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
                visible: _getCancelledTasksInProgress == false,
                replacement: Center(child: CircularProgressIndicator(),),
                child: ListView.separated(
                  // CHANGE THIS LINE
                  itemCount: _cancelledTaskList.length, 
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskColor: Colors.red,
                      taskStatus: 'Pending',
                      taskModel: _cancelledTaskList[index],
                      refreshParent: _getAllCancelledTasksList,
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

